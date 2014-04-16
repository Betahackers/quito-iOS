//
//  FilterViewController.h
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Filter Software S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DomainEnums.h"
#import "MapViewController.h"

@class CDFilter, CDProfile;

#pragma mark - FilterViewController
@interface FilterViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) FilterGroup filterGroup;
@property (nonatomic, assign) id<MapViewDelegate> mapViewDelegate;

@end


#pragma mark - FilterHeaderCell
@interface FilterCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *filterImage;
@end
