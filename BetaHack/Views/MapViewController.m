//
//  MapViewController.m
//  BetaHack
//
//  Created by Duncan Campbell on 12/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import "MapViewController.h"
#import "DomainManager.h"
#import "ArticleViewController.h"
#import "FilterViewController.h"
#import "ILTranslucentView.h"
#import "HeaderViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Mixpanel.h"

@interface MapViewController () {
    BOOL hasBeenShown;
}

@property (nonatomic, strong) IBOutlet UIView *headerContainerView;
@property (nonatomic, strong) HeaderViewController *headerViewController;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) IBOutlet UIView *activitiesFilterView;
@property (nonatomic, strong) IBOutlet UIView *moodsFilterView;
@property (nonatomic, strong) IBOutlet UIView *profilesFilterView;

@property (nonatomic, strong) IBOutlet UIButton *activitiesFilterButton;
@property (nonatomic, strong) IBOutlet UIButton *moodsFilterButton;
@property (nonatomic, strong) IBOutlet UIButton *profilesFilterButton;

@property (nonatomic, strong) IBOutlet UIImageView *activitiesFilterImageView;
@property (nonatomic, strong) IBOutlet UIImageView *moodsFilterImageView;
@property (nonatomic, strong) IBOutlet UIImageView *profilesFilterImageView;

@property (nonatomic, strong) IBOutlet UIView *translucentHolderView;

@property (nonatomic, strong) CDProfile *selectedProfile;
@property (nonatomic, strong) CDFilter *selectedFilter;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view applyMontserratFontToSubviews];
    [self.headerContainerView setFrameHeight:35];

    self.profilesFilterImageView.layer.masksToBounds = NO;
    self.profilesFilterImageView.clipsToBounds = YES;
    self.profilesFilterImageView.layer.cornerRadius = (self.profilesFilterImageView.frame.size.height / 2);
    
    [self.moodsFilterView setAlpha:0.0f];
    [self.activitiesFilterView setAlpha:0.0f];
    [self.profilesFilterView setAlpha:0.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    
    //41.407001,2.156799
    if (!hasBeenShown) {
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(41.407001, 2.156799);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = {coord, span};
        [self.mapView setRegion:region];
        
        //add the toolbar
        self.translucentHolderView = [[UIView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.translucentHolderView];
        
        UIColor *randomBackgroundColor;
        int rand = arc4random() % 3;
        switch (rand) {
            case 0: randomBackgroundColor = [UIColor fromtoActivityColour]; break;
            case 1: randomBackgroundColor = [UIColor fromtoMoodColour]; break;
            default: randomBackgroundColor = [UIColor fromtoProfileColour]; break;
        }
        [self.translucentHolderView setBackgroundColor:randomBackgroundColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        rand = arc4random() % 24;
        NSString *imageName = [NSString stringWithFormat:@"fromto_hola_App_%02d.png", rand];
        [imageView setImage:[UIImage imageNamed:imageName]];
        [self.translucentHolderView addSubview:imageView];
        
        _moviePlayer =  [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"promo" ofType:@"mp4"]]];
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        
        [_moviePlayer.view setFrame:CGRectMake(0, 0, 320, 480)];
        _moviePlayer.view.transform = CGAffineTransformConcat(_moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI/2)); // to rotate the movie palyer controller
        [_moviePlayer.view setFrame: self.view.bounds];
        [self.view addSubview:_moviePlayer.view];
        [_moviePlayer.view setHidden:YES];
        
        hasBeenShown = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [UIView animateWithDuration:2.0 animations:^{
        [self.moodsFilterView setAlpha:1.0f];
        [self.activitiesFilterView setAlpha:1.0f];
        [self.profilesFilterView setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
    
        [UIView animateWithDuration:0.8 animations:^{
            [self.translucentHolderView setFrameOriginY:self.translucentHolderView.frame.size.height];
        } completion:^(BOOL finished) {
            [self.translucentHolderView removeFromSuperview];
            [self.mapView setShowsUserLocation:YES];
        }];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"map_article"]) {
        CDArticle *article = (CDArticle*)sender;
        ArticleViewController *viewController = (ArticleViewController *)segue.destinationViewController;
        viewController.article = article;
        if (self.selectedFilter != nil) {
            viewController.selectedFilterGroup = self.selectedFilter.filterGroup;
        } else if (self.selectedProfile != nil) {
            viewController.selectedFilterGroup = kFilterGroupProfile;
        } else {
            viewController.selectedFilterGroup = article.defaultFilterGroupColour;
        }
    }
    
    if ([segue.identifier isEqualToString:@"map_filter"]) {
        FilterViewController *viewController = (FilterViewController *)segue.destinationViewController;
        switch ([sender longValue]) {
            case 1001: viewController.filterGroup = kFilterGroupEmotion; break;
            case 1002: viewController.filterGroup = kFilterGroupCategory; break;
            case 1003: viewController.filterGroup = kFilterGroupProfile; break;
        }
        viewController.mapViewDelegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"map_header"]) {
        self.headerViewController = (HeaderViewController *)segue.destinationViewController;
        self.headerViewController.mapViewDelegate = self;
    }
}

