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
@property (nonatomic, strong) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *surnameLabel;
@property (nonatomic, strong) IBOutlet UILabel *expertInLabel;
@property (nonatomic, strong) IBOutlet UILabel *expertLabel;
@property (nonatomic, strong) IBOutlet UILabel *hometownLabel;
@property (nonatomic, strong) IBOutlet UILabel *jobTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *biographyLabel;
@property (nonatomic, strong) IBOutlet UILabel *overlayBiographyLabel;

- (void)initWithArticle:(CDArticle*)article delegate:(id<ArticleViewDelegate>)delegate;

@end




@interface ArticleImageCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *articleImageView;
- (void)initWithArticle:(CDArticle*)article;
@end




@interface ArticleTitleCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *overlayTitleLabel;
- (void)initWithArticle:(CDArticle*)article;
@end


@interface ArticleSubtitleCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *overlaySubtitleLabel;
- (void)initWithArticle:(CDArticle*)article;
@end




@interface ArticleDescriptionCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *overlayContentLabel;
- (void)initWithArticle:(CDArticle*)article;
@end




@interface ArticleAddressCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *addressLine1;
@property (nonatomic, strong) IBOutlet UILabel *addressLine2;
- (void)initWithArticle:(CDArticle*)article;
@end




@interface ArticleURLCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *url;
@property (nonatomic, strong) CDArticle *article;
- (void)initWithArticle:(CDArticle*)article;
@end




@interface ArticleSocialCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *foursquareLabel;
- (void)initWithArticle:(CDArticle*)article;
@end



