//
//  CDProfile.h
//  BetaHack
//
//  Created by Duncan Campbell on 13/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDArticle, Installation;

@interface CDProfile : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic) int32_t identifier;
@property (nonatomic, retain) NSSet *articles;
@property (nonatomic, retain) Installation *installation;
@end

@interface CDProfile (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(CDArticle *)value;
- (void)removeArticlesObject:(CDArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
