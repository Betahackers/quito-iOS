//
//  CDProfile.h
//  BetaHack
//
//  Created by Duncan Campbell on 17/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDArticle, Installation;

@interface CDProfile : NSManagedObject

@property (nonatomic, retain) NSString * biography;
@property (nonatomic, retain) NSString * expertIn;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * hometown;
@property (nonatomic) int32_t identifier;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * url;
@property (nonatomic) NSTimeInterval updatedDateInterval;
@property (nonatomic, retain) NSSet *articles;
@property (nonatomic, retain) Installation *installation;
@end

@interface CDProfile (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(CDArticle *)value;
- (void)removeArticlesObject:(CDArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
