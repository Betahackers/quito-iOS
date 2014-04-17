//
//  CDProfile.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "CDProfile+Utils.h"
#import "DomainManager.h"
#import "AFNetworking.h"

@implementation CDProfile (Utils)

+ (id)initWithJSON:(NSDictionary*)json {
    
    CDProfile *profile = (CDProfile *)[NSEntityDescription insertNewObjectForEntityForName:@"CDProfile" inManagedObjectContext:[[DomainManager sharedManager] context]];
    if (profile) {
        
        profile.installation = [Installation currentInstallation];
        
        profile.lastName = @"";
        profile.expertIn = @"being an expert.";
        profile.biography = @"Betahaus member with a passion for life.";
        profile.hometown = @"Barcelona, Catalunya";
        profile.jobTitle = @"FromTo team member";
        
        profile.identifier = [[json objectForKey:@"id"] intValue];
        [profile updateWithJSON:json];
    }
    
    return profile;
}

- (void)updateWithJSON:(NSDictionary*)json {
    
    NSString *firstName = [json objectForKey:@"first_name"];
    self.firstName = firstName;
    
    NSString *lastName = [json objectForKey:@"last_name"];
    if (lastName != (NSString *)[NSNull null]) {
        self.lastName = lastName;
    }
    
    NSString *expertIn = [json objectForKey:@"expert_in"];
    if (expertIn != nil) {
        if (expertIn != (NSString *)[NSNull null]) {
            self.expertIn = expertIn;
        }
        
        NSString *biography = [json objectForKey:@"about"];
        if (biography != (NSString *)[NSNull null]) {
            self.biography = biography;
        }
        
        NSString *hometown = [json objectForKey:@"nationality"];
        if (hometown != (NSString *)[NSNull null]) {
            self.hometown = hometown;
        }
        
        NSString *jobTitle = [json objectForKey:@"profession"];
        if (jobTitle != (NSString *)[NSNull null]) {
            self.jobTitle = jobTitle;
        }
        
        NSString *twitter = [json objectForKey:@"twitter_handle"];
        if (twitter != (NSString *)[NSNull null]) {
            self.twitter = twitter;
        }
        
        NSString *url = [json objectForKey:@"website_url"];
        if (url != (NSString *)[NSNull null]) {
            self.url = url;
        }
        
        NSString *dateString = [json objectForKey:@"updated_at"];;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *thisUpdatedDate = [dateFormatter dateFromString:dateString];
        
        if (![self.updatedDate isEqualToDate:thisUpdatedDate]) {
        
            self.updatedDate = thisUpdatedDate;
            
            //get the avatar URL
            NSString *avatarPrefix = [json objectForKey:@"avatar_url_prefix"];
            NSString *avatarSuffix = [json objectForKey:@"avatar_url_suffix"];
            NSString *photoURL = [NSString stringWithFormat:@"%@iphone_%@", avatarPrefix, avatarSuffix];
        
            //load the photo
            NSLog(@"URL: %@", photoURL);
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photoURL]];
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"Response: %@", responseObject);
                self.photoData = UIImageJPEGRepresentation(responseObject, 1.0);
                self.photoURL = photoURL;
                
                [[DomainManager sharedManager].context save:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"profilePhotoUpdated" object:self];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Image error: %@", error);
            }];
            [requestOperation start];
        }
    }
    
    [[DomainManager sharedManager].context save:nil];
}

- (NSString*)displayName {
    
    NSMutableString *displayName = [NSMutableString stringWithString:self.firstName];
    if (self.lastName.length > 0) {
        [displayName appendFormat:@" %@", self.lastName];
    }
    return displayName;
}

- (NSString*)shortDisplayName {
    
    NSMutableString *displayName = [NSMutableString stringWithString:self.firstName];
    if (self.lastName.length > 0) {
        NSString *surnameInitial = [self.lastName substringToIndex:1];
        [displayName appendFormat:@" %@.", surnameInitial];
    }
    return [displayName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (UIImage*)profileImage {
    if (self.photoData != nil) {
        return [UIImage imageWithData:self.photoData];
    } else {
        return [UIImage imageNamed:@"NoProfilePhoto.png"];
    }
}

- (NSDate*)updatedDate {
    return [NSDate dateWithTimeIntervalSinceReferenceDate:self.updatedDateInterval];
}

- (void)setUpdatedDate:(NSDate*)updatedDate {
    self.updatedDateInterval = [updatedDate timeIntervalSinceReferenceDate];
}

@end
