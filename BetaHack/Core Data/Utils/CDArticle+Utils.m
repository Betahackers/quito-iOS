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

+ (id)initWithJSON:(NSDictionary*)json title:(NSString*)title author:(CDProfile*)author {
    
    CDArticle *article = (CDArticle *)[NSEntityDescription insertNewObjectForEntityForName:@"CDArticle" inManagedObjectContext:[[DomainManager sharedManager] context]];
    if (article) {
        article.title = title;
        article.installation = [Installation currentInstallation];
        article.profile = author;
        
        //choose 4 random categories
        int rand = arc4random() % 15;
        CDFilter *filter = [[Installation currentInstallation] filterOfType:rand];
        [article addFiltersObject:filter];
        
        rand = arc4random() % 15;
        filter = [[Installation currentInstallation] filterOfType:rand];
        [article addFiltersObject:filter];
        
        rand = arc4random() % 15;
        filter = [[Installation currentInstallation] filterOfType:rand];
        [article addFiltersObject:filter];
        
        rand = arc4random() % 15;
        filter = [[Installation currentInstallation] filterOfType:rand];
        [article addFiltersObject:filter];
    }
    
    return article;
}
@end
