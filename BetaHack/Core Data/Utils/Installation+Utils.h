//
//  Installation.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "Installation.h"
#import "DomainManager.h"

@interface Installation (Utils)

+ (Installation*)currentInstallation;

- (NSArray*)sortedArticles;
- (NSArray*)sortedProfiles;

- (CDProfile*)profileWithID:(int)profileID;
- (CDLocation*)locationWithID:(int)locationID;
- (CDArticle*)articleWithID:(int)articleID;

- (NSArray*)sortedFilterByGroup:(FilterGroup)filterGroup;
- (CDFilter*)filterOfType:(FilterType)filterType;

- (void)fetchArticles:(void (^)(NSError *error))completion;
- (void)fetchArticlesWithRadius:(float)radius completion:(void (^)(NSError *error))completion;

@end



