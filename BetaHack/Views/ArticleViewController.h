//
//  ArticleViewController.h
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Article Software S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DomainEnums.h"

#pragma mark - ArticleViewDelegate
@protocol ArticleViewDelegate
@end


#pragma mark - ArticleViewController
@interface ArticleViewController : UITableViewController

//@property (nonatomic, weak) CDArticle *article;

@end


#pragma mark - ArticleHeaderCell
@interface ArticleHeaderCell : UITableViewCell
@property (nonatomic, weak) id<ArticleViewDelegate> delegate;
@end
