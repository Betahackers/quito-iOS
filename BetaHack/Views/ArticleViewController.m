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
    kSectionHeader
} TableSections;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    sections = [NSMutableArray array];
    [self reloadTable];
}

- (void)reloadTable {
    
    sections = [NSMutableArray array];
    
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
            
            //header
            static NSString *CellIdentifier = @"ArticleHeaderCell";
            ArticleHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            
            cell.article = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.titleLabel.text = cell.article.title;
            [cell.authorButton setTitle:cell.article.profile.name forState:UIControlStateNormal];
            
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

- (IBAction)profileTapped:(id)sender {
    [self.delegate showProfile:self.article.profile];
}

@end