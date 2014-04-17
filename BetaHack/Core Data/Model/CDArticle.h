//
//  CDArticle.h
//  BetaHack
//
//  Created by Duncan Campbell on 17/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDFilter, CDLocation, CDProfile, Installation;

@interface CDArticle : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic) int16_t defaultFilterGroupColourRaw;
@property (nonatomic) int32_t identifier;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) NSTimeInterval createdDateInterval;
@property (nonatomic, retain) NSSet *filters;
@property (nonatomic, retain) Installation *installation;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) CDProfile *profile;
@end

@interface CDArticle (CoreDataGeneratedAccessors)

- (void)addFiltersObject:(CDFilter *)value;
- (void)removeFiltersObject:(CDFilter *)value;
- (void)addFilters:(NSSet *)values;
- (void)removeFilters:(NSSet *)values;

- (void)addLocationsObject:(CDLocation *)value;
- (void)removeLocationsObject:(CDLocation *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

@end
