//
//  CDLocation.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "CDLocation+Utils.h"
#import "DomainManager.h"
#import "AFNetworking.h"

@implementation CDLocation (Utils)

+ (id)initWithJSON:(NSDictionary*)json {
    
    CDLocation *location = (CDLocation *)[NSEntityDescription insertNewObjectForEntityForName:@"CDLocation" inManagedObjectContext:[[DomainManager sharedManager] context]];
    if (location) {
        
        location.installation = [Installation currentInstallation];
        
        location.identifier = [[json objectForKey:@"id"] intValue];
        [location updateWithJSON:json];
        
        [location removeArticles:location.articles];
        
        for (NSDictionary *articleHolderDict in [json objectForKey:@"articles"]) {
            
            NSDictionary *articleDict = [articleHolderDict objectForKey:@"article"];
            
            int articleID = [[articleDict objectForKey:@"id"] intValue];
            CDArticle *article = [[Installation currentInstallation] articleWithID:articleID];
            if (!article) {
                article = [CDArticle initWithJSON:articleDict];
            } else {
                [article updateWithJSON:articleDict];
            }
            
            [location addArticlesObject:article];
        }
    }
    
    return location;
}

- (void)updateWithJSON:(NSDictionary*)json {
    
    self.name = [json objectForKey:@"name"];
    self.longitude = [[json objectForKey:@"longitude"] floatValue];
    self.latitude = [[json objectForKey:@"latitude"] floatValue];
    
    if ([json objectForKey:@"foursquare"]) {
        NSDictionary *foursquareDict = [json objectForKey:@"foursquare"];
        self.foursquareJSON = [NSString stringWithFormat:@"%@", foursquareDict];
    }
}

- (UIImage*)image {
    
    //return the saved image if one exists
    if (self.locationImageData) {
        return [UIImage imageWithData:self.locationImageData];
    } else {
        return nil;
    }
}

#pragma mark - update Foursquare data
- (void)fetchFullLocation:(void (^)(NSError *error))completion {
    
    //no need to do this more than once
    if (self.foursquareJSON.length > 0) return;
    
    NSString *url = [NSString stringWithFormat:@"http://www.fromto.es/v2/locations/%d.json?include_foursquare=true", self.identifier];
    NSLog(@"URL: %@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDict = responseObject;
        NSDictionary *locationDict = [responseDict objectForKey:@"location"];
        
        [self updateWithJSON:locationDict];
        
        NSDictionary *foursquareDict = [locationDict objectForKey:@"foursquare"];
        [self fetchFirstImageFromFoursquareJSON:foursquareDict completion:^(NSError *error) {
            completion(nil);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(error);
    }];
}

- (void)fetchFirstImageFromFoursquareJSON:(NSDictionary*)json completion:(void (^)(NSError *error))completion {
    
    //get the first image
    NSDictionary *photos = [json objectForKey:@"photos"];
    if (photos) {
        NSArray *groups = [photos objectForKey:@"groups"];
        if (groups.count > 0) {
            NSDictionary *group = [groups firstObject];
            NSArray *items = [group objectForKey:@"items"];
            if (items.count > 0) {
                NSDictionary *item = [items firstObject];
                
                NSString *prefix = [item objectForKey:@"prefix"];
                NSString *suffix = [item objectForKey:@"suffix"];
                
                int width = [[item objectForKey:@"width"] intValue];
                int height = [[item objectForKey:@"height"] intValue];
                
                //amend the size to fit on the screen
                if (width > 640) {
                    float factor = 640.0f/width;
                    width = width * factor;
                    height = height * factor;
                }
                
                NSString *url = [NSString stringWithFormat:@"%@%dx%d%@", prefix, width, height, suffix];
                NSLog(@"URL: %@", url);
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"Response: %@", responseObject);
                    self.locationImageData = UIImageJPEGRepresentation(responseObject, 1.0);
                    completion(nil);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Image error: %@", error);
                }];
                [requestOperation start];
                
            } else {
                completion(nil);
            }
        } else {
            completion(nil);
        }
    } else {
        completion(nil);
    }
}
@end
