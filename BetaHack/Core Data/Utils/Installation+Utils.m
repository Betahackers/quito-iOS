//
//  Installation.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "Installation+Utils.h"
#import "AFNetworking.h"

@implementation Installation (Utils)

static NSString *entityName = @"Installation";
static Installation *currentInstallation;

#pragma mark - Initialisation
+ (Installation*)currentInstallation {
    
    if (currentInstallation) {
        return currentInstallation;
    } else {
    
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
        NSArray *fetchedObjects = [[DomainManager sharedManager] executeFetchRequest:fetchRequest error:nil];
        if (!fetchedObjects || fetchedObjects.count == 0) {
            
            //create the Installation
            currentInstallation = (Installation*)[Installation createEntity];
            
            [CDFilter initWithJSON:nil type:kFilterCategory1 group:kFilterGroupCategory name:@"Eat"];
            [CDFilter initWithJSON:nil type:kFilterCategory2 group:kFilterGroupCategory name:@"Drink"];
            [CDFilter initWithJSON:nil type:kFilterCategory3 group:kFilterGroupCategory name:@"Healthy"];
            [CDFilter initWithJSON:nil type:kFilterCategory4 group:kFilterGroupCategory name:@"Walking"];
            [CDFilter initWithJSON:nil type:kFilterCategory5 group:kFilterGroupCategory name:@"Culture"];
            [CDFilter initWithJSON:nil type:kFilterCategory6 group:kFilterGroupCategory name:@"Shopping"];
            [CDFilter initWithJSON:nil type:kFilterCategory7 group:kFilterGroupCategory name:@"Live Music"];
            [CDFilter initWithJSON:nil type:kFilterCategory8 group:kFilterGroupCategory name:@"Dancing"];
            
            [CDFilter initWithJSON:nil type:kFilterEmotion1 group:kFilterGroupEmotion name:@"Illegal"];
            [CDFilter initWithJSON:nil type:kFilterEmotion2 group:kFilterGroupEmotion name:@"Dancing"];
            [CDFilter initWithJSON:nil type:kFilterEmotion3 group:kFilterGroupEmotion name:@"Adventure"];
            [CDFilter initWithJSON:nil type:kFilterEmotion4 group:kFilterGroupEmotion name:@"Philosophical"];
            [CDFilter initWithJSON:nil type:kFilterEmotion5 group:kFilterGroupEmotion name:@"Romantic"];
            [CDFilter initWithJSON:nil type:kFilterEmotion6 group:kFilterGroupEmotion name:@"Relaxed"];
            [CDFilter initWithJSON:nil type:kFilterEmotion7 group:kFilterGroupEmotion name:@"Solitary"];
            [CDFilter initWithJSON:nil type:kFilterEmotion8 group:kFilterGroupEmotion name:@"Active"];
            
        } else {
            currentInstallation = [fetchedObjects objectAtIndex:0];
        }
        
        return currentInstallation;
    }
}

+ (Installation*)createEntity {
    Installation *installation = (Installation *)[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[[DomainManager sharedManager] context]];
    return installation;
}

#pragma mark - articles
- (NSArray*)sortedArticles {
    return [self.articles sortSetByTextField:@"title"];
}

- (NSArray*)sortedProfiles {
    return [self.profiles sortSetByTextField:@"name"];
}

- (CDProfile*)profileWithID:(int)profileID {
    for (CDProfile *profile in self.profiles) {
        if (profile.identifier == profileID) {
            return profile;
        }
    }
    return nil;
}

- (CDLocation*)locationWithID:(int)locationID {
    for (CDLocation *location in self.locations) {
        if (location.identifier == locationID) {
            return location;
        }
    }
    return nil;
}

- (CDArticle*)articleWithID:(int)articleID {
    for (CDArticle *article in self.articles) {
        if (article.identifier == articleID) {
            return article;
        }
    }
    return nil;
}

- (NSArray*)sortedFilterByGroup:(FilterGroup)filterGroup {
    
    NSMutableArray *filters = [NSMutableArray array];
    for (CDFilter *filter in self.filters) {
        if (filter.filterGroup == filterGroup) {
            [filters addObject:filter];
        }
    }
    
    return [filters sortArrayByTextField:@"name"];
}

- (CDFilter*)filterOfType:(FilterType)filterType {
    for (CDFilter *filter in self.filters) {
        if (filter.filterType == filterType) {
            return filter;
        }
    }
    return nil;
}

#pragma mark - fetch articles
- (void)fetchArticles {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://fromto.es/v1/articles.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        //clear down the data store
        
        //add the articles
        NSDictionary *articlesDict = (NSDictionary*)responseObject;
        NSArray *articles = [articlesDict objectForKey:@"articles"];
        
       
        
        for (NSDictionary *articleDict in articles) {
            
            int articleID = [[articleDict objectForKey:@"id"] intValue];
            CDArticle *article = [[Installation currentInstallation] articleWithID:articleID];
            if (!article) {
                [CDArticle initWithJSON:articleDict];
            } else {
                [article updateWithJSON:articleDict];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
