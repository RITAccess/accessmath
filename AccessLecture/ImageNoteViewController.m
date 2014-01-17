//
//  ImageNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/15/14.
//
//

#import "NoteTakingViewController.h"
#import "ImageNoteViewController.h"
#import "ImageNoteView.h"

@interface ImageNoteViewController ()

@end

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
        [self layoutView];
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
        [self layoutView];
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

- (void)layoutView
{
    self.view.backgroundColor = [UIColor clearColor];
    ImageNoteView *view = (ImageNoteView *)self.view;
    #pragma unused(view)
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

#pragma mark Actions

- (IBAction)doneButton:(id)sender
{
    NSLog(@"Done Button");
}

#pragma mark Resizing

#define EDGE_BUFFER 44

/**
 * Handles the gesture recognizer put on to handle dragging from corners and
 * resizing. Once the resizing is complete the gesture will be removed and the
 * image will be captured.
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
            } else if (CGRectContainsPoint(view.moveArea, touch)) {
                NSLog(@"Move");
            } else {
                reg.enabled = NO;
                reg.enabled = YES;
            }
        } break;
        case UIGestureRecognizerStateChanged:
            if (corner) {
                [(ImageNoteView *)self.view resizingViewWithTranslation:[reg translationInView:self.view.superview] withCorner:corner ofFrame:originalFrame];
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            corner = nil;
            [[(NoteTakingViewController *)self.parentViewController document] save];
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
