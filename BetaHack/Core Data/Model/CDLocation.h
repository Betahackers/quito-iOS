//
//  CDLocation.h
//  BetaHack
//
//  Created by Duncan Campbell on 13/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDArticle, Installation;

@interface CDLocation : NSManagedObject

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) double identifier;
@property (nonatomic, retain) Installation *installation;
@property (nonatomic, retain) NSSet *articles;
@end

@interface CDLocation (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(CDArticle *)value;
- (void)removeArticlesObject:(CDArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
