//
//  CDArticle.h
//  BetaHack
//
//  Created by Duncan Campbell on 12/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDProfile, Installation;

@interface CDArticle : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Installation *installation;
@property (nonatomic, retain) CDProfile *profile;

@end
