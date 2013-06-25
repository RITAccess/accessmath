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
@synthesize directories;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    NSURL *currentDirectory = [FileManager accessMathDirectoryURL];
    NSArray * docs = [FileManager documentsIn:currentDirectory];
    directories = [[NSMutableArray alloc] initWithArray:docs];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    NSURL *currentDirectory = [FileManager accessMathDirectoryURL];
    NSArray * docs = [FileManager documentsIn:currentDirectory];
    directories = [[NSMutableArray alloc] initWithArray:docs];
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
    return [directories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    LectureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.label.text=[[[directories objectAtIndex:[indexPath row]] path] lastPathComponent];
    // Configure the cell...
    [cell.image setImage:[UIImage imageNamed:@"biology.png"]];
    [cell.label setFont:[UIFont systemFontOfSize:38]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
        if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[[InventoryStore shared]->inventories removeObjectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
          [[NSFileManager defaultManager] removeItemAtURL:[directories objectAtIndex:indexPath.row] error:nil];
            
        });
       
        }
   // [[InventoryStore shared] removeInventory:inventoryToDelete];
  
    [tableView reloadData];

   
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
        controller.documentURL = [directories objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    dispatch_async(dispatch_get_main_queue(), ^{
                        [[AccessLectureRuntime defaultRuntime] openDocument:controller.documentURL];
        
                    });
                   

}
}

@end
