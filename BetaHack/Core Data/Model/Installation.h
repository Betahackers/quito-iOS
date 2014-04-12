//
//  Installation.h
//  BetaHack
//
//  Created by Duncan Campbell on 12/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDArticle, CDProfile;

@interface Installation : NSManagedObject

@property (nonatomic, retain) NSSet *articles;
@property (nonatomic, retain) NSSet *profiles;
@end

@interface Installation (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(CDArticle *)value;
- (void)removeArticlesObject:(CDArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

- (void)addProfilesObject:(CDProfile *)value;
- (void)removeProfilesObject:(CDProfile *)value;
- (void)addProfiles:(NSSet *)values;
- (void)removeProfiles:(NSSet *)values;

@end
