//
//  ArticleViewController.m
//  Phontact
//
//  Created by Duncan Campbell on 04/12/13.
//  Copyright (c) 2013 Article Software S.L. All rights reserved.
//

#import "ArticleViewController.h"
//#import "DomainManager.h"

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
    
    [sections addObject:[NSArray arrayWithObject:@"First row"]];
    
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"articleCard_push_editCard"]) {
//        CDCard *cardToEdit = (CDCard*)sender;
//        EditCardViewController *viewController = (EditCardViewController *)segue.destinationViewController;
//        viewController.sourceViewController = self;
//        [viewController editCard:cardToEdit];
//    }
}

#pragma mark - ArticleCardCellDelegate


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