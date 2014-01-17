//
//  ImageNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/15/14.
//
//

#import "NoteTakingViewController.h"
#import "ImageNoteViewController.h"

CGPoint CGRectCenterPointInSuperview(CGRect rect) {
    return CGPointMake((rect.size.width / 2.0) + rect.origin.x,
                       (rect.size.height / 2.0) + rect.origin.y);
}

@implementation ImageNoteViewController
{
    UIPanGestureRecognizer *scale;
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
        [self layoutViewFromDisk:NO];
    }
    return self;
}

#pragma mark Secure Coding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [ImageNoteViewController new];
    if (self) {
        _noteTitle = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"note-title"];
        _noteContent = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"note-content"];
        self.view.frame = [aDecoder decodeCGRectForKey:@"note-frame"];
        [self layoutViewFromDisk:YES];
        
        // Add title and content, need to encode refereance to image here to. see
        // NSFileWrapper for this.
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:(_noteTitle ?: @"Untitled") forKey:@"note-title"];
    [aCoder encodeObject:(_noteContent ?: @"") forKey:@"note-content"];
    [aCoder encodeCGRect:self.view.frame forKey:@"note-frame"];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark Setup

- (void)layoutViewFromDisk:(BOOL)loadedFromDisk
{
    self.view.backgroundColor = [UIColor clearColor];
    ImageNoteView *view = (ImageNoteView *)self.view;
    [self imageView:view didFinishResizing:loadedFromDisk];
    view.delegate = self;
}

- (void)viewDidLoad
{
    // Load the GR that will be used to resize the view. This should only be done
    // when creating the note for the first time.
    scale = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sizeView:)];
    [scale setMinimumNumberOfTouches:1];
    [scale setMaximumNumberOfTouches:1];
    [scale setDelaysTouchesBegan:NO];
    [self.view addGestureRecognizer:scale];
}

#pragma mark View Delegate

- (void)imageView:(ImageNoteView *)imageView didFinishResizing:(BOOL)finish
{
    if (finish) {
        [imageView removeGestureRecognizer:scale];
        [imageView setResize:NO];
    } else {
        [imageView setResize:YES];
    }
}

#pragma mark Resizing

#define EDGE_BUFFER 44

/**
 * Handles the gesture recognizer put on to handle dragging from corners and
 * resizing. Once the resizing is complete the gesture will be removed and the
 * image will be captured. Corner is set to determin the resize corner. If all
 * are set the view will move.
 */
- (void)sizeView:(UIPanGestureRecognizer *)reg
{
    switch (reg.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint touch = [reg locationInView:self.view.superview];
            ImageNoteView *view = (ImageNoteView *)self.view;
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
            } else if (CGRectContainsPoint(view.moveArea, [reg locationInView:view])) {
                corner = (CITopLeft & CITopRight & CIBottomLeft & CIBottonRight);
                originalFrame = self.view.frame;
            } else {
                reg.enabled = NO;
                reg.enabled = YES;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            ImageNoteView *view = (ImageNoteView *)self.view;
            if ((corner == CITopLeft) || (corner == CITopRight) || (corner == CIBottomLeft) || (corner == CIBottonRight)) {
                [view resizingViewWithTranslation:[reg translationInView:self.view.superview] withCorner:corner ofFrame:originalFrame];
            } else if (corner == (CITopLeft & CITopRight & CIBottomLeft & CIBottonRight)) {
                [view translateView:[reg translationInView:self.view.superview] fromPoint:CGRectCenterPointInSuperview(originalFrame)];
            }
        } break;
        case UIGestureRecognizerStateEnded:
            [[(NoteTakingViewController *)self.parentViewController document] save];
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
