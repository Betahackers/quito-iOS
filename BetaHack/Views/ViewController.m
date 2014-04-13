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

@property (nonatomic, strong) IBOutlet UILabel *startLabel;

@end

@implementation ViewController

BOOL isFinishedAnimating;
BOOL isFinishedFetching;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view applyMontserratFontToSubviews];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //pull some articles
    [[Installation currentInstallation] fetchArticles:^(NSError *error) {
        isFinishedFetching = YES;
        [self moveToNextScreen];
    }];

    [UIView animateWithDuration:2.0 animations:^{
        self.startLabel.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
        //show the map
        float delayInSeconds = 2.0;
        float popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            isFinishedAnimating = YES;
            [self moveToNextScreen];
        });
        
    }];
}

- (void)moveToNextScreen {
    
    if (isFinishedAnimating && isFinishedFetching) {
        [self performSegueWithIdentifier:@"splash_map" sender:self];
    }
}

@end
