//
//  CDArticle.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "CDArticle.h"
#import "DomainEnums.h"


@interface CDArticle (Utils)

+ (id)initWithJSON:(NSDictionary*)json;
- (void)updateWithJSON:(NSDictionary*)json;

- (UIImage*)articleImage;

@end



