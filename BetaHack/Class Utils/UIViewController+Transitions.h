//
//  NSArray.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(Transitions)

- (void) presentViewController:(UIViewController *)viewController withPushDirection: (NSString *) direction;
- (void) dismissViewControllerWithPushDirection:(NSString *) direction;

@end