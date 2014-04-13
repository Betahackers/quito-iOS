//
//  ViewController.m
//  BetaHack
//
//  Created by Duncan Campbell on 12/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import "ViewController.h"
#import "DomainManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //pull some articles
    [[Installation currentInstallation] fetchArticles];
    
    //show the map
    [self performSegueWithIdentifier:@"splash_map" sender:self];
}

@end
