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

+ (id)initWithJSON:(NSDictionary*)json type:(FilterType)type group:(FilterGroup)group name:(NSString*)name jsonName:(NSString*)jsonName imageName:(NSString*)imageName {
    
    CDFilter *filter = (CDFilter *)[NSEntityDescription insertNewObjectForEntityForName:@"CDFilter" inManagedObjectContext:[[DomainManager sharedManager] context]];
    if (filter) {
        filter.name = name;
        filter.jsonName = jsonName;
        filter.filterType = type;
        filter.filterGroup = group;
        filter.imageName = imageName;
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

- (UIImage*)filterImageWithCircle:(BOOL)isWithCircle {
    
    NSMutableString *imageName = [NSMutableString stringWithString:self.imageName];
    if (isWithCircle) {
        [imageName appendString:@"_circle"];
    }
    [imageName appendString:@".png"];
    
    return [UIImage imageNamed:imageName];
}
@end
