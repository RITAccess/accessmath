//
//  PreviewViewController.h
//  AccessLecture
//
//  Created by Michael Timbrook on 2/6/15.
//
//

#import <UIKit/UIKit.h>
#import "AMLecture.h"


@protocol CreateAndPresentLecture <NSObject>
@required
- (void)goToNewLecture:(AMLecture *)lecture;
@end

@interface PreviewViewController : UIViewController <UICollectionViewDataSource, UIBarPositioningDelegate>
{
    id<CreateAndPresentLecture> _delegate;  // delegate to respond back
}
@property(nonatomic, strong) id delegate;

- (void)dismissPreviewAndGoToLecture;

@property (nonatomic) AMLecture *selectedLecture;

@end
