//
//  LoadingLectureCVC.m
//  AccessLecture
//
//  Created by Michael Timbrook on 2/2/15.
//
//

#import "LoadingLectureCVC.h"
#import "PureLayout.h"
#import "AccessLectureKit.h"

@implementation LoadingLectureCVC
{
    BOOL _loadFailed;
}

-(void)awakeFromNib
{
    self.progress = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyle9CubeGrid];
    self.progress.color = [AccessLectureKit accessBlue];
    self.progress.spinnerSize = 80.0;
    [self.contentView addSubview:self.progress];
    [self.progress autoCenterInSuperview];
}

- (void)loadLecturePreview:(NSString *)name
{
    // TODO load in preview from lecture
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.progress.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.progress removeFromSuperview];
            _loadFailed = YES;
            [self setNeedsDisplay];
        }];
    });
}

- (void)drawRect:(CGRect)rect
{
    if (_loadFailed) {
        [AccessLectureKit drawLectureNoInfoWithFrame:rect];
    }
}

- (void)prepareForReuse
{
    // TODO Check for cached values
}

@end
