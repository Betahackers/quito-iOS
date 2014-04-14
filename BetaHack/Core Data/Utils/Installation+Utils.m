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
            
            [CDFilter initWithJSON:nil type:kFilterCategoryCulture group:kFilterGroupCategory name:@"Culture" jsonName:@"culture" imageName:@"culture.png"];
            [CDFilter initWithJSON:nil type:kFilterCategoryDancing group:kFilterGroupCategory name:@"Alternative" jsonName:@"alternative" imageName:@"alternative.png"];
            [CDFilter initWithJSON:nil type:kFilterCategoryDrink group:kFilterGroupCategory name:@"Drinks" jsonName:@"drinks" imageName:@"drinks.png"];
            [CDFilter initWithJSON:nil type:kFilterCategoryEat group:kFilterGroupCategory name:@"Food" jsonName:@"food" imageName:@"food.png"];
            [CDFilter initWithJSON:nil type:kFilterCategoryHealthyLife group:kFilterGroupCategory name:@"Healthy Life" jsonName:@"healthy_life" imageName:@"healthylife.png"];
            [CDFilter initWithJSON:nil type:kFilterCategoryLiveMusic group:kFilterGroupCategory name:@"Music" jsonName:@"music" imageName:@"music.png"];
            [CDFilter initWithJSON:nil type:kFilterCategoryShopping group:kFilterGroupCategory name:@"Shopping" jsonName:@"shopping" imageName:@"shopping.png"];
            [CDFilter initWithJSON:nil type:kFilterCategoryWalks group:kFilterGroupCategory name:@"Have a stroll" jsonName:@"have_a_stroll" imageName:@"haveastroll.png"];
            
            [CDFilter initWithJSON:nil type:kFilterEmotionIllegal group:kFilterGroupEmotion name:@"Lawbreaker" jsonName:@"lawbreaker" imageName:@"prison.png"];
            [CDFilter initWithJSON:nil type:kFilterEmotionSociable group:kFilterGroupEmotion name:@"Social" jsonName:@"social" imageName:@"sociable.png"];
            [CDFilter initWithJSON:nil type:kFilterEmotionAdventure group:kFilterGroupEmotion name:@"Adventure" jsonName:@"adventurous" imageName:@"Adventure.png"];
            [CDFilter initWithJSON:nil type:kFilterEmotionActive group:kFilterGroupEmotion name:@"Energetic" jsonName:@"energetic" imageName:@"active.png"];
            [CDFilter initWithJSON:nil type:kFilterEmotionCultural group:kFilterGroupEmotion name:@"Intellectual" jsonName:@"intellectual" imageName:@"philosophical.png"];
            [CDFilter initWithJSON:nil type:kFilterEmotionRomantic group:kFilterGroupEmotion name:@"Romantic" jsonName:@"romantic" imageName:@"Romantic.png"];
            [CDFilter initWithJSON:nil type:kFilterEmotionRelaxed group:kFilterGroupEmotion name:@"Relaxed" jsonName:@"relaxed" imageName:@"Relaxed.png"];
            [CDFilter initWithJSON:nil type:kFilterEmotionSolitary group:kFilterGroupEmotion name:@"Lonely" jsonName:@"lonely" imageName:@"solitary.png"];
            
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
    return [self.profiles sortSetByTextField:@"displayName"];
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
- (void)fetchLocationsWithRadius:(float)radius long:(float)longitude lat:(float)latitude completion:(void (^)(NSError *error))completion {
    
    NSString *url = [NSString stringWithFormat:@"http://fromto.es/v1/locations.json?ll=%f,%f&radius=%f&include_articles=true", latitude, longitude, radius];
    NSLog(@"URL: %@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self processLocationsResponse:responseObject];
        
        completion(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(error);
    }];
}

- (void)fetchLocationsWithRadius:(float)radius long:(float)longitude lat:(float)latitude filter:(CDFilter*)filter completion:(void (^)(NSError *error))completion {
    
    NSString *url = [NSString stringWithFormat:@"http://fromto.es/v1/locations.json?ll=%f,%f&radius=%f&mood=%@&include_articles=true", latitude, longitude, radius, filter.name.lowercaseString];
    NSLog(@"URL: %@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self processLocationsResponse:responseObject];
        
        completion(nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(error);
    }];
}

- (void)fetchLocationsWithRadius:(float)radius long:(float)longitude lat:(float)latitude profile:(CDProfile*)profile completion:(void (^)(NSError *error))completion {
    
    NSString *url = [NSString stringWithFormat:@"http://fromto.es/v1/locations.json?ll=%f,%f&radius=%f&user=%d&include_articles=true", latitude, longitude, radius, profile.identifier];
    NSLog(@"URL: %@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self processLocationsResponse:responseObject];
        
        completion(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(error);
    }];
}

- (void)fetchUsers:(void (^)(NSError *error))completion {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://fromto.es/v1/users.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //add the articles
        NSDictionary *usersDict = (NSDictionary*)responseObject;
        NSArray *users = [usersDict objectForKey:@"users"];
        
        for (NSDictionary *userDict in users) {
            
            int userID = [[userDict objectForKey:@"id"] intValue];
            CDProfile *user = [[Installation currentInstallation] profileWithID:userID];
            if (!user) {
                [CDProfile initWithJSON:userDict];
            } else {
                [user updateWithJSON:userDict];
            }
        }
        
        completion(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(error);
    }];
}

- (void)processLocationsResponse:(id)responseObject {
    NSLog(@"JSON: %@", responseObject);
    
    //clear down the data store
    
    //add the articles
    NSDictionary *locationsDict = (NSDictionary*)responseObject;
    NSArray *locations = [locationsDict objectForKey:@"locations"];
    
    for (NSDictionary *locationHolderDict in locations) {
        NSDictionary *locationDict = [locationHolderDict objectForKey:@"location"];
        
        int locationID = [[locationDict objectForKey:@"id"] intValue];
        CDLocation *location = [[Installation currentInstallation] locationWithID:locationID];
        if (!location) {
            [CDLocation initWithJSON:locationDict];
        } else {
            [location updateWithJSON:locationDict];
        }
    }
}

- (void)processArticlesResponse:(id)responseObject {
    NSLog(@"JSON: %@", responseObject);
    
    //clear down the data store
    
    //add the articles
    NSDictionary *articlesDict = (NSDictionary*)responseObject;
    NSArray *articles = [articlesDict objectForKey:@"articles"];
    
    for (NSDictionary *articleHolderDict in articles) {
        NSDictionary *articleDict = [articleHolderDict objectForKey:@"article"];
        
        int articleID = [[articleDict objectForKey:@"id"] intValue];
        CDArticle *article = [[Installation currentInstallation] articleWithID:articleID];
        if (!article) {
            [CDArticle initWithJSON:articleDict];
        } else {
            [article updateWithJSON:articleDict];
        }
    }
}
@end
