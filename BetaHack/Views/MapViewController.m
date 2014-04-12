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
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (nonatomic, strong) IBOutlet UIView *menuContainerView;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    
    //41.407001,2.156799
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(41.407001, 2.156799);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
}

- (void)viewDidAppear:(BOOL)animated {
    [self shrinkTable];
    
    double delayInSeconds = 1.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //code to be executed on the main queue after delay
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(41.407001, 2.156799);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = {coord, span};
        [self.mapView setRegion:region animated:YES];
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
}

- (IBAction)locationTapped:(UIButton*)sender {
    
    NSArray *articles = [[Installation currentInstallation] sortedArticles];
    CDArticle *article = [articles objectAtIndex:sender.tag - 1001];
   
    [self performSegueWithIdentifier:@"map_article" sender:article];
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

@end
