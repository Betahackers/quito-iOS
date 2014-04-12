//
//  NSArray.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)

- (NSArray*)sortArrayByTextField:(NSString*)fieldName;
- (NSArray*)sortArrayByNumericField:(NSString*)fieldName;

@end



@interface NSMutableArray (Utils)

- (void)appendEmptyTableSection:(int)tableSectionIndex title:(NSString*)title;
- (void)appendTableSection:(int)tableSectionIndex title:(NSString*)title withObject:(id)object;
- (void)appendTableSection:(int)tableSectionIndex title:(NSString*)title withObjects:(NSArray*)objects;

- (id)objectForIndexPath:(NSIndexPath*)indexPath;

@end



@interface NSSet (Utils)

- (NSArray*)sortSetByTextField:(NSString*)fieldName;

- (NSArray*)sortSetByNumericField:(NSString*)fieldName;
- (NSArray*)sortSetByNumericField:(NSString*)fieldName ascending:(BOOL)ascending;
- (NSArray*)sortSetByDateField:(NSString*)fieldName;

@end