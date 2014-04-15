//
//  ArticleViewController.h
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Article Software S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DomainEnums.h"
#import "MapViewController.h"

#pragma mark - ArticleViewController
@interface HeaderViewController : UIViewController

@property (nonatomic, weak) id<MapViewDelegate> mapViewDelegate;

@end