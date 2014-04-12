//
//  CDFilter.h
//  BetaHack
//
//  Created by Duncan Campbell on 12/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDArticle, Installation;

@interface CDFilter : NSManagedObject

@property (nonatomic) int16_t filterTypeRaw;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t filterGroupRaw;
@property (nonatomic, retain) Installation *installation;
@property (nonatomic, retain) NSSet *articles;
@end

@interface CDFilter (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(CDArticle *)value;
- (void)removeArticlesObject:(CDArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
