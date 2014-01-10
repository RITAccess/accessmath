//
//  FileMangerViewController.h
//  AccessLecture
//
//  Created by Michael on 1/9/14.
//
//

#import <UIKit/UIKit.h>

@interface FileMangerViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (void)loadDocument:(NSString *)docName;

@end
