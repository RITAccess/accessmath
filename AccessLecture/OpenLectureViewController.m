//
//  OpenLectureViewController.m
//  AccessLecture
//
//  Created by Student on 6/17/13.
//
//

#import "OpenLectureViewController.h"
#import "LectureCell.h"
#import "FileManager.h"
@interface OpenLectureViewController ()

@end

@implementation OpenLectureViewController
@synthesize diectories;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSURL *currentDirectory = [FileManager localDocumentsDirectoryURL];
    NSArray * docs = [FileManager documentsIn:currentDirectory];
    diectories = [[NSMutableArray alloc] initWithArray:docs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [diectories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    LectureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.label.text=[[[diectories objectAtIndex:[indexPath row]] path] lastPathComponent];
    // Configure the cell...
    [cell.image setImage:[UIImage imageNamed:@"biology.png"]];
    [cell.label setFont:[UIFont systemFontOfSize:38]];
    return cell;
}


- (IBAction)returnToHome:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
