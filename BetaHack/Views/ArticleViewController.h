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
- (void)popViewController;
@end


#pragma mark - ArticleViewController
@interface ArticleViewController : UITableViewController <ArticleViewDelegate>

@property (nonatomic, weak) CDArticle *article;
@property (nonatomic, assign) FilterGroup selectedFilterGroup;

@end


#pragma mark - ArticleHeaderCell
@interface ArticleProfileCell : UITableViewCell
@property (nonatomic, weak) id<ArticleViewDelegate> delegate;
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
@property (nonatomic, strong) IBOutlet UILabel *overlayContentLabel;

- (void)initWithArticle:(CDArticle*)article;
@end