//
//  CDLocation.h
//  BetaHack
//
//  Created by Duncan Campbell on 17/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDArticle, Installation;

@interface CDLocation : NSManagedObject

@property (nonatomic, retain) NSString * addressLine1;
@property (nonatomic, retain) NSString * addressLine2;
@property (nonatomic, retain) NSString * formattedTelephoneNumber;
@property (nonatomic, retain) NSString * foursquareJSON;
@property (nonatomic, retain) NSString * foursquareURL;
@property (nonatomic) int32_t identifier;
@property (nonatomic) double latitude;
@property (nonatomic, retain) NSData * locationImageData;
@property (nonatomic, retain) NSString * locationURL;
@property (nonatomic) double longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * telephoneNumber;
@property (nonatomic, retain) NSSet *articles;
@property (nonatomic, retain) Installation *installation;
@end

@interface CDLocation (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(CDArticle *)value;
- (void)removeArticlesObject:(CDArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
