//
//  CDLocation.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "CDLocation.h"
#import "DomainEnums.h"


@interface CDLocation (Utils)

+ (id)initWithJSON:(NSDictionary*)json;
- (void)updateWithJSON:(NSDictionary*)json;

@end


