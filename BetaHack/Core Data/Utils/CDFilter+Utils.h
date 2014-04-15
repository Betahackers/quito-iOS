//
//  CDFilter.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "CDFilter.h"
#import "DomainEnums.h"


@interface CDFilter (Utils)

+ (id)initWithJSON:(NSDictionary*)json type:(FilterType)type group:(FilterGroup)group name:(NSString*)name jsonName:(NSString*)jsonName imageName:(NSString*)imageName;

- (FilterType)filterType;
- (void)setFilterType:(FilterType)filterType;

- (FilterGroup)filterGroup;
- (void)setFilterGroup:(FilterGroup)filterGroup;

- (UIImage*)filterImageWithCircle:(BOOL)isWithCircle;

@end



