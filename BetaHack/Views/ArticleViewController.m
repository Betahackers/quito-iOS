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
    BOOL isLoadingFullLocation;
}
@end

@implementation ArticleViewController

typedef enum tableSections
{
    kSectionProfile,
    kSectionArticleImage,
    kSectionArticleTitle,
    kSectionArticleSubtitle,
    kSectionArticleDescription,
    kSectionArticleAddress,
    kSectionArticleURL,
    kSectionArticleSocial
} TableSections;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view applyMontserratFontToSubviews];
    self.tableView.backgroundColor = [self lightColourForFilterGroup:self.selectedFilterGroup];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"profilePhotoUpdated"
                                               object:nil];
    
    [self reloadTable];
    
    [self.article.locations.anyObject fetchFullLocation:^(NSError *error) {
         [self reloadTable];
    } completion:^(NSError *error) {
         [self reloadTable];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"profilePhotoUpdated" object:nil];
}

- (void)reloadTable {
    
    sections = [NSMutableArray array];
    
    [sections addObject:[NSArray arrayWithObject:self.article]];
    [sections addObject:[NSArray arrayWithObject:self.article]];
    [sections addObject:[NSArray arrayWithObject:self.article]];
    [sections addObject:[NSArray arrayWithObject:self.article]];
    [sections addObject:[NSArray arrayWithObject:self.article]];
    
    //address
    if (self.article.location.addressLine1.length > 0) {
        [sections addObject:[NSArray arrayWithObject:self.article]];
    } else {
        [sections addObject:[NSArray array]];
    }
    
    //url
    if (self.article.location.locationURL.length > 0) {
        [sections addObject:[NSArray arrayWithObject:self.article]];
    } else {
        [sections addObject:[NSArray array]];
    }
    
    //social
    if (self.article.location.foursquareURL.length > 0) {
        [sections addObject:[NSArray arrayWithObject:self.article]];
    } else {
        [sections addObject:[NSArray array]];
    }
    
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
            [cell initWithArticle:self.article delegate:self];
            cell.backgroundColor = [self colourForFilterGroup:self.selectedFilterGroup];
            return cell;
        }
            
        case kSectionArticleImage: {
            static NSString *CellIdentifier = @"ArticleImageCell";
            ArticleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell initWithArticle:self.article];
            return cell;
        }
            
        case kSectionArticleTitle: {
            static NSString *CellIdentifier = @"ArticleTitleCell";
            ArticleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell initWithArticle:self.article];
            cell.backgroundColor = [self lightColourForFilterGroup:self.selectedFilterGroup];
            return cell;
        }
            
        case kSectionArticleSubtitle: {
            static NSString *CellIdentifier = @"ArticleSubtitleCell";
            ArticleSubtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell initWithArticle:self.article];
            cell.backgroundColor = [self lightColourForFilterGroup:self.selectedFilterGroup];
            return cell;
        }
            
        case kSectionArticleDescription: {
            static NSString *CellIdentifier = @"ArticleDescriptionCell";
            ArticleDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell initWithArticle:self.article];
            cell.backgroundColor = [self lightColourForFilterGroup:self.selectedFilterGroup];
            return cell;
        }
            
        case kSectionArticleAddress: {
            static NSString *CellIdentifier = @"ArticleAddressCell";
            ArticleAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell initWithArticle:self.article];
            cell.backgroundColor = [self lightColourForFilterGroup:self.selectedFilterGroup];
            return cell;
        }
            
        case kSectionArticleURL: {
            static NSString *CellIdentifier = @"ArticleURLCell";
            ArticleURLCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell initWithArticle:self.article];
            cell.backgroundColor = [self lightColourForFilterGroup:self.selectedFilterGroup];
            return cell;
        }
            
        case kSectionArticleSocial: {
            static NSString *CellIdentifier = @"ArticleSocialCell";
            ArticleSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    if (indexPath.section == kSectionProfile) {
        CellIdentifier = @"ArticleProfileCell";
        ArticleProfileCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell initWithArticle:self.article delegate:self];
        return cell.overlayBiographyLabel.frame.origin.y + cell.overlayBiographyLabel.frame.size.height + 10;
    } else if (indexPath.section == kSectionArticleImage)
        CellIdentifier = @"ArticleImageCell";
    else if (indexPath.section == kSectionArticleTitle) {
        CellIdentifier = @"ArticleTitleCell";
        ArticleTitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell initWithArticle:self.article];
        return cell.overlayTitleLabel.frame.origin.y + cell.overlayTitleLabel.frame.size.height + 4;
    } else if (indexPath.section == kSectionArticleSubtitle) {
        CellIdentifier = @"ArticleSubtitleCell";
        ArticleSubtitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell initWithArticle:self.article];
        return cell.overlaySubtitleLabel.frame.origin.y + cell.overlaySubtitleLabel.frame.size.height + 4;
    } else if (indexPath.section == kSectionArticleDescription) {
        CellIdentifier = @"ArticleDescriptionCell";
        ArticleDescriptionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell initWithArticle:self.article];
        return cell.overlayContentLabel.frame.origin.y + cell.overlayContentLabel.frame.size.height + 10;
    } else if (indexPath.section == kSectionArticleAddress)
        CellIdentifier = @"ArticleProfileCell";
    else if (indexPath.section == kSectionArticleURL)
        CellIdentifier = @"ArticleProfileCell";
    else if (indexPath.section == kSectionArticleSocial)
        CellIdentifier = @"ArticleProfileCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell.bounds.size.height;
}

