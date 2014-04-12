//
//  MenuViewController.m
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Menu Software S.L. All rights reserved.
//

#import "MenuViewController.h"
#import "DomainManager.h"

@interface MenuViewController () {
    NSMutableArray *sections;
    BOOL isExpanded;
    int expandedSection;
}
@end

@implementation MenuViewController

typedef enum tableSections
{
    kSectionEmotions,
    kSectionEmotionItems,
    kSectionCategory,
    kSectionCategoryItems,
    kSectionProfile,
    kSectionProfileItems,
    kSectionBlankCell
} TableSections;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    sections = [NSMutableArray array];
    
    [sections addObject:[NSArray arrayWithObject:@"Emotions"]];
    [sections addObject:[NSMutableArray array]];
    [sections addObject:[NSArray arrayWithObject:@"Categories"]];
    [sections addObject:[NSMutableArray array]];
    [sections addObject:[NSArray arrayWithObject:@"Profiles"]];
    [sections addObject:[NSMutableArray array]];
    [sections addObject:[NSArray arrayWithObject:@"Blank"]];
    
    [self reloadTable];
}

- (void)reloadTable {
    
    [self.tableView reloadData];
}

#pragma mark - MenuCardCellDelegate
- (void)showProfile:(CDProfile *)profile {
    [self performSegueWithIdentifier:@"menu_profile" sender:profile];
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
        case kSectionCategory: {
            
            //header
            static NSString *CellIdentifier = @"MenuCategoryCell";
            MenuCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *title = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.titleLabel.text = title;
            
            return cell;
        }
            
        case kSectionCategoryItems: {
            
            //header
            static NSString *CellIdentifier = @"MenuCategoryItemCell";
            MenuCategoryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CDFilter *filter = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.titleLabel.text = filter.name;
            
            return cell;
        }
            
        case kSectionProfile: {
            
            //header
            static NSString *CellIdentifier = @"MenuProfileCell";
            MenuProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *title = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.titleLabel.text = title;
            
            return cell;
        }
            
        case kSectionProfileItems: {
            
            //header
            static NSString *CellIdentifier = @"MenuProfileItemCell";
            MenuProfileItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CDProfile *profile = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.titleLabel.text = profile.name;
            
            return cell;
        }
            
        case kSectionEmotions: {
            
            //header
            static NSString *CellIdentifier = @"MenuEmotionCell";
            MenuEmotionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *title = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.titleLabel.text = title;
            
            return cell;
        }
            
        case kSectionEmotionItems: {
            
            //header
            static NSString *CellIdentifier = @"MenuEmotionItemCell";
            MenuEmotionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CDFilter *filter = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.titleLabel.text = filter.name;
            
            return cell;
        }
            
        case kSectionBlankCell: {
            
            //header
            static NSString *CellIdentifier = @"MenuEmptyCell";
            MenuEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    //if (indexPath.section == kSectionHeader)
        CellIdentifier = @"MenuEmotionCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell.bounds.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView beginUpdates];
    
    if (isExpanded) {
        
        //delete the rows we don't need
        NSMutableArray *array = [sections objectAtIndex:kSectionCategoryItems];
        for (CDFilter *filter in array) {
            int row = [array indexOfObject:filter];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:kSectionCategoryItems];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [array removeAllObjects];
        
        array = [sections objectAtIndex:kSectionProfileItems];
        for (CDProfile *profile in array) {
            int row = [array indexOfObject:profile];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:kSectionProfileItems];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [array removeAllObjects];
        
        array = [sections objectAtIndex:kSectionEmotionItems];
        for (CDFilter *filter in array) {
            int row = [array indexOfObject:filter];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:kSectionEmotionItems];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [array removeAllObjects];
        
        isExpanded = NO;
        
        if (expandedSection != indexPath.section) {
            [self performSelector:@selector(expandSection:) withObject:[NSNumber numberWithInteger:indexPath.section] afterDelay:0.4];
        } else {
            expandedSection = -1;
            [self.mapViewDelegate shrinkTable];
        }
        
    } else {
        [self expandSection:[NSNumber numberWithInt:indexPath.section]];
    }
    
    [tableView endUpdates];
}

- (void)expandSection:(NSNumber*)section {
    
    [self.tableView beginUpdates];
    
    //add the relevant rows to the selected section
    NSMutableArray *itemsArray;
    switch ([section intValue]) {
            
        case kSectionCategory: {
            itemsArray = [sections objectAtIndex:kSectionCategoryItems];
            
            NSArray *newItems = [[Installation currentInstallation] sortedFilterByGroup:kFilterGroupCategory];
            for (CDFilter *filter in newItems) {
                int row = [newItems indexOfObject:filter];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:kSectionCategoryItems];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [itemsArray addObjectsFromArray:newItems];
            break;
        }
        
        case kSectionEmotions: {
            itemsArray = [sections objectAtIndex:kSectionEmotionItems];
            NSArray *newItems = [[Installation currentInstallation] sortedFilterByGroup:kFilterGroupEmotion];
            for (CDFilter *filter in newItems) {
                int row = [newItems indexOfObject:filter];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:kSectionEmotionItems];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [itemsArray addObjectsFromArray:newItems];
            break;
        }
            
        case kSectionProfile: {
            itemsArray = [sections objectAtIndex:kSectionProfileItems];
            NSArray *newItems = [[Installation currentInstallation] sortedProfiles];
            for (CDProfile *profile in newItems) {
                int row = [newItems indexOfObject:profile];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:kSectionProfileItems];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [itemsArray addObjectsFromArray:newItems];
            break;
        }
    }
    
    isExpanded = YES;
    expandedSection = [section intValue];
    [self.mapViewDelegate growTable];
    
    [self.tableView endUpdates];
}

@end

#pragma mark - Prototype cells
@implementation MenuEmotionCell
@end
@implementation MenuEmotionItemCell
@end
@implementation MenuCategoryCell
@end
@implementation MenuCategoryItemCell
@end
@implementation MenuProfileCell
@end
@implementation MenuProfileItemCell
@end
@implementation MenuEmptyCell
@end