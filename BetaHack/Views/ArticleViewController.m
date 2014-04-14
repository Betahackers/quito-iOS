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
    self.tableView.backgroundColor = [self lightColourForFilterGroup:self.selectedFilterGroup];
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
            [cell.nameLabel applyFontMontserratWithWeight:kFontWeightBold];
            cell.expertLabel.text = [NSString stringWithFormat:@"Expert in... %@", self.article.profile.expertIn];
            [cell.expertLabel applyFontMontserratWithWeight:kFontWeightBold];
            
            cell.biographyLabel.text = self.article.profile.biography;
            
            cell.backgroundColor = [self colourForFilterGroup:self.selectedFilterGroup];
            
            return cell;
        }
            
        case kSectionProfileFooter: {
            
            static NSString *CellIdentifier = @"ArticleProfileFooterCell";
            ArticleProfileFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell.contentView applyMontserratFontToSubviews];
            
            cell.hometownLabel.text = self.article.profile.hometown;
            cell.jobTitleLabel.text = self.article.profile.jobTitle;
            cell.articleImageView.image = self.article.articleImage;
            
            cell.backgroundColor = [self colourForFilterGroup:self.selectedFilterGroup];
            
            return cell;
        }
            
        case kSectionArticle: {
            
            static NSString *CellIdentifier = @"ArticleBodyCell";
            ArticleBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell.contentView applyMontserratFontToSubviews];
            
            cell.introLabel.text = self.article.title;
            cell.titleLabel.text = self.article.locationName;
            [cell.titleLabel applyFontMontserratWithWeight:kFontWeightBold];
            cell.contentLabel.text = self.article.content;
            
            cell.backgroundColor = [self lightColourForFilterGroup:self.selectedFilterGroup];
            
            return cell;
        }
            
        default:
            return nil;
            break;
    }
}

- (UIColor*)colourForFilterGroup:(FilterGroup)filterGroup {
    switch (filterGroup) {
        case kFilterGroupCategory: return [UIColor fromtoActivityColour]; break;
        case kFilterGroupProfile: return [UIColor fromtoProfileColour]; break;
        case kFilterGroupEmotion: return [UIColor fromtoMoodColour]; break;
    }
}

- (UIColor*)lightColourForFilterGroup:(FilterGroup)filterGroup {
    switch (filterGroup) {
        case kFilterGroupCategory: return [UIColor fromtoActivityColourLight]; break;
        case kFilterGroupProfile: return [UIColor fromtoProfileColourLight]; break;
        case kFilterGroupEmotion: return [UIColor fromtoMoodColourLight]; break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (indexPath.section == kSectionHeader)
        CellIdentifier = @"ArticleHeaderCell";
    else if (indexPath.section == kSectionProfile)
        CellIdentifier = @"ArticleProfileCell";
    else if (indexPath.section == kSectionProfileFooter)
        CellIdentifier = @"ArticleProfileFooterCell";
    else if (indexPath.section == kSectionArticle)
        CellIdentifier = @"ArticleBodyCell";
    
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