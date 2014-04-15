//
//  MapViewController.h
//  BetaHack
//
//  Created by Duncan Campbell on 12/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CDArticle, CDFilter, CDProfile;

#pragma mark - MapViewDelegate
@protocol MapViewDelegate
- (void)applyFilter:(CDFilter*)filter;
- (void)applyProfile:(CDProfile*)profile;
- (void)showHideHeader;
- (void)playPromo;
@end

@interface MapViewController : UIViewController <MapViewDelegate, MKMapViewDelegate>

@end


@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *image;
@property (nonatomic, copy, readonly) CDArticle *article;

-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates image:(NSString *)paramImage article:(CDArticle*)article;

@end