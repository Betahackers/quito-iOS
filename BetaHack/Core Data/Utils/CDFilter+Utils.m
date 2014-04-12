//
//  CDFilter.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "CDFilter+Utils.h"
#import "DomainManager.h"

@implementation CDFilter (Utils)

+ (id)initWithJSON:(NSDictionary*)json type:(FilterType)type group:(FilterGroup)group name:(NSString*)name {
    
    CDFilter *filter = (CDFilter *)[NSEntityDescription insertNewObjectForEntityForName:@"CDFilter" inManagedObjectContext:[[DomainManager sharedManager] context]];
    if (filter) {
        filter.name = name;
        filter.filterType = type;
        filter.filterGroup = group;
        filter.installation = [Installation currentInstallation];
    }
    
    return filter;
}

#pragma mark - Filter Type
- (FilterType)filterType {
    return (FilterType)self.filterTypeRaw;
}

- (void)setFilterType:(FilterType)filterType {
    self.filterTypeRaw = filterType;
}

- (FilterGroup)filterGroup {
    return (FilterGroup)self.filterGroupRaw;
}

- (void)setFilterGroup:(FilterGroup)filterGroup {
    self.filterGroupRaw = filterGroup;
}
@end
