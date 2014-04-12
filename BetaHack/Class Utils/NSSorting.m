//
//  NSSorting.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "NSSorting.h"
#import "DomainManager.h"

@implementation NSArray (Utils)

- (NSArray*)sortArrayByTextField:(NSString*)fieldName {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [self sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSArray*)sortArrayByNumericField:(NSString*)fieldName {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:YES selector:@selector(compare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [self sortedArrayUsingDescriptors:sortDescriptors];
}
@end



@implementation NSMutableArray (Utils)

- (void)appendEmptyTableSection:(int)tableSectionIndex title:(NSString*)title {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:title, @"title", [NSArray array], @"objects", nil];
    [self addObject:mutableDict];
}

- (void)appendTableSection:(int)tableSectionIndex title:(NSString*)title withObject:(id)object {
    
    NSArray *objectArray = [NSArray array];
    if (object) {
        objectArray = [NSArray arrayWithObject:object];
    }
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:title, @"title", objectArray, @"objects", nil];
    [self addObject:mutableDict];
}

- (void)appendTableSection:(int)tableSectionIndex title:(NSString*)title withObjects:(NSArray*)objects {
    
    NSArray *objectArray = [NSArray array];
    if (objects) {
        objectArray = objects;
    }
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:title, @"title", objectArray, @"objects", nil];
    [self addObject:mutableDict];
}

- (id)objectForIndexPath:(NSIndexPath*)indexPath {
    return [[[self objectAtIndex:indexPath.section] objectForKey:@"objects"] objectAtIndex:indexPath.row];
}
@end



@implementation NSSet (Utils)

- (NSArray*)sortSetByTextField:(NSString*)fieldName {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [self sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSArray*)sortSetByNumericField:(NSString*)fieldName {
    return [self sortSetByNumericField:fieldName ascending:YES];
}

- (NSArray*)sortSetByNumericField:(NSString*)fieldName ascending:(BOOL)ascending {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:ascending selector:@selector(compare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [self sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSArray*)sortSetByDateField:(NSString*)fieldName {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:fieldName ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [self sortedArrayUsingDescriptors:sortDescriptors];
}

@end