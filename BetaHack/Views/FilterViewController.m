//
//  FilterViewController.m
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Filter Software S.L. All rights reserved.
//

#import "FilterViewController.h"
#import "DomainManager.h"
#import "Mixpanel.h"

@interface FilterViewController () {
    NSMutableArray *sections;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *chooseLabel;
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
            self.view.backgroundColor = [UIColor fromtoActivityColour];
            self.titleLabel.text = @"Activities";
            self.chooseLabel.text = @"Choose an activity";
            break;
        case kFilterGroupEmotion:
            self.view.backgroundColor = [UIColor fromtoMoodColour];
            self.titleLabel.text = @"Moods";
            self.chooseLabel.text = @"Choose a mood";
            break;
        case kFilterGroupProfile: {
            self.view.backgroundColor = [UIColor fromtoProfileColour];
            self.titleLabel.text = @"Profiles";
            self.chooseLabel.text = @"Choose a profile";
            
            [[Installation currentInstallation] fetchUsers:^(NSError *error) {
                [self reloadTable];
            }];
            
            break;
        }
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"profilePhotoUpdated"
                                               object:nil];
    
    [self reloadTable];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"profilePhotoUpdated" object:nil];
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

- (IBAction)backTapped:(id)sender {
    [[Mixpanel sharedInstance] track:@"Filter back tapped" properties:@{@"FilterGroup": self.titleLabel.text}];
    [self.navigationController popViewControllerAnimated:YES];
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
                cell.titleLabel.text = profile.shortDisplayName;
                cell.filterImage.image = profile.profileImage;
                cell.filterImage.layer.masksToBounds = NO;
                cell.filterImage.clipsToBounds = YES;
                cell.filterImage.layer.cornerRadius = (cell.filterImage.frame.size.height / 2);
            }
            
            if ([filterItem isKindOfClass:[CDFilter class]]) {
                CDFilter *filter = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                cell.titleLabel.text = filter.name;
                cell.filterImage.image = [filter filterImageWithCircle:YES];
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