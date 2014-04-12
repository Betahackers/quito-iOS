//
//  UIView.h
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DomainEnums.h"

@interface UIView (Utils)

- (void) setFrameWidth:(CGFloat)newWidth;
- (void) setFrameHeight:(CGFloat)newHeight;
- (void) setFrameOriginX:(CGFloat)newX;
- (void) setFrameOriginY:(CGFloat)newY;

- (void)removeAllSubviews;

- (UIImage *)screenshot:(UIInterfaceOrientation)orientation isOpaque:(BOOL)isOpaque usePresentationLayer:(BOOL)usePresentationLayer;

- (void)animateFrameToXCoord:(float)xCoord yCoord:(float)yCoord withDuration:(float)animationDuration withDelay:(float)animationDelay;
- (void)increaseSizeByFactor:(float)factor duration:(float)duration;
- (void)decreaseSizeByFactor:(float)factor duration:(float)duration;
- (void)setVisible:(BOOL)visible;

- (void)setAlpha:(CGFloat)alpha afterDelay:(float)delay;
- (void)setHidden:(BOOL)hidden forViewWithTag:(int)tag;

- (void)centerWithinSuperview;

- (void)hideKeyboard;
@end