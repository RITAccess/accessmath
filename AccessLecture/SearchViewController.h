//
//  SearchViewController.h
//  AccessLecture
//
//  Created by Michael on 4/15/14.
//
//

#import <UIKit/UIKit.h>
#import "AMLecture.h"

@interface SearchViewController : UISplitViewController

- (void)tableViewCell:(UITableViewCell *)cell becameActivePanel:(BOOL)active;

@property AMLecture *selectedLecture;

@end
