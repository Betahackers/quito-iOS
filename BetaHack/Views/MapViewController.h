//
//  MapViewController.h
//  BetaHack
//
//  Created by Duncan Campbell on 12/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#pragma mark - MapViewDelegate
@protocol MapViewDelegate
- (void)shrinkTable;
- (void)growTable;
@end

@interface MapViewController : UIViewController <MapViewDelegate>

@end


@interface MapPinAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;

@end