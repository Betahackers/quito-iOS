//
//  CDLocation.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "CDLocation+Utils.h"
#import "DomainManager.h"

@implementation CDLocation (Utils)

+ (id)initWithJSON:(NSDictionary*)json {
    
    CDLocation *location = (CDLocation *)[NSEntityDescription insertNewObjectForEntityForName:@"CDLocation" inManagedObjectContext:[[DomainManager sharedManager] context]];
    if (location) {
        
        location.installation = [Installation currentInstallation];
        
        location.identifier = [[json objectForKey:@"id"] intValue];
        [location updateWithJSON:json];
        
        [location removeArticles:location.articles];
        
        for (NSDictionary *articleDict in [json objectForKey:@"articles"]) {
            
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
    
    
}
@end
