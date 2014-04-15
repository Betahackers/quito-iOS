//
//  ArticleViewController.m
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Article Software S.L. All rights reserved.
//

#import "ArticleViewController.h"
#import "DomainManager.h"
#import "ILTranslucentView.h"

@interface ArticleViewController () {
    NSMutableArray *sections;
}
@end

@implementation ArticleViewController

typedef enum tableSections
{
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
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self reloadTable];
    
    [self.article.locations.anyObject fetchFullLocation:^(NSError *error) {
        [self reloadTable];
    }];
}

- (void)reloadTable {
    
    sections = [NSMutableArray array];
    
    [sections addObject:[NSArray arrayWithObject:self.article]];
    [sections addObject:[NSArray arrayWithObject:self.article]];
    [sections addObject:[NSArray arrayWithObject:self.article]];
    
    [self.tableView reloadData];
}

#pragma mark - ArticleCardCellDelegate
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
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
        
        case kSectionProfile: {
    
            static NSString *CellIdentifier = @"ArticleProfileCell";
            ArticleProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell.contentView applyMontserratFontToSubviews];
            
            cell.delegate = self;
            
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
            
            if (self.article.articleImage != nil) {
                cell.articleImageView.image = self.article.articleImage;
            } else {
                cell.articleImageView.image = [UIImage imageNamed:@"Temp_Barceloneta.jpg"];
                
                ILTranslucentView *translucentView = [[ILTranslucentView alloc] initWithFrame:cell.articleImageView.bounds];
                translucentView.translucentStyle = UIBarStyleBlack;
                [cell.articleImageView addSubview:translucentView];
            }
            
            cell.backgroundColor = [self colourForFilterGroup:self.selectedFilterGroup];
            
            return cell;
        }
            
        case kSectionArticle: {
            
            static NSString *CellIdentifier = @"ArticleBodyCell";
            ArticleBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell initWithArticle:self.article];
            cell.backgroundColor = [self lightColourForFilterGroup:self.selectedFilterGroup];
            return cell;
        }
            
        default:
            return nil;
            break;
    }
}

- (UIColor*)colourForFilterGroup:(FilterGroup)filterGroup {
   
    NSLog(@"SELECTED filter GROUP = %d", self.selectedFilterGroup);
    
    switch (filterGroup) {
        case kFilterGroupCategory: return [UIColor fromtoActivityColour]; break;
        case kFilterGroupProfile: return [UIColor fromtoProfileColour]; break;
        case kFilterGroupEmotion: return [UIColor fromtoMoodColour]; break;
    }
}

- (UIColor*)lightColourForFilterGroup:(FilterGroup)filterGroup {
    
    NSLog(@"SELECTED filter GROUP = %d", self.selectedFilterGroup);
    
    switch (filterGroup) {
        case kFilterGroupCategory: return [UIColor fromtoActivityColourLight]; break;
        case kFilterGroupProfile: return [UIColor fromtoProfileColourLight]; break;
        case kFilterGroupEmotion: return [UIColor fromtoMoodColourLight]; break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (indexPath.section == kSectionProfile)
        CellIdentifier = @"ArticleProfileCell";
    else if (indexPath.section == kSectionProfileFooter)
        CellIdentifier = @"ArticleProfileFooterCell";
    else if (indexPath.section == kSectionArticle) {
        CellIdentifier = @"ArticleBodyCell";
        ArticleBodyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell initWithArticle:self.article];
        return cell.overlayContentLabel.frame.origin.y + cell.overlayContentLabel.frame.size.height + 10;
    }
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell.bounds.size.height;
}

@end

#pragma mark - Prototype cells
@implementation ArticleProfileCell

- (IBAction)backTapped:(id)sender {
    [self.delegate popViewController];
}
@end

@implementation ArticleProfileFooterCell
@end

@implementation ArticleBodyCell

- (void)initWithArticle:(CDArticle*)article {
    
    [self.contentView applyMontserratFontToSubviews];
    
    self.introLabel.text = article.title;
    self.titleLabel.text = article.locationName;
    [self.titleLabel applyFontMontserratWithWeight:kFontWeightBold];
    self.contentLabel.text = article.content;
    
    //hide the suggestion label and add another label ontop with a variable size
    self.contentLabel.hidden = YES;
    self.overlayContentLabel = [[UILabel alloc] initWithFrame:self.contentLabel.frame];
    [self.overlayContentLabel setFont:self.contentLabel.font];
    [self.overlayContentLabel setText:self.contentLabel.text];
    [self.overlayContentLabel setTextAlignment:self.contentLabel.textAlignment];
    [self.overlayContentLabel setNumberOfLines:0];
    [self.overlayContentLabel setTextColor:self.contentLabel.textColor];
    [self.overlayContentLabel sizeToFit];
    [self addSubview:self.overlayContentLabel];
}
@end