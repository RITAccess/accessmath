//
//  ImageNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/15/14.
//
//

#define USING_TEST_SERVER 0

#import <NoticeView/WBErrorNoticeView.h>

#import "UIImage+Rotate.h"

#import "NoteTakingViewController.h"
#import "ImageNoteViewController.h"
#import "NSString+asciihexcodes.h"
#import "XMLReader.h"

NSString *const INVScreenShotNotification = @"INVScreenShotNotification";

CGPoint CGRectCenterPointInSuperview(CGRect rect) {
    return CGPointMake((rect.size.width / 2.0) + rect.origin.x,
                       (rect.size.height / 2.0) + rect.origin.y);
}

@interface ImageNoteViewController ()

@property (strong) UIButton *caputureButton;

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

    // Register for screenshot notifications to remove extra UI elements
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:INVScreenShotNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        BOOL active = [note.object boolValue];
        NSLog(@"%@", active ? @"Yes" : @"No");
        self.view.hidden = active;
    }];

}

#pragma mark View Actions

- (void)addCaptureButton
{
     _caputureButton = ({
         UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
         [b setTitle:@"Capture" forState:UIControlStateNormal];
         b.frame = CGRectMake(50, 50, 100, 50);
         [self.view addSubview:b];
         [self.view bringSubviewToFront:b];
         // Contraints
         NSDictionary *views = NSDictionaryOfVariableBindings(b);
         NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[b]-|" options:0 metrics:nil views:views];
         constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[b]-|" options:0 metrics:nil views:views]];
         [self.view addConstraints:constraints];
         // Outlets
         [b addTarget:self action:@selector(captureNoteAreaAction:) forControlEvents:UIControlEventTouchUpInside];
         b;
    });
    
}

- (void)captureNoteAreaAction:(id)sender
{
    UIImage *screenShot = [self captureNoteArea];
    NSURLRequest *request = [self requestWithImage:screenShot];
    [self sendSyncCallToServerWithRequest:request];
}

#pragma mark Image Capture

/**
 *  Capture the screen area on the superview this note is drawn on
 *
 *  @return captured area of the note
 */
- (UIImage *)captureNoteArea
{
    // Notify to remove unessisary UI elements
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:INVScreenShotNotification object:@YES];

    // Capture Screen Area
    UIWindow *mainWindow = [UIApplication sharedApplication].windows.firstObject;
    UIGraphicsBeginImageContext(mainWindow.bounds.size);
    [mainWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *shot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGFloat rotate;
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            rotate = 0.0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            rotate = 180.0;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotate = 90.0;
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotate = 270.0;
            break;
        default:
            break;
    }
    shot = [shot imageRotatedByDegrees:rotate];

    CGRect crop = CGRectZero;
    CGRect image = [(ImageNoteView*)self.view imageArea];
    crop.origin = self.view.frame.origin;
    crop.origin.x += image.origin.x;
    crop.origin.y += image.origin.y;
    crop.size = image.size;
    
    CGImageRef imgref = CGImageCreateWithImageInRect(shot.CGImage, crop);
    shot = [UIImage imageWithCGImage:imgref];
    CGImageRelease(imgref);

    // Screenshot done
    [center postNotificationName:INVScreenShotNotification object:@NO];

    return shot;
}

#pragma mark Image Requests

/**
 *  Send a network request to process an image
 *
 *  @param request Image request
 */
- (void)sendSyncCallToServerWithRequest:(NSURLRequest *)request
{
    static NSOperationQueue *imageLoad;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageLoad = [NSOperationQueue new];
    });
    
    [NSURLConnection sendAsynchronousRequest:request queue:imageLoad completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // Do processing
        NSMutableString *textResponse = [NSMutableString new];
        NSError *error;
        if (response) {
            NSDictionary *responseValues = [XMLReader dictionaryForXMLData:data error:&error];
            if (error) goto finish;
            for (id symbol in [responseValues valueForKeyPath:@"AllResults.RecognitionResults"]) {
#if USING_TEST_SERVER
                [textResponse appendString:[[symbol valueForKeyPath:@"Result.symbol"] stringValue]];
                NSLog(@"%@", [symbol valueForKeyPath:@"Result.symbol"]);
#else
                [textResponse appendString:[NSString stringWithASCIIHexCode:[symbol valueForKeyPath:@"Result.symbol"]]];
#endif
            }
        } else {
            NSLog(@"Connection Error: %@", connectionError.localizedDescription);
        }
finish:
        dispatch_sync(dispatch_get_main_queue(), ^{
            // Send UI updates;
            if (connectionError) {
                WBErrorNoticeView *error = [WBErrorNoticeView errorNoticeInView:self.view.superview.superview
                                                                          title:connectionError.localizedDescription
                                                                        message:@"This sounds like an error on our end and not yours. We're sorry about that."];
                error.delay = error.message.length / 8.0;
                [error show];
            } else {

            }
        });
    }];
}

/**
 *  Creates a NSURLRequest that contains the image to send to the seach service
 *  encoded in the way the server defines it.
 *
 *  @param image Image to encode
 *
 *  @return Request with the encoded image datas
 */
- (NSURLRequest *)requestWithImage:(UIImage *)image
{
    ////////////////////////////////////////////////////////////////////////////
    //
    //  Url Request Protocol
    //  query items:
    //      segmentList:
    //          a list of xml items with type instanceID and image (base64)
    //      segment
    //          always false
    //
    //  This is is conformace to the site that is doing the image processing
    //
    ////////////////////////////////////////////////////////////////////////////
    
    NSURLComponents *url = [NSURLComponents componentsWithString:@"http://129.21.34.109/"];
    url.port = @7006;
    
#if USING_TEST_SERVER
    url.host = @"claira.student.rit.edu";
    url.port = @8080;
#endif
    
    NSString *segFormat =  @"<Segment "
                                @"type='image_blob' "
                                @"instanceID='%d' "
                                @"image='data:image/png;base64,%@'/>";
    NSString *segment = [NSString stringWithFormat:segFormat, 1, [UIImagePNGRepresentation(image) base64Encoding]];
    NSString *segmentList = [NSString stringWithFormat:@"<SegmentList>%@</SegmentList>", segment];
    NSString *query = [NSString stringWithFormat:@"segmentList=%@&segment=false", segmentList];
    url.query = query;
    NSURLRequest *request = [NSURLRequest requestWithURL:url.URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];
    
    return request;
}

#pragma mark View Delegate

- (void)imageView:(ImageNoteView *)imageView didFinishResizing:(BOOL)finish
{
    if (finish) {
        [imageView removeGestureRecognizer:scale];
        [self addCaptureButton];
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

@end
