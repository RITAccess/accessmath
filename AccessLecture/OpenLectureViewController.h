//
//  OpenLectureViewController.h
//  AccessLecture
//
//  Created by Student on 6/17/13.
//
//

#import <UIKit/UIKit.h>

@interface OpenLectureViewController : UITableViewController<UIGestureRecognizerDelegate>

- (IBAction)returnToHome:(id)sender;
@property(nonatomic)NSMutableArray *directories;
@end
