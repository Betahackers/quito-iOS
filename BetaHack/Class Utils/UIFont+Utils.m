//
//  UIFont.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "UIFont+Utils.h"

@implementation UIFont (Utils)

+ (UIFont*)museoSansWithWeight:(FontWeight)weight size:(float)size {
    
    NSString *fontName;
    switch (weight) {
        case kFontWeightRegular:
            fontName = @"MuseoSans-300"; break;
        case kFontWeightBold:
            fontName = @"MuseoSans-500"; break;
        case kFontWeightLight:
            fontName = @"MuseoSans-100"; break;
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (!font) {
        
        for (NSString *familyName in [UIFont familyNames]) {
            for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
                NSLog(@"%@", fontName);
            }
        }

        NSLog(@"Font not found - probably due to naming anomaly.  Add the font files to the project, then add the font file names to the info plist (under the UIAppFonts key), then refer to the fonts by their PostScript name.");
    }
    
    return font;
}
@end


@implementation UIView (FontUtils)

#pragma mark - Fonts
- (void)applyMuseoFontToSubviews {
    
    for (UILabel *label in self.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            [label applyFontMuseoSansWithWeight:kFontWeightRegular];
        }
    }
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button.titleLabel applyFontMuseoSansWithWeight:kFontWeightRegular];
        }
    }
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIView class]]) {
            [subview applyMuseoFontToSubviews];
        }
    }
}

@end