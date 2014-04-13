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

+ (id)initWithJSON:(NSDictionary*)json type:(FilterType)type group:(FilterGroup)group name:(NSString*)name;

- (FilterType)filterType;
- (void)setFilterType:(FilterType)filterType;

- (FilterGroup)filterGroup;
- (void)setFilterGroup:(FilterGroup)filterGroup;

- (UIImage*)filterImage;

@end



