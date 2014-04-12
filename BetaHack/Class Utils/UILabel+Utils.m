//
//  UIUILabel.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "UILabel+Utils.h"
#import "DomainManager.h"

@implementation UILabel (Utils)

- (void) applyFontMuseoSansWithWeight:(FontWeight)weight {
    self.font = [UIFont museoSansWithWeight:weight size:self.font.pointSize];
}
@end
