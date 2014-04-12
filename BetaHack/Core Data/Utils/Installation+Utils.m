//
//  Installation.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "Installation+Utils.h"

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
            
            [currentInstallation addTestData];
            
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

#pragma mark - Test Data
- (void)addTestData {
    
    CDProfile *profile = [CDProfile initWithJSON:nil name:@"Duncan Campbell"];
    CDArticle *article = [CDArticle initWithJSON:nil title:@"Montjuic" author:profile];
    
    profile = [CDProfile initWithJSON:nil name:@"Yonah Forst"];
    article = [CDArticle initWithJSON:nil title:@"Vespa Burger" author:profile];
    
    profile = [CDProfile initWithJSON:nil name:@"Kristian Dupont Knudsen"];
    article = [CDArticle initWithJSON:nil title:@"Ciutadella" author:profile];
}

#pragma mark - articles
- (NSArray*)sortedArticles {
    return [self.articles sortSetByTextField:@"title"];
}
@end
