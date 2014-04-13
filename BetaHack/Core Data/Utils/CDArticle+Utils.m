//
//  CDArticle.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "CDArticle+Utils.h"
#import "DomainManager.h"

@implementation CDArticle (Utils)

+ (id)initWithJSON:(NSDictionary*)json {
    
    CDArticle *article = (CDArticle *)[NSEntityDescription insertNewObjectForEntityForName:@"CDArticle" inManagedObjectContext:[[DomainManager sharedManager] context]];
    if (article) {
        
        article.installation = [Installation currentInstallation];

        article.identifier = [[json objectForKey:@"id"] intValue];
        [article updateWithJSON:json];
    }
    
    return article;
}

- (void)updateWithJSON:(NSDictionary*)json {
    
    self.title = [json objectForKey:@"title"];
    
    NSDictionary *authorDict = [json objectForKey:@"author"];
    int profileID = [[authorDict objectForKey:@"id"] intValue];
    CDProfile *profile = [[Installation currentInstallation] profileWithID:profileID];
    if (!profile) {
        profile = [CDProfile initWithJSON:authorDict];
    } else {
        [profile updateWithJSON:authorDict];
    }
    self.profile = profile;
    
    
    [self removeLocations:self.locations];
    
    NSArray *locationsArray = [json objectForKey:@"locations"];
    for (NSDictionary *locationDict in locationsArray) {
        
        int locationID = [[locationDict objectForKey:@"id"] intValue];
        CDLocation *location = [[Installation currentInstallation] locationWithID:locationID];
        if (!location) {
            location = [CDLocation initWithJSON:locationDict];
        } else {
            [location updateWithJSON:locationDict];
        }
        [self addLocationsObject:location];
    }
}
@end
