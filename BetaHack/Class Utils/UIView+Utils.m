//
//  UIView.m
//  Elvie
//
//  Created by Duncan Campbell on 18/12/13.
//  Copyright (c) 2013 Chiaro. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void) setFrameWidth:(CGFloat)newWidth {
    CGRect f = self.frame;
    f.size.width = newWidth;
    self.frame = f;
}

- (void) setFrameHeight:(CGFloat)newHeight {
    CGRect f = self.frame;
    f.size.height = newHeight;
    self.frame = f;
}

- (void) setFrameOriginX:(CGFloat)newX {
    CGRect f = self.frame;
    f.origin.x = newX;
    self.frame = f;
}

- (void) setFrameOriginY:(CGFloat)newY {
    CGRect f = self.frame;
    f.origin.y = newY;
    self.frame = f;
}

- (void)removeAllSubviews {
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (UIImage *)screenshot:(UIInterfaceOrientation)orientation isOpaque:(BOOL)isOpaque usePresentationLayer:(BOOL)usePresentationLayer {
    CGSize size;
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    } else {
        size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0);
    
    if (usePresentationLayer) {
        [self.layer.presentationLayer renderInContext:UIGraphicsGetCurrentContext()];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)animateFrameToXCoord:(float)xCoord yCoord:(float)yCoord withDuration:(float)animationDuration withDelay:(float)animationDelay {
    
    [UIView animateWithDuration:animationDuration
                          delay:animationDelay
                        options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        
                        self.hidden = NO;
                        
                        CGRect viewFrame = self.frame;
                        
                        viewFrame.origin.x = xCoord;
                        viewFrame.origin.y = yCoord;
                        
                        self.frame = viewFrame;
                        
                    } completion:^(BOOL finished){
                        
                        
                    }];
}

- (BOOL)isDeviceIPhone {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

#pragma mark - animations
- (void)setAlpha:(CGFloat)alpha afterDelay:(float)delay {
    
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setAlpha:alpha];
                     }
                     completion:nil];
}

- (void)increaseSizeByFactor:(float)factor duration:(float)duration {
    [UIView animateWithDuration:duration animations:^{
        CGRect theFrame = self.frame;
        theFrame.size.height *= factor;
        theFrame.size.width *= factor;
        self.frame = theFrame;
    }];
}

- (void)decreaseSizeByFactor:(float)factor duration:(float)duration {
    [UIView animateWithDuration:duration animations:^{
        CGRect theFrame = self.frame;
        theFrame.size.height /= factor;
        theFrame.size.width /= factor;
        self.frame = theFrame;
    }];
}

- (void)setVisible:(BOOL)visible {
    if (visible) {
        self.alpha = 1.0f;
    } else {
        self.alpha = 0.0f;
    }
}

#pragma mark - viewByTag
- (void)setHidden:(BOOL)hidden forViewWithTag:(int)tag {
    UIView *view = [self viewWithTag:tag];
    if (view) {
        [view setHidden:hidden];
    }
}

#pragma mark - positioning
- (void)centerWithinSuperview {
    self.center = [self.superview convertPoint:self.superview.center fromView:self.superview.superview];
}

#pragma mark - Hide keyboard
- (void)hideKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
@end
