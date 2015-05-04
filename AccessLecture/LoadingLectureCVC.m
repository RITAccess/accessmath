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

- (void)loadLecturePreview:(NSString *)path
{
    NSString *imagePath = [path stringByAppendingPathComponent:@"thumb.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:[imagePath stringByExpandingTildeInPath]];
    [UIView animateWithDuration:0.5 animations:^{
        self.progress.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.progress removeFromSuperview];
        UIImageView *img = [[UIImageView alloc] initWithImage:image];
        [img setFrame:self.bounds];
        [self addSubview:img];
        [self setNeedsDisplay];
    }];
}

//- (void)drawRect:(CGRect)rect
//{
//    
//}

- (void)prepareForReuse
{
    // TODO Check for cached values
}

@end
