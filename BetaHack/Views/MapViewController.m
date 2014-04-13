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
#import "MenuViewController.h"
#import "FilterViewController.h"

@interface MapViewController ()

@property (nonatomic, strong) IBOutlet UIView *menuContainerView;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CDProfile *selectedProfile;
@property (nonatomic, strong) CDFilter *selectedFilter;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view applyMontserratFontToSubviews];
    [self.menuContainerView setAlpha:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    
    //41.407001,2.156799
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(41.407001, 2.156799);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
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
    }
    if ([segue.identifier isEqualToString:@"map_menu"]) {
        MenuViewController *viewController = (MenuViewController *)segue.destinationViewController;
        viewController.mapViewDelegate = self;
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
    
    if (!self.selectedProfile && !self.selectedFilter) {
        FilterViewController *viewController = [[FilterViewController alloc] init];
        [self performSegueWithIdentifier:@"map_filter" sender:[NSNumber numberWithInt:sender.tag]];
    } else {
        
        //remove filters
        self.selectedFilter = nil;
        self.selectedProfile = nil;
        [self reloadAnnotations];
    }
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
    [self reloadAnnotations];
}

- (void)applyProfile:(CDProfile *)profile {
    if (self.selectedProfile == profile) {
        self.selectedProfile = nil;
    } else {
        self.selectedProfile = profile;
    }
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
        
        annotationView.image = [UIImage imageNamed:@"point_select_moods.png"];
        
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
    [[Installation currentInstallation] fetchArticlesWithRadius:radius completion:^(NSError *error) {
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
