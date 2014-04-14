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

@interface MapViewController ()

@property (nonatomic, strong) IBOutlet UIView *menuContainerView;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) IBOutlet UIButton *activitiesFilterButton;
@property (nonatomic, strong) IBOutlet UIButton *moodsFilterButton;
@property (nonatomic, strong) IBOutlet UIButton *profilesFilterButton;

@property (nonatomic, strong) IBOutlet UIImageView *activitiesFilterImageView;
@property (nonatomic, strong) IBOutlet UIImageView *moodsFilterImageView;
@property (nonatomic, strong) IBOutlet UIImageView *profilesFilterImageView;

@property (nonatomic, strong) CDProfile *selectedProfile;
@property (nonatomic, strong) CDFilter *selectedFilter;

@end

@implementation MapViewController

BOOL isFirstTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view applyMontserratFontToSubviews];
    [self.menuContainerView setAlpha:0];
    
    self.moodsFilterImageView = [[UIImageView alloc] initWithFrame:self.moodsFilterButton.bounds];
    [self.moodsFilterImageView setFrameOriginX:-self.moodsFilterImageView.frame.size.width];
    [self.moodsFilterImageView setFrameWidth:self.moodsFilterImageView.frame.size.width * 2];
    [self.moodsFilterButton addSubview:self.moodsFilterImageView];
    
    self.activitiesFilterImageView = [[UIImageView alloc] initWithFrame:self.moodsFilterButton.bounds];
    [self.activitiesFilterImageView setFrameOriginX:-self.activitiesFilterImageView.frame.size.width];
    [self.activitiesFilterImageView setFrameWidth:self.activitiesFilterImageView.frame.size.width * 2];
    [self.activitiesFilterButton addSubview:self.activitiesFilterImageView];
    
    self.profilesFilterImageView = [[UIImageView alloc] initWithFrame:self.moodsFilterButton.bounds];
    [self.profilesFilterImageView setFrameOriginX:-self.profilesFilterImageView.frame.size.width];
    [self.profilesFilterImageView setFrameWidth:self.profilesFilterImageView.frame.size.width * 2];
    self.profilesFilterImageView.layer.masksToBounds = NO;
    self.profilesFilterImageView.clipsToBounds = YES;
    self.profilesFilterImageView.layer.cornerRadius = (self.profilesFilterImageView.frame.size.height / 2);
    [self.profilesFilterButton addSubview:self.profilesFilterImageView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapHeader.png"]];
    [self.view addSubview:headerImageView];
    
    isFirstTime = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    
    //41.407001,2.156799
    if (isFirstTime) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(41.407001, 2.156799);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = {coord, span};
        [self.mapView setRegion:region];
        isFirstTime = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self shrinkTable];
    
    float delayInSeconds = 2.0;
    float popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.menuContainerView setAlpha:1];
        }];
    });
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
        switch ([sender intValue]) {
            case 1001: viewController.filterGroup = kFilterGroupEmotion; break;
            case 1002: viewController.filterGroup = kFilterGroupCategory; break;
            case 1003: viewController.filterGroup = kFilterGroupProfile; break;
        }
        viewController.mapViewDelegate = self;
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
    } else if (self.selectedFilter != nil) {
        if (self.selectedFilter.filterGroup == kFilterGroupEmotion && sender == self.moodsFilterButton) {
            self.selectedFilter = nil;
        } else if (self.selectedFilter.filterGroup == kFilterGroupCategory && sender == self.activitiesFilterButton) {
            self.selectedFilter = nil;
        } else {
            [self performSegueWithIdentifier:@"map_filter" sender:[NSNumber numberWithInt:sender.tag]];
        }
    } else {
        [self performSegueWithIdentifier:@"map_filter" sender:[NSNumber numberWithInt:sender.tag]];
    }
    
    [self reloadAnnotations];
}

- (void)shrinkTable {
    
    double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self.menuContainerView setFrameHeight:44*3];
    });
}

- (void)growTable {
    [self.menuContainerView setFrameHeight:self.view.frame.size.height];
}

- (void)applyFilter:(CDFilter *)filter {
    if (self.selectedFilter == filter) {
        self.selectedFilter = nil;
    } else {
        self.selectedFilter = filter;
    }
    self.selectedProfile = nil;
    [self reloadAnnotations];
}

- (void)applyProfile:(CDProfile *)profile {
    if (self.selectedProfile == profile) {
        self.selectedProfile = nil;
    } else {
        self.selectedProfile = profile;
    }
    self.selectedFilter = nil;
    [self reloadAnnotations];
}

#pragma mark - MKMapView Delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyAnnotation class]])
    {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else
        {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = NO;
        
        if (self.selectedFilter) {
            if (self.selectedFilter.filterGroup == kFilterGroupEmotion) {
                annotationView.image = [UIImage imageNamed:@"point_select_moods.png"];
            } else {
                annotationView.image = [UIImage imageNamed:@"point_select_activities.png"];
            }
        } else if (self.selectedProfile) {
            annotationView.image = [UIImage imageNamed:@"point_select_profiles.png"];
        } else {
            
            MyAnnotation *mapViewAnnotation = (MyAnnotation*)annotationView.annotation;
            switch (mapViewAnnotation.article.defaultFilterGroupColour) {
                case kFilterGroupCategory:
                    annotationView.image = [UIImage imageNamed:@"point_select_activities.png"];
                    break;
                case kFilterGroupEmotion:
                    annotationView.image = [UIImage imageNamed:@"point_select_moods.png"];
                    break;
                case kFilterGroupProfile:
                    annotationView.image = [UIImage imageNamed:@"point_select_profiles.png"];
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
    [self performSegueWithIdentifier:@"map_article" sender:mapViewAnnotation.article];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKMapRect mRect = mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    float distanceBetweenEastAndWest = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    float radius = distanceBetweenEastAndWest / 2.0f;
    
    NSLog(@"Radius: %f", radius);
    
    //now reload the points for this location
    [[Installation currentInstallation] fetchLocationsWithRadius:radius long:mapView.centerCoordinate.longitude lat:mapView.centerCoordinate.latitude completion:^(NSError *error) {
        [self reloadAnnotations];
    }];
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
    
    //hide all the buttons
    self.activitiesFilterImageView.image = nil;
    self.profilesFilterImageView.image = nil;
    self.moodsFilterImageView.image = nil;
    
    if (self.selectedFilter != nil) {
        if (self.selectedFilter.filterGroup == kFilterGroupEmotion) {
            [self.moodsFilterImageView setImage:self.selectedFilter.filterImage];
        } else {
            [self.activitiesFilterImageView setImage:self.selectedFilter.filterImage];
        }
    } else if (self.selectedProfile != nil) {
        [self.profilesFilterImageView setImage:self.selectedProfile.profileImage];
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
