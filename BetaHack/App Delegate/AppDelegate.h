//
//  AppDelegate.h
//  BetaHack
//
//  Created by Duncan Campbell on 12/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) id<GAITracker> tracker;

@end
