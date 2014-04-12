//
//  MenuViewController.h
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Menu Software S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DomainEnums.h"

@class CDMenu, CDProfile;

#pragma mark - MenuViewDelegate
@protocol MenuViewDelegate
- (void)showProfile:(CDProfile*)profile;
@end


#pragma mark - MenuViewController
@interface MenuViewController : UITableViewController <MenuViewDelegate>

@property (nonatomic, weak) CDMenu *menu;

@end


#pragma mark - MenuHeaderCell
@interface MenuCategoryCell : UITableViewCell
@property (nonatomic, weak) id<MenuViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@end

@interface MenuCategoryItemCell : UITableViewCell
@property (nonatomic, weak) id<MenuViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@end

@interface MenuProfileCell : UITableViewCell
@property (nonatomic, weak) id<MenuViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@end

@interface MenuProfileItemCell : UITableViewCell
@property (nonatomic, weak) id<MenuViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@end

@interface MenuEmotionCell : UITableViewCell
@property (nonatomic, weak) id<MenuViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@end

@interface MenuEmotionItemCell : UITableViewCell
@property (nonatomic, weak) id<MenuViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@end