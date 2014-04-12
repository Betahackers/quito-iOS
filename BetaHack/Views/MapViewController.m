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

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"map_article"]) {
        CDArticle *article = (CDArticle*)sender;
        ArticleViewController *viewController = (ArticleViewController *)segue.destinationViewController;
        viewController.article = article;
    }
}

- (IBAction)locationTapped:(UIButton*)sender {
    
    NSArray *articles = [[Installation currentInstallation] sortedArticles];
    CDArticle *article = [articles objectAtIndex:sender.tag - 1001];
   
    [self performSegueWithIdentifier:@"map_article" sender:article];
}

@end
