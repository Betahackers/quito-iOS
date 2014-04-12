//
//  ProfileViewController.h
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Profile Software S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DomainEnums.h"

#pragma mark - ProfileViewDelegate
@protocol ProfileViewDelegate
@end


#pragma mark - ProfileViewController
@interface ProfileViewController : UITableViewController

//@property (nonatomic, weak) CDProfile *article;

@end


#pragma mark - ProfileHeaderCell
@interface ProfileHeaderCell : UITableViewCell
@property (nonatomic, weak) id<ProfileViewDelegate> delegate;
@end
