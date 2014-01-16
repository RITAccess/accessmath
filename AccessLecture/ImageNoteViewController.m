//
//  ImageNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/15/14.
//
//

#import "ImageNoteViewController.h"

typedef enum CornerIdenifier : NSUInteger {
    CITopLeft = 1 << 0,
    CITopRight = 1 << 1,
    CIBottomLeft = 1 << 2,
    CIBottonRight = 1 << 3
} CornerIdenifier;

@interface ImageNoteViewController ()

@end

@implementation ImageNoteViewController
{
    CornerIdenifier corner;
    CGRect originalFrame;
}

- (id)initWithPoint:(CGPoint)point
{
    self = [super initWithNibName:@"ImageNoteViewController" bundle:nil];
    if (self) {
        // Custom initialization
        CGRect frame = CGRectMake(0, 0, 200, 200);
        self.view.frame = frame;
        self.view.center = point;
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    UIPanGestureRecognizer *scale = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sizeView:)];
    [scale setMinimumNumberOfTouches:1];
    [scale setMaximumNumberOfTouches:1];
    [scale setDelaysTouchesBegan:NO];
    [self.view addGestureRecognizer:scale];
}

- (void)resizingViewWithTranslation:(CGPoint)translation withCorner:(CornerIdenifier)cornerID
{
    if (cornerID == CIBottonRight) {
        self.view.frame = ({
            CGRect frame = originalFrame;
            frame.size.height += translation.y;
            frame.size.width += translation.x;
            frame;
        });
    } else if (cornerID == CITopLeft) {
        self.view.frame = ({
            CGRect frame = originalFrame;
            frame.size.height -= translation.y;
            frame.size.width -= translation.x;
            frame.origin.x += translation.x;
            frame.origin.y += translation.y;
            frame;
        });
    } else if (cornerID == CITopRight) {
        self.view.frame = ({
            CGRect frame = originalFrame;
            frame.size.height -= translation.y;
            frame.size.width += translation.x;
            frame.origin.y += translation.y;
            frame;
        });
    }else if (cornerID == CIBottomLeft) {
        self.view.frame = ({
            CGRect frame = originalFrame;
            frame.size.height += translation.y;
            frame.size.width -= translation.x;
            frame.origin.x += translation.x;
            frame;
        });
    }
    [self.view setNeedsDisplay];
}

#define EDGE_BUFFER 44

- (void)sizeView:(UIPanGestureRecognizer *)reg
{
    switch (reg.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint touch = [reg locationInView:self.view.superview];
            // Check to see if start is within 15 points of the edge
            if (CGRectContainsPoint(self.view.frame, touch) &&
                !CGRectContainsPoint(CGRectInset(self.view.frame, EDGE_BUFFER, EDGE_BUFFER), touch)) {
                // Check and ID corner
                touch = [reg locationInView:self.view];
                CGRect tl = CGRectMake(0, 0, EDGE_BUFFER, EDGE_BUFFER);
                CGRect tr = CGRectMake(self.view.frame.size.width - EDGE_BUFFER, 0, EDGE_BUFFER, EDGE_BUFFER);
                CGRect ll = CGRectMake(0, self.view.frame.size.height - EDGE_BUFFER, EDGE_BUFFER, EDGE_BUFFER);
                CGRect lr = CGRectMake(tr.origin.x, ll.origin.y, EDGE_BUFFER, EDGE_BUFFER);
                if (CGRectContainsPoint(tl, touch)) {
                    corner = CITopLeft;
                } else if (CGRectContainsPoint(tr, touch)) {
                    corner = CITopRight;
                } else if (CGRectContainsPoint(ll, touch)) {
                    corner = CIBottomLeft;
                } else if (CGRectContainsPoint(lr, touch)) {
                    corner = CIBottonRight;
                }
                originalFrame = self.view.frame;
            } else {
                reg.enabled = NO;
                reg.enabled = YES;
            }
        } break;
        case UIGestureRecognizerStateChanged:
            if (corner) {
                [self resizingViewWithTranslation:[reg translationInView:self.view.superview] withCorner:corner];
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            corner = nil;
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
