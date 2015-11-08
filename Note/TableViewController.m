//
//  TableViewController.m
//  Note
//
//  Created by Admin on 11/6/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "TableViewController.h"
#import "DBManager.h"

@interface TableViewController ()
@property (nonatomic) NSMutableArray <Note *> *arrayNotes;
@property (weak, nonatomic) UILabel *noNotesLabel;
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
    return self.arrayNotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Note *notes = (Note *)[self.arrayNotes objectAtIndex:indexPath.section];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = notes.text;
    label.numberOfLines = 0;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // Create View
    CGRect viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20);
    UIView *view = [[UIView alloc] initWithFrame:viewFrame];
    view.backgroundColor = [UIColor whiteColor];
    
    // Create Label
    CGRect labelFrame = CGRectMake(25, 5, CGRectGetWidth(self.view.frame), 20);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [view addSubview:label];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];

    Note *note = self.arrayNotes[section];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"dd MMM yyyy, hh:mm"];
    NSString *dateString = [DateFormatter stringFromDate:note.time];
    
    label.text = dateString;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *note = self.arrayNotes[indexPath.section];
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editNotes"]) {
        Note *note = [_arrayNotes objectAtIndex:[[self.tableView indexPathForSelectedRow]section]];
        ViewController *editText = (ViewController *)segue.destinationViewController;
        editText.note = note;
    }
}


@end
