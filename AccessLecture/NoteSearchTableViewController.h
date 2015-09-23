//
//  NoteSearchTableViewController.h
//  AccessLecture
//
//  Created by Piper on 9/14/15.
//
//

#import <UIKit/UIKit.h>

@interface NoteSearchTableViewController : UITableViewController<UISearchBarDelegate, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *noteSearchBar;

@property NSArray* searchedNotes;
@property NSMutableArray* filteredSearchNotes;

@end