- (IBAction)locationTapped:(UIButton*)sender {
    
    NSArray *articles = [[Installation currentInstallation] sortedArticles];
    CDArticle *article = [articles objectAtIndex:sender.tag - 1001];
   
    [self performSegueWithIdentifier:@"map_article" sender:article];
}

- (IBAction)filterTapped:(UIButton*)sender {
    
    if (self.selectedProfile != nil && sender == self.profilesFilterButton) {
        self.selectedProfile = nil;
        [self reloadAnnotations];
    } else if (self.selectedFilter != nil) {
        if (self.selectedFilter.filterGroup == kFilterGroupEmotion && sender == self.moodsFilterButton) {
            self.selectedFilter = nil;
            [self reloadAnnotations];
        } else if (self.selectedFilter.filterGroup == kFilterGroupCategory && sender == self.activitiesFilterButton) {
            self.selectedFilter = nil;
            [self reloadAnnotations];
        } else {
            [self performSegueWithIdentifier:@"map_filter" sender:[NSNumber numberWithLong:sender.tag]];
        }
    } else {
        [self performSegueWithIdentifier:@"map_filter" sender:[NSNumber numberWithLong:sender.tag]];
    }
}

- (void)hideHeader {
    
    BOOL isCurrentlyShown = (self.headerContainerView.frame.size.height > 35);
    if (isCurrentlyShown) {
        [self.headerViewController hideHeader];
    }
}

- (BOOL) showHideHeader {
    
    BOOL isCurrentlyShown = (self.headerContainerView.frame.size.height > 35);

    [UIView animateWithDuration:0.3 animations:^{
        if (isCurrentlyShown) {
            [self.headerContainerView setFrameHeight:35];
            [[Mixpanel sharedInstance] track:@"Header closed" properties:nil];
            
        } else {
            [self.headerContainerView setFrameHeight:400];
            [[Mixpanel sharedInstance] track:@"Header opened" properties:nil];
        }
    }];
    
    return !isCurrentlyShown;
}

- (void)playPromo {
    
    [_moviePlayer.view setHidden:NO];
    [_moviePlayer play];
    [[Mixpanel sharedInstance] track:@"Promo viewed" properties:nil];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
        [player.view removeFromSuperview];
    }
    
    [_moviePlayer.view setHidden:YES];
}

- (void)applyFilter:(CDFilter *)filter {
    if (self.selectedFilter == filter) {
        self.selectedFilter = nil;
    } else {
        self.selectedFilter = filter;
    }
    self.selectedProfile = nil;
    [self reloadAnnotations];
    [[Mixpanel sharedInstance] track:@"Filter applied" properties:@{@"Filter": filter.name}];
}

- (void)applyProfile:(CDProfile *)profile {
    if (self.selectedProfile == profile) {
        self.selectedProfile = nil;
    } else {
        self.selectedProfile = profile;
    }
    self.selectedFilter = nil;
    [self reloadAnnotations];
    [[Mixpanel sharedInstance] track:@"Profile applied" properties:@{@"Filter": profile.shortDisplayName}];
}

