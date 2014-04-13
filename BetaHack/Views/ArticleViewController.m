//
//  ArticleViewController.m
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Article Software S.L. All rights reserved.
//

#import "ArticleViewController.h"
#import "DomainManager.h"
#import "ProfileViewController.h"

@interface ArticleViewController () {
    NSMutableArray *sections;
}
@end

@implementation ArticleViewController

typedef enum tableSections
{
    kSectionHeader,
    kSectionProfile,
    kSectionProfileFooter,
    kSectionArticle
} TableSections;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view applyMontserratFontToSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO];
    
    sections = [NSMutableArray array];
    [self reloadTable];
}

- (void)reloadTable {
    
    sections = [NSMutableArray array];
    
    [sections addObject:[NSArray arrayWithObject:self.article]];
    [sections addObject:[NSArray arrayWithObject:self.article]];
    [sections addObject:[NSArray arrayWithObject:self.article]];
    [sections addObject:[NSArray arrayWithObject:self.article]];
    
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"article_profile"]) {
        CDProfile *profile = (CDProfile*)sender;
        ProfileViewController *viewController = (ProfileViewController *)segue.destinationViewController;
        viewController.profile = profile;
    }
}

#pragma mark - ArticleCardCellDelegate
- (void)showProfile:(CDProfile *)profile {
    [self performSegueWithIdentifier:@"article_profile" sender:profile];
}

#pragma mark - TableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *objects = [sections objectAtIndex:section];
    return objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kSectionHeader: {
            
            static NSString *CellIdentifier = @"ArticleHeaderCell";
            ArticleHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            return cell;
        }
            
        case kSectionProfile: {
    
            static NSString *CellIdentifier = @"ArticleProfileCell";
            ArticleProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell.contentView applyMontserratFontToSubviews];
            
            cell.profileImageView.image = self.article.profile.profileImage;
            cell.profileImageView.layer.masksToBounds = NO;
            cell.profileImageView.clipsToBounds = YES;
            cell.profileImageView.layer.cornerRadius = (cell.profileImageView.frame.size.height / 2);
            
            cell.nameLabel.text = self.article.profile.displayName;
            cell.expertLabel.text = [NSString stringWithFormat:@"Expert in... %@", self.article.profile.expertIn];
            
            cell.biographyLabel.text = self.article.profile.biography;
            return cell;
        }
            
        case kSectionProfileFooter: {
            
            static NSString *CellIdentifier = @"ArticleProfileFooterCell";
            ArticleProfileFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell.contentView applyMontserratFontToSubviews];
            
            cell.hometownLabel.text = self.article.profile.hometown;
            cell.jobTitleLabel.text = self.article.profile.jobTitle;
            cell.articleImageView.image = self.article.articleImage;
            
            return cell;
        }
            
        case kSectionArticle: {
            
            static NSString *CellIdentifier = @"ArticleBodyCell";
            ArticleBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell.contentView applyMontserratFontToSubviews];
            
            cell.introLabel.text = self.article.intro;
            cell.titleLabel.text = self.article.title;
            cell.contentLabel.text = self.article.content;
            
            return cell;
        }
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (indexPath.section == kSectionHeader)
        CellIdentifier = @"ArticleHeaderCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell.bounds.size.height;
}

@end

#pragma mark - Prototype cells
@implementation ArticleHeaderCell
@end

@implementation ArticleProfileCell
@end

@implementation ArticleProfileFooterCell
@end

@implementation ArticleBodyCell
@end