//
//  UIColor.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

// Color Names can be found here:  http://www.color-blindness.com/color-name-hue/

+ (UIColor *)fromtoMoodColour {
    return [UIColor colorWithRed:42/255.0 green:197/255.0 blue:193/255.0 alpha:1.0];
}

+ (UIColor *)fromtoMoodColourLight {
    return [UIColor colorWithRed:177/255.0 green:231/255.0 blue:230/255.0 alpha:1.0];
}

+ (UIColor *)fromtoProfileColour {
    return [UIColor colorWithRed:139/255.0 green:204/255.0 blue:86/255.0 alpha:1.0];
}

+ (UIColor *)fromtoProfileColourLight {
    return [UIColor colorWithRed:209/255.0 green:235/255.0 blue:182/255.0 alpha:1.0];
}

+ (UIColor *)fromtoActivityColour {
    return [UIColor colorWithRed:156/255.0 green:146/255.0 blue:205/255.0 alpha:1.0];
}

+ (UIColor *)fromtoActivityColourLight {
    return [UIColor colorWithRed:216/255.0 green:211/255.0 blue:235/255.0 alpha:1.0];
}
@end
