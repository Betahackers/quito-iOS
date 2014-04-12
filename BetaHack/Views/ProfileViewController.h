//
//  ProfileViewController.h
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Profile Software S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DomainEnums.h"

@class CDProfile;

#pragma mark - ProfileViewDelegate
@protocol ProfileViewDelegate
@end


#pragma mark - ProfileViewController
@interface ProfileViewController : UITableViewController <ProfileViewDelegate>

@property (nonatomic, weak) CDProfile *profile;

@end


#pragma mark - ProfileHeaderCell
@interface ProfileHeaderCell : UITableViewCell
@property (nonatomic, weak) id<ProfileViewDelegate> delegate;
@property (nonatomic, weak) CDProfile *profile;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@end
