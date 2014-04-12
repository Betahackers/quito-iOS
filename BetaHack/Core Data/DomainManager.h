//
//  DomainManager.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "DomainEnums.h"

#import "Installation+Utils.h"
#import "CDArticle+Utils.h"
#import "CDProfile+Utils.h"
#import "CDFilter+Utils.h"

#import "NSDate+Utils.h"
#import "NSSorting.h"
#import "NSString+Utils.h"
#import "UIColor+Utils.h"
#import "UIView+Utils.h"
#import "UIFont+Utils.h"
#import "UILabel+Utils.h"

@interface DomainManager : NSObject

+ (DomainManager *)sharedManager;

@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectContext*)context;

- (BOOL)saveContext:(NSError**)error;
- (void)rollbackContext;

- (void)flushDatabase;

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error;

- (NSURL *)applicationDocumentsDirectory;

@end
