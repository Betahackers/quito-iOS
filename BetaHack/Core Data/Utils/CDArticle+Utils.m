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
    
    NSString *dateString = [json objectForKey:@"created_at"];;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.createdDate = [dateFormatter dateFromString:dateString];
    
    NSDictionary *authorDict = [json objectForKey:@"user"];
    int profileID = [[authorDict objectForKey:@"id"] intValue];
    CDProfile *profile = [[Installation currentInstallation] profileWithID:profileID];
    if (!profile) {
        profile = [CDProfile initWithJSON:authorDict];
    } else {
        [profile updateWithJSON:authorDict];
    }
    self.profile = profile;
    
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

- (CDLocation*)location {
    CDLocation *location = [self.locations anyObject];
    return location;
}

- (FilterGroup)defaultFilterGroupColour {
    return (FilterGroup)self.defaultFilterGroupColourRaw;
}
- (void)setDefaultFilterGroupColour:(FilterGroup)defaultFilterGroupColour {
    self.defaultFilterGroupColourRaw = defaultFilterGroupColour;
}


- (NSDate*)createdDate {
    return [NSDate dateWithTimeIntervalSinceReferenceDate:self.createdDateInterval];
}

- (void)setCreatedDate:(NSDate*)createdDate {
    self.createdDateInterval = [createdDate timeIntervalSinceReferenceDate];
}
@end
