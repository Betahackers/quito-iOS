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

        article.intro = @"Awesome place.  Worth a visit";
        
        article.identifier = [[json objectForKey:@"id"] intValue];
        [article updateWithJSON:json];
        
        article.defaultFilterGroupColourRaw = arc4random() % 3;
    }
    
    return article;
}

- (void)updateWithJSON:(NSDictionary*)json {
    
    self.title = [json objectForKey:@"title"];
    self.content = [json objectForKey:@"content"];
    
    NSDictionary *authorDict = [json objectForKey:@"user"];
    int profileID = [[authorDict objectForKey:@"id"] intValue];
    CDProfile *profile = [[Installation currentInstallation] profileWithID:profileID];
    if (!profile) {
        profile = [CDProfile initWithJSON:authorDict];
    } else {
        [profile updateWithJSON:authorDict];
    }
    self.profile = profile;
    
    [self removeLocations:self.locations];
    
//    NSArray *locationsArray = [json objectForKey:@"locations"];
//    for (NSDictionary *locationDict in locationsArray) {
//        
//        int locationID = [[locationDict objectForKey:@"id"] intValue];
//        CDLocation *location = [[Installation currentInstallation] locationWithID:locationID];
//        if (!location) {
//            location = [CDLocation initWithJSON:locationDict];
//        } else {
//            [location updateWithJSON:locationDict];
//        }
//        [self addLocationsObject:location];
//    }
    
    //Filters
    [self removeFilters:self.filters];
    
    for (NSString *category in [json objectForKey:@"categories"]) {
    
        for (CDFilter *filter in [[Installation currentInstallation] sortedFilterByGroup:kFilterGroupCategory]) {
            if ([filter.jsonName isEqualToString:category]) {
                [self addFiltersObject:filter];
            }
        }
    }
    
    for (NSString *mood in [json objectForKey:@"moods"]) {
        
        for (CDFilter *filter in [[Installation currentInstallation] sortedFilterByGroup:kFilterGroupEmotion]) {
            if ([filter.jsonName isEqualToString:mood]) {
                [self addFiltersObject:filter];
            }
        }
    }
}

- (UIImage*)articleImage {
    return [UIImage imageNamed:@"Temp_Barceloneta.jpg"];
}

- (NSString*)locationName {
    CDLocation *location = [self.locations anyObject];
    return location.name;
}

- (FilterGroup)defaultFilterGroupColour {
    return (FilterGroup)self.defaultFilterGroupColourRaw;
}
- (void)setDefaultFilterGroupColour:(FilterGroup)defaultFilterGroupColour {
    self.defaultFilterGroupColourRaw = defaultFilterGroupColour;
}
@end
