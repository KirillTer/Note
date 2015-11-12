//
//  TableViewController.m
//  Note
//
//  Created by Admin on 11/6/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "TableViewController.h"
#import "DBManager.h"
#import "NoteTableViewCell.h"

@interface TableViewController ()
@property (nonatomic) NSMutableArray <Note *> *arrayNotes;
@property (weak, nonatomic) UILabel *noNotesLabel;

@property (strong,nonatomic) NSMutableArray *searchResultArray;
@property (weak, nonatomic) IBOutlet UISearchBar *noteSearchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *noteSearchDisplayController;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Easy Note";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //search
    self.searchResultArray = [NSMutableArray arrayWithCapacity:[self.arrayNotes count]];
    
//    [self.tableView registerClass:[NoteTableViewCell class] forCellReuseIdentifier:@"NoteCell"];
//    static NSString *reuseIdentifier = @"NoteCell";
//    [self.noteSearchDisplayController.searchResultsTableView registerClass:[NoteTableViewCell class] forCellReuseIdentifier:@"NoteCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NoteTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoteCell"];
    [self.noteSearchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"NoteTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoteCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.arrayNotes = [[[DBManager sharedInstance] fetchEntities:@"Note"] mutableCopy];
    if ([self isEmpty]) {
        CGRect viewFrame = self.view.frame;
        CGRect labelFrame = CGRectMake(20, CGRectGetHeight(viewFrame)/2 - 25, CGRectGetWidth(viewFrame) - 40, 50);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [self.view addSubview:label];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];
        label.text = @"No Notes! Let create new now. Touch + on the top right corner";
        self.noNotesLabel = label;
    } else {
        [self.noNotesLabel removeFromSuperview];
        [self.tableView reloadData];
    }
}

- (BOOL)isEmpty
{
    return self.arrayNotes.count == 0;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResultArray.count;
    } else {
        return self.arrayNotes.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell"
                                                            forIndexPath:indexPath];
   
    Note *note;
    // Check to see whether the normal table or search results table is being displayed and set object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        note = [self.searchResultArray objectAtIndex:indexPath.section];
    } else {
        note = (Note *)[self.arrayNotes objectAtIndex:indexPath.section];
    }
    cell.descriptionLabel.text = note.text;
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"dd MMM yyyy, hh:mm"];
    NSString *dateString = [DateFormatter stringFromDate:note.time];
    
    cell.titleLabel.text = dateString;
    cell.descriptionLabel.numberOfLines = 0;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
//Remove rows

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[DBManager sharedInstance] removeObject:[_arrayNotes objectAtIndex:indexPath.section]];
        [[DBManager sharedInstance] saveContext];
    }
    [self.arrayNotes removeObjectAtIndex:indexPath.section];
    NSIndexSet *sections = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(indexPath.section, 1)];
    [self.tableView deleteSections:sections withRowAnimation:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *note;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        note = [self.searchResultArray objectAtIndex:indexPath.row];
    } else {
        note = (Note *)[self.arrayNotes objectAtIndex:indexPath.section];
    }
    
    NSString *text = note.text;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]
                                 };
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.frame), CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return CGRectGetHeight(rect) + 50;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Note *note = self.arrayNotes[indexPath.section];
    ViewController *editViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NoteViewController"];
    editViewController.note = note;
    [self.navigationController pushViewController:editViewController animated:YES];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.searchResultArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.text contains[c] %@",searchText];
    self.searchResultArray = [NSMutableArray arrayWithArray:[self.arrayNotes filteredArrayUsingPredicate:predicate]];
}
#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    NSArray *titles = [self.searchDisplayController.searchBar scopeButtonTitles];
    NSInteger index = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    [self filterContentForSearchText:searchString
                               scope:titles[index]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
@end
