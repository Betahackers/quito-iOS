//
//  ViewController.m
//  BetaHack
//
//  Created by Duncan Campbell on 12/04/14.
//  Copyright (c) 2014 Betahackers. All rights reserved.
//

#import "ViewController.h"
#import "DomainManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MapKit/MapKit.h>
#import "Mixpanel.h"

@interface ViewController ()

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) IBOutlet UIImageView *splashImageView;

@end

@implementation ViewController

BOOL isFinishedAnimating;
BOOL isFinishedFetching;
BOOL isFetchingRequired;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view applyMontserratFontToSubviews];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.splashImageView setAlpha:0.0f];
    
    if ([Installation currentInstallation].locations.count == 0) {
        isFetchingRequired = YES;
    }
    
    //pull some articles
    NSLog(@"Fetching locations");
    [[Installation currentInstallation] fetchLocationsWithRadius:8000 long:2.156799 lat:41.407001 filter:nil profile:nil completion:^(NSError *error) {
        
        NSLog(@"Fetching users");
        [[Installation currentInstallation] fetchUsers:^(NSError *error) {
            
            NSLog(@"Finished fetching users");
            
            isFinishedFetching = YES;
            
            if (isFetchingRequired) {
                [self moveToNextScreen];
            }
        }];
    }];

    [UIView animateWithDuration:2.0f animations:^{
        self.splashImageView.alpha = 1.0f;
    
    } completion:^(BOOL finished) {
        
        //show the map
        float delayInSeconds = 2.0;
        float popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if (![Installation currentInstallation].isShownTutorial) {
                [self showTutorial];
            } else {
                isFinishedAnimating = YES;
                [self moveToNextScreen];
            }
        });
        
    }];
}

- (void)viewDidLayoutSubviews {
    [self.splashImageView centerWithinSuperview];
}

- (void)moveToNextScreen {
    
    if (isFinishedAnimating) {
        
        //only continue when the fetch is complete (if necessary)
        if (isFinishedFetching || !isFetchingRequired) {
            [self performSegueWithIdentifier:@"splash_map" sender:self];
        } else {
            
            //still fetching, so show a loading wheel
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
            [label setBackgroundColor:[UIColor whiteColor]];
            [label setTextColor:[UIColor fromtoMoodColour]];
            [label setFont:[UIFont montserratWithWeight:kFontWeightRegular size:10]];
            label.text = @"loading...";
            label.textAlignment = NSTextAlignmentCenter;
            
            [label.layer setCornerRadius:12];
            label.clipsToBounds = YES;
            
            label.alpha = 0.0f;
            [self.view addSubview:label];
            [label centerWithinSuperview];
            [label setFrameOriginY:self.view.frame.size.height - 60];
            
            [UIView animateWithDuration:0.5 animations:^{
                [label setAlpha:1.0f];
            }];
        }
    }
}

- (void)showTutorial {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"tutorial" withExtension:@"mp4"];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    self.moviePlayer.view.transform = CGAffineTransformConcat(self.moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    UIWindow *backgroundWindow = [[UIApplication sharedApplication] keyWindow];
    [self.moviePlayer.view setFrame:backgroundWindow.frame];
    [backgroundWindow addSubview:self.moviePlayer.view];
    [self.moviePlayer play];
    
    [[Mixpanel sharedInstance] track:@"Tutorial viewed" properties:@{@"View": @"Launch"}];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
        [player.view removeFromSuperview];
    }
    
    [Installation currentInstallation].isShownTutorial = YES;
    [[DomainManager sharedManager].context save:nil];
    
    isFinishedAnimating = YES;
    [self moveToNextScreen];
}
@end