#pragma mark - MKMapView Delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyAnnotation class]])
    {
        MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else
        {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = NO;
        
        if (self.selectedFilter) {
            if (self.selectedFilter.filterGroup == kFilterGroupEmotion) {
                annotationView.image = [UIImage imageNamed:@"point_mood.png"];
            } else {
                annotationView.image = [UIImage imageNamed:@"point_activity.png"];
            }
        } else if (self.selectedProfile) {
            annotationView.image = [UIImage imageNamed:@"point_profile.png"];
        } else {
            
            MyAnnotation *mapViewAnnotation = (MyAnnotation*)annotationView.annotation;
            switch (mapViewAnnotation.article.defaultFilterGroupColour) {
                case kFilterGroupCategory:
                    annotationView.image = [UIImage imageNamed:@"point_activity.png"];
                    break;
                case kFilterGroupEmotion:
                    annotationView.image = [UIImage imageNamed:@"point_mood.png"];
                    break;
                case kFilterGroupProfile:
                    annotationView.image = [UIImage imageNamed:@"point_profile.png"];
                    break;
                default:
                    break;
            }
        }
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MyAnnotation *mapViewAnnotation = (MyAnnotation*)view.annotation;
    
        //only segue to actual annotations, not the user location
    if ([mapViewAnnotation isKindOfClass:[MyAnnotation class]]) {
        [self performSegueWithIdentifier:@"map_article" sender:mapViewAnnotation.article];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKMapRect mRect = mapView.visibleMapRect;
    MKMapPoint northMapPoint = MKMapPointMake(MKMapRectGetMidX(mRect), MKMapRectGetMinY(mRect));
    MKMapPoint southMapPoint = MKMapPointMake(MKMapRectGetMidX(mRect), MKMapRectGetMaxY(mRect));
    
    float distanceBetweenNorthAndSouth = MKMetersBetweenMapPoints(northMapPoint, southMapPoint);
    float radius = distanceBetweenNorthAndSouth / 2.0f;
    
    NSLog(@"Radius: %f", radius);
    
    //now reload the points for this location
    [[Installation currentInstallation] fetchLocationsWithRadius:radius long:mapView.centerCoordinate.longitude lat:mapView.centerCoordinate.latitude filter:self.selectedFilter profile:self.selectedProfile completion:^(NSError *error) {
        [self reloadAnnotations];
    }];
    
    [self hideHeader];
    [[Mixpanel sharedInstance] track:@"Map region changed" properties:nil];
}

- (void)reloadAnnotations {
        
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSMutableArray *articles = [NSMutableArray array];
    for (CDArticle *article in [Installation currentInstallation].sortedArticles) {
        if (!self.selectedFilter && !self.selectedProfile) {
            [articles addObject:article];
            
        } else if (self.selectedFilter != nil) {
            if ([article.filters containsObject:self.selectedFilter]) {
                [articles addObject:article];
            }
            
        } else if (self.selectedProfile != nil) {
            if (article.profile == self.selectedProfile) {
                [articles addObject:article];
            }
        }
    }
    
    for (CDArticle *article in articles) {
        
        CDLocation *location = article.locations.anyObject;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.latitude,location.longitude);
        
        MyAnnotation *annotation1 = [[MyAnnotation alloc] initWithCoordinates:coordinate image:@"Temp_MapPin.png" article:article];
        [self.mapView addAnnotation:annotation1];
    }
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        MKAnnotationView *annotationView = [self mapView:self.mapView viewForAnnotation:annotation];
        [annotationView setAlpha:0.0f];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        for (id<MKAnnotation> annotation in self.mapView.annotations) {
            MKAnnotationView *annotationView = [self mapView:self.mapView viewForAnnotation:annotation];
            [annotationView setAlpha:1.0f];
        }
    }];
    
    //hide all the buttons    
    if (self.selectedFilter != nil) {
        if (self.selectedFilter.filterGroup == kFilterGroupEmotion) {
            [self.moodsFilterImageView setImage:[self.selectedFilter filterImageWithCircle:NO]];
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.moodsFilterImageView setAlpha:1.0f];
                [self.activitiesFilterImageView setAlpha:0.0f];
                [self.profilesFilterImageView setAlpha:0.0f];
                
                [self.moodsFilterView setFrameOriginX:0];
                [self.activitiesFilterView setFrameOriginX:-34];
                [self.profilesFilterView setFrameOriginX:-34];
            }];
            
        } else {
            [self.activitiesFilterImageView setImage:[self.selectedFilter filterImageWithCircle:NO]];
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.activitiesFilterView setFrameOriginX:0];
                [self.moodsFilterView setFrameOriginX:-34];
                [self.profilesFilterView setFrameOriginX:-34];
                
                [self.moodsFilterImageView setAlpha:0.0f];
                [self.activitiesFilterImageView setAlpha:1.0f];
                [self.profilesFilterImageView setAlpha:0.0f];
            }];
        }
        
    } else if (self.selectedProfile != nil) {
        [self.profilesFilterImageView setImage:self.selectedProfile.profileImage];
        [UIView animateWithDuration:0.3 animations:^{
            [self.profilesFilterView setFrameOriginX:0];
            [self.activitiesFilterView setFrameOriginX:-34];
            [self.moodsFilterView setFrameOriginX:-34];
            
            [self.moodsFilterImageView setAlpha:0.0f];
            [self.activitiesFilterImageView setAlpha:0.0f];
            [self.profilesFilterImageView setAlpha:1.0f];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.profilesFilterView setFrameOriginX:-34];
            [self.activitiesFilterView setFrameOriginX:-34];
            [self.moodsFilterView setFrameOriginX:-34];
            
            [self.moodsFilterImageView setAlpha:0.0f];
            [self.activitiesFilterImageView setAlpha:0.0f];
            [self.profilesFilterImageView setAlpha:0.0f];
        }];
    }
}

- (void)viewDidLayoutSubviews {
    
    NSLog(@"View did layout subviews");
    
    [self.moodsFilterView setFrameOriginX:-34];
    [self.activitiesFilterView setFrameOriginX:-34];
    [self.profilesFilterView setFrameOriginX:-34];
    
    if (self.selectedFilter != nil) {
        if (self.selectedFilter.filterGroup == kFilterGroupEmotion) {
            [self.moodsFilterView setFrameOriginX:0];
        } else {
            [self.activitiesFilterView setFrameOriginX:0];
        }
    } else if (self.selectedProfile != nil) {
        [self.profilesFilterView setFrameOriginX:0];
    }
}
@end


@implementation MyAnnotation

-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates image:(NSString *)paramImage article:(CDArticle*)article {
    
    self = [super init];
    if(self != nil)
    {
        _coordinate = paramCoordinates;
        _image = paramImage;
        _article = article;
    }
    return (self);
}

@end
