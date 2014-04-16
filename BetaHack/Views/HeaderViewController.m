//
//  ArticleViewController.m
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Article Software S.L. All rights reserved.
//

#import "HeaderViewController.h"
#import "DomainManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface HeaderViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *downButtonImageView;
@property (nonatomic, strong) IBOutlet UIButton *tutorialButton;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation HeaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view applyMontserratFontToSubviews];
    [self.tutorialButton setAlpha:0.0f];
}

- (IBAction)downTapped:(id)sender {
    
    BOOL isShown = [self.mapViewDelegate showHideHeader];

    [UIView animateWithDuration:0.3 animations:^{
        if (isShown) {
            [self.downButtonImageView setImage:[UIImage imageNamed:@"UpArrow.png"]];
            [self.tutorialButton setAlpha:1.0f];
            
        } else {
            [self.downButtonImageView setImage:[UIImage imageNamed:@"DownArrow.png"]];
            [self.tutorialButton setAlpha:0.0f];
        }
    }];
}

- (IBAction)tutorialTapped:(id)sender {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"tutorial" withExtension:@"mp4"];
    [self playMovie:url];
}

- (IBAction)playTapped:(id)sender {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"promo" withExtension:@"mp4"];
    [self playMovie:url];
}

- (void)playMovie:(NSURL*)url {
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    self.moviePlayer.view.transform = CGAffineTransformConcat(self.moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    UIWindow *backgroundWindow = [[UIApplication sharedApplication] keyWindow];
    [self.moviePlayer.view setFrame:backgroundWindow.frame];
    [backgroundWindow addSubview:self.moviePlayer.view];
    [self.moviePlayer play];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    
//    if (player.currentPlaybackTime <= 0.1) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [player stop];
//            [player play];
//            [player pause];
//        });
//    } else {
    
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
        
        if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
            [player.view removeFromSuperview];
        }
//    }
}
@end