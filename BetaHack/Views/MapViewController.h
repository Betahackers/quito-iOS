//
//  MapViewController.h
//  BetaHack
//
//  Created by Duncan Campbell on 12/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - MapViewDelegate
@protocol MapViewDelegate
- (void)shrinkTable;
- (void)growTable;
@end

@interface MapViewController : UIViewController <MapViewDelegate>

@end
