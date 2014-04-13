//
//  UIFont.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DomainEnums.h"
#import "DomainManager.h"

@interface UIFont (Utils)

+ (UIFont*)montserratWithWeight:(FontWeight)weight size:(float)size;

@end

@interface UIView (FontUtils)

- (void)applyMontserratFontToSubviews;

@end