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

@interface HeaderViewController () {
    BOOL isDownArrow;
}

@property (nonatomic, strong) IBOutlet UIImageView *downButtonImageView;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation HeaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view applyMontserratFontToSubviews];
    
    isDownArrow = YES;
}

- (IBAction)downTapped:(id)sender {
    [self.mapViewDelegate showHideHeader];
    
    isDownArrow = !isDownArrow;
    if (isDownArrow) {
        [self.downButtonImageView setImage:[UIImage imageNamed:@"DownArrow.png"]];
    } else {
        [self.downButtonImageView setImage:[UIImage imageNamed:@"UpArrow.png"]];
    }
}

- (IBAction)playTapped:(id)sender {
    
    _moviePlayer =  [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"promo" ofType:@"mp4"]]];
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
}
@end