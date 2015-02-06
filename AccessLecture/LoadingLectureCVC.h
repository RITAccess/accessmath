//
//  LoadingLectureCVC.h
//  AccessLecture
//
//  Created by Michael Timbrook on 2/2/15.
//
//

#import <UIKit/UIKit.h>
#import <SpinKit/RTSpinKitView.h>

@interface LoadingLectureCVC : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) RTSpinKitView *progress;

- (void)loadLecturePreview:(NSString *)name;

@end
