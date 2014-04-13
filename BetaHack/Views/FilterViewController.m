//
//  FilterViewController.m
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Filter Software S.L. All rights reserved.
//

#import "FilterViewController.h"
#import "DomainManager.h"
#import "ProfileViewController.h"

@interface FilterViewController () {
    NSMutableArray *sections;
}
@end

@implementation FilterViewController

typedef enum tableSections
{
    kSectionMain
} TableSections;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view applyMontserratFontToSubviews];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.titleLabel applyFontMontserratWithWeight:kFontWeightBold];
    
    switch (self.filterGroup) {
        case kFilterGroupCategory:
            self.view.backgroundColor = [UIColor colorWithRed:156/255.0 green:146/255.0 blue:205/255.0 alpha:1.0];
            self.titleLabel.text = @"Activities";
            break;
        case kFilterGroupEmotion:
            self.view.backgroundColor = [UIColor colorWithRed:42/255.0 green:197/255.0 blue:193/255.0 alpha:1.0];
            self.titleLabel.text = @"Moods";
            break;
        case kFilterGroupProfile:
            self.view.backgroundColor = [UIColor colorWithRed:42/255.0 green:197/255.0 blue:193/255.0 alpha:1.0];
            self.titleLabel.text = @"Profiles";
            break;
        default:
            break;
    }
    
    
    [self reloadTable];
}

- (void)reloadTable {
    
    sections = [NSMutableArray array];
    
    switch (self.filterGroup) {
        case kFilterGroupCategory:
            [sections addObject:[[Installation currentInstallation] sortedFilterByGroup:kFilterGroupCategory]];
            break;
        case kFilterGroupEmotion:
            [sections addObject:[[Installation currentInstallation] sortedFilterByGroup:kFilterGroupEmotion]];
            break;
        case kFilterGroupProfile:
            [sections addObject:[Installation currentInstallation].sortedProfiles];
            break;
        default:
            break;
    }
    
    [self.collectionView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"filter_profile"]) {
        CDProfile *profile = (CDProfile*)sender;
        ProfileViewController *viewController = (ProfileViewController *)segue.destinationViewController;
        viewController.profile = profile;
    }
}

#pragma mark - FilterCardCellDelegate
- (void)showProfile:(CDProfile *)profile {
    [self performSegueWithIdentifier:@"filter_profile" sender:profile];
}

#pragma mark - TableView data source
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [sections count];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSArray *objects = [sections objectAtIndex:section];
    return objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case kSectionMain: {
            
            //header
            static NSString *CellIdentifier = @"FilterCell";
            FilterCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell.contentView applyMontserratFontToSubviews];
            
            id filterItem = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            if ([filterItem isKindOfClass:[CDProfile class]]) {
                CDProfile *profile = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                cell.titleLabel.text = profile.displayName;
                cell.filterImage.image = profile.profileImage;
                cell.filterImage.layer.masksToBounds = NO;
                cell.filterImage.clipsToBounds = YES;
                cell.filterImage.layer.cornerRadius = (cell.filterImage.frame.size.height / 2);
            }
            
            if ([filterItem isKindOfClass:[CDFilter class]]) {
                CDFilter *filter = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                cell.titleLabel.text = filter.name;
                cell.filterImage.image = filter.filterImage;
            }
            
            return cell;
        }
            
        default:
            return nil;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.filterGroup) {
        case kFilterGroupCategory:
        case kFilterGroupEmotion: {
            CDFilter *filter = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [self.mapViewDelegate applyFilter:filter];
            break;
        }
            
        default: {
            CDProfile *profile = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [self.mapViewDelegate applyProfile:profile];
            break;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(120, 120);
}

@end

#pragma mark - Prototype cells
@implementation FilterCell
@end