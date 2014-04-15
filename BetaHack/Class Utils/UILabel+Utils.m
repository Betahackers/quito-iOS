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

- (void) applyFontMontserratWithWeight:(FontWeight)weight {
    self.font = [UIFont montserratWithWeight:weight size:self.font.pointSize];
}

- (UILabel*)replaceWithMultilineLabel {
    
    //hide the suggestion label and add another label ontop with a variable size
    self.hidden = YES;
    
    UILabel *overlayLabel = [[UILabel alloc] initWithFrame:self.frame];
    [overlayLabel setFont:self.font];
    [overlayLabel setText:self.text];
    [overlayLabel setTextAlignment:self.textAlignment];
    [overlayLabel setNumberOfLines:0];
    [overlayLabel setTextColor:self.textColor];
    [overlayLabel sizeToFit];
    [self.superview addSubview:overlayLabel];
    
    return overlayLabel;
}
@end
