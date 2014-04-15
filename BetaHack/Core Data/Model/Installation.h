//
//  Installation.h
//  BetaHack
//
//  Created by Duncan Campbell on 15/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDArticle, CDFilter, CDLocation, CDProfile;

@interface Installation : NSManagedObject

@property (nonatomic, retain) NSSet *articles;
@property (nonatomic, retain) NSSet *filters;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSSet *profiles;
@end

@interface Installation (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(CDArticle *)value;
- (void)removeArticlesObject:(CDArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

- (void)addFiltersObject:(CDFilter *)value;
- (void)removeFiltersObject:(CDFilter *)value;
- (void)addFilters:(NSSet *)values;
- (void)removeFilters:(NSSet *)values;

- (void)addLocationsObject:(CDLocation *)value;
- (void)removeLocationsObject:(CDLocation *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

- (void)addProfilesObject:(CDProfile *)value;
- (void)removeProfilesObject:(CDProfile *)value;
- (void)addProfiles:(NSSet *)values;
- (void)removeProfiles:(NSSet *)values;

@end
