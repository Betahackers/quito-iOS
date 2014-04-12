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
@property (nonatomic, weak) id<ArticleViewDelegate> delegate;
@property (nonatomic, strong) CDArticle *article;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *authorButton;
@end
