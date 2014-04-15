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

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

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
    [[Installation currentInstallation] fetchUsers:^(NSError *error) {
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
            
            if (![Installation currentInstallation].isShownTutorial) {
                [self showTutorial];
            } else {
                [self moveToNextScreen];
            }
            
            isFinishedAnimating = YES;
        });
        
    }];
}

- (void)moveToNextScreen {
    
    if (isFinishedAnimating && isFinishedFetching) {
        [self performSegueWithIdentifier:@"splash_map" sender:self];
    }
}

- (void)showTutorial {
    
    _moviePlayer =  [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tutorial" ofType:@"mp4"]]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [_moviePlayer prepareToPlay];
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
    [_moviePlayer stop];
    [_moviePlayer play];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
        [player.view removeFromSuperview];
    }
    
    [Installation currentInstallation].isShownTutorial = YES;
    [self moveToNextScreen];
}
@end
