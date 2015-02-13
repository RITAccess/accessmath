//
//  PreviewViewController.h
//  AccessLecture
//
//  Created by Michael Timbrook on 2/6/15.
//
//

#import <UIKit/UIKit.h>
#import "AMLecture.h"

@interface PreviewViewController : UIViewController <UICollectionViewDataSource, UIBarPositioningDelegate>

@property (nonatomic) AMLecture *selectedLecture;

@end
