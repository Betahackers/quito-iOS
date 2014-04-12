//
//  Installation.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "Installation.h"
#import "DomainManager.h"

@interface Installation (Utils)

+ (Installation*)currentInstallation;

- (NSArray*)sortedArticles;
- (NSArray*)sortedProfiles;

- (NSArray*)sortedFilterByGroup:(FilterGroup)filterGroup;
- (CDFilter*)filterOfType:(FilterType)filterType;

@end



