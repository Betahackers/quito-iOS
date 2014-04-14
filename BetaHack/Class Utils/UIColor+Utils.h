//
//  UIColor.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Utils)

// Color Names can be found here:  http://www.color-blindness.com/color-name-hue/

+ (UIColor *)fromtoMoodColour;
+ (UIColor *)fromtoMoodColourLight;
+ (UIColor *)fromtoProfileColour;
+ (UIColor *)fromtoProfileColourLight;
+ (UIColor *)fromtoActivityColour;
+ (UIColor *)fromtoActivityColourLight;

@end