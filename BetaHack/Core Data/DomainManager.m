//
//  DomainManager.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "DomainManager.h"

@interface DomainManager ()

@end


@implementation DomainManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (DomainManager *)sharedManager {
  static DomainManager *_sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
      _sharedManager = [[DomainManager alloc] init];
    
      //initialise the managedObjectContext
      [_sharedManager managedObjectContext];
  });
  
  return _sharedManager;
}

#pragma mark - Conext
- (NSManagedObjectContext*)context {
    return _managedObjectContext;
}

- (BOOL)saveContext:(NSError**)error {
    
    NSManagedObjectContext *context = _managedObjectContext;
    
    NSError *thisError;
    if (context && [context hasChanges] && ![context save:&thisError]) {
        
        NSLog(@"Failed to save to data store: %@", thisError.localizedDescription);
        NSArray* detailedErrors = [[thisError userInfo] objectForKey:NSDetailedErrorsKey];
        if(detailedErrors != nil && [detailedErrors count] > 0) {
            for(NSError* detailedError in detailedErrors) {
                NSLog(@"  DetailedError: %@", [detailedError userInfo]);
            }
        }
        else {
            NSLog(@"  %@", [thisError userInfo]);
        }
        
        [context rollback];
        
        if(error) {
            *error = thisError;
        }
        return NO;
    }
    return YES;
}

- (void)rollbackContext {
    [_managedObjectContext rollback];
}

#pragma mark - Fetch
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error {
    return [self.managedObjectContext executeFetchRequest:request error:error];
}

#pragma mark - Flush
- (void)flushDatabase {
    
    [_managedObjectContext lock];
    
    NSArray *stores = [_persistentStoreCoordinator persistentStores];
    for(NSPersistentStore *store in stores) {
        
        NSError *error;
        [_persistentStoreCoordinator removePersistentStore:store error:&error];
        if (error) NSLog(@"%@", error.localizedDescription);
        
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:&error];
        if (error) NSLog(@"%@", error.localizedDescription);
    }
    
    [_managedObjectContext unlock];
    
    _managedObjectModel = nil;
    _managedObjectContext = nil;
    _persistentStoreCoordinator = nil;
    
    [self managedObjectContext];
}

#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        
//        //Undo Support
//        NSUndoManager *undoManager = [[NSUndoManager  alloc] init];
//        [_managedObjectContext setUndoManager:undoManager];
        
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSUndoManager *)undoManager {
    return[_managedObjectContext undoManager];
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GreaseBook.sqlite"];
  //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    
  NSError *error = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     
     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.
     
    
     If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
     

     
     * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
     @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
     
     Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
     
     if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
     
     
     If you encounter schema incompatibility errors during development, you can reduce their frequency by:
     * Simply deleting the existing store:
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
     
     
     */
      
      //try a lightweight migration
      NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
      if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
       
          NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithBool:YES],   NSMigratePersistentStoresAutomaticallyOption,
                                   [NSNumber numberWithBool:YES],  NSInferMappingModelAutomaticallyOption, nil];
          if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
          {
              
              //abort();
              [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
              
              _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
              if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
                  NSLog(@"Core Data Error: %@", error.localizedDescription);
              }
          }
      }
  }
  
  return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
