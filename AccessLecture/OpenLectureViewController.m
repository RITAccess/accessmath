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
#import "LectureViewController.h"

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
    NSURL *currentDirectory = [FileManager accessMathDirectoryURL];
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
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Use a segue to forward the changes from itemViewController to inventoryViewController
    if([segue.identifier isEqualToString:@"Lecture"])
    {
        LectureViewController *controller = [segue destinationViewController];
        controller.isOpened = YES;
        controller.documentURL = [diectories objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        NSOperation *operation;
        
        operation = [NSBlockOperation blockOperationWithBlock:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AccessLectureRuntime defaultRuntime] openDocument:controller.documentURL];
                
            });
            }];
        NSOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"Starting second");
                                

        }];
       
        [queue addOperation:operation];
        [queue addOperation:completionOperation];
        
    }
   
}

@end