@end

#pragma mark - Prototype cells
@implementation ArticleProfileCell

- (void)initWithArticle:(CDArticle*)article delegate:(id<ArticleViewDelegate>)delegate {
    
    self.delegate = delegate;
    
    [self.contentView applyMontserratFontToSubviews];
    
    self.profileImageView.image = article.profile.profileImage;
    self.profileImageView.layer.masksToBounds = NO;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = (self.profileImageView.frame.size.height / 2);
    
    self.firstNameLabel.text = article.profile.firstName;
    [self.firstNameLabel applyFontMontserratWithWeight:kFontWeightBold];
    
    self.surnameLabel.text = article.profile.lastName;
    [self.surnameLabel applyFontMontserratWithWeight:kFontWeightBold];
    
    self.expertInLabel.text = article.profile.expertIn;
    [self.expertInLabel applyFontMontserratWithWeight:kFontWeightBold];
    [self.expertLabel applyFontMontserratWithWeight:kFontWeightBold];
    
    self.biographyLabel.text = article.profile.biography;
    [self.biographyLabel applyFontMontserratWithWeight:kFontWeightBold];
    self.overlayBiographyLabel = [self.biographyLabel replaceWithMultilineLabel];
    
    self.hometownLabel.text = article.profile.hometown;
    self.jobTitleLabel.text = article.profile.jobTitle;
}

- (IBAction)backTapped:(id)sender {
    [self.delegate popViewController];
}
@end

@implementation ArticleImageCell

- (void)initWithArticle:(CDArticle*)article {
    
    if (article.location.image != nil) {
        self.articleImageView.image = article.location.image;
    }
}
@end

@implementation ArticleTitleCell

- (void)initWithArticle:(CDArticle*)article {
    
    [self.contentView applyMontserratFontToSubviews];
    self.titleLabel.text = article.location.name;
    [self.titleLabel applyFontMontserratWithWeight:kFontWeightBold];
    self.overlayTitleLabel = [self.titleLabel replaceWithMultilineLabel];
}
@end

@implementation ArticleSubtitleCell

- (void)initWithArticle:(CDArticle*)article {
    
    [self.contentView applyMontserratFontToSubviews];
    self.subtitleLabel.text = article.title;
    [self.subtitleLabel applyFontMontserratWithWeight:kFontWeightBold];
    self.overlaySubtitleLabel = [self.subtitleLabel replaceWithMultilineLabel];
}
@end

@implementation ArticleDescriptionCell

- (void)initWithArticle:(CDArticle*)article {
    
    [self.contentView applyMontserratFontToSubviews];
    self.contentLabel.text = article.content;
    self.overlayContentLabel = [self.contentLabel replaceWithMultilineLabel];
}
@end

@implementation ArticleAddressCell

- (void)initWithArticle:(CDArticle*)article {
    
    [self.contentView applyMontserratFontToSubviews];
    self.addressLine1.text = article.location.addressLine1;
    self.addressLine2.text = article.location.formattedTelephoneNumber;
}
@end

@implementation ArticleURLCell

- (void)initWithArticle:(CDArticle*)article {
    
    [self.contentView applyMontserratFontToSubviews];
//    self.url.text = article.locations;
    [self.url applyFontMontserratWithWeight:kFontWeightBold];
}
@end

@implementation ArticleSocialCell

- (void)initWithArticle:(CDArticle*)article {
    
    [self.contentView applyMontserratFontToSubviews];
//    self.foursquareLabel.text = article.locations;
    [self.foursquareLabel applyFontMontserratWithWeight:kFontWeightBold];
}
@end