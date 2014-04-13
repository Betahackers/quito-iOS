//
//  ArticleViewController.h
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Article Software S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DomainEnums.h"

@class CDArticle, CDProfile;

#pragma mark - ArticleViewDelegate
@protocol ArticleViewDelegate
- (void)showProfile:(CDProfile*)profile;
@end


#pragma mark - ArticleViewController
@interface ArticleViewController : UITableViewController <ArticleViewDelegate>

@property (nonatomic, weak) CDArticle *article;

@end


#pragma mark - ArticleHeaderCell
@interface ArticleHeaderCell : UITableViewCell
@end

@interface ArticleProfileCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *expertLabel;
@property (nonatomic, strong) IBOutlet UILabel *biographyLabel;
@end

@interface ArticleProfileFooterCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *articleImageView;
@property (nonatomic, strong) IBOutlet UILabel *hometownLabel;
@property (nonatomic, strong) IBOutlet UILabel *jobTitleLabel;
@end

@interface ArticleBodyCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *introLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@end