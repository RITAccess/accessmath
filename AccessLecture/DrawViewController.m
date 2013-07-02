//
//  DrawViewController.m
//  AccessLecture
//
//  Created by Piper Chester on 6/26/13.
//
//

#import "DrawViewController.h"

#define RED_TAG 111
#define GREEN_TAG 112
#define BLUE_TAG 113
#define BLACK_TAG 114
#define HILIGHT_TAG 115
#define ERASER_TAG 116
#define COLOR_HEIGHT 85

@interface DrawViewController ()

@end

@implementation DrawViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Adding the Drawing and Toolbar Views
    _drawView = [[DrawView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 2, self.view.frame.size.height * 2)];
    [self.view addSubview:_drawView];
    [self.view addSubview:self.toolbarView];
    [self initColorSegmentedControl];
    
    // Adding Gestures (API still changing, keeping gesture until we solidify a decision)
//    _panGestureRecognzier = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panToMove:)];
//    _panGestureRecognzier.minimumNumberOfTouches = 2;
//    [_panGestureRecognzier setTranslation:CGPointMake(40, 40) inView:_drawView];
//   [_drawView addGestureRecognizer:_panGestureRecognzier];
}

- (void)viewDidUnload
{
    [self setPenSizeSlider:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - Rotation Handling

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_colorSegmentedControl setFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width - 400, COLOR_HEIGHT)];
}

# pragma  mark - Gestures

- (void)panToMove:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)){
        
        CGPoint translation = [gesture translationInView:self.view];        
        _drawView.center = CGPointMake(_drawView.center.x + translation.x, _drawView.center.y + translation.y);
        
        // Clamp Left and Top Sides of View
        if (_drawView.frame.origin.x > 0){
            _drawView.frame = CGRectMake(0, _drawView.frame.origin.y, _drawView.frame.size.width, _drawView.frame.size.height);
        }
        
        if (_drawView.frame.origin.y > 0){
            _drawView.frame = CGRectMake(_drawView.frame.origin.x, 0, _drawView.frame.size.width, _drawView.frame.size.height);
        }
        
        // Clamp Right and Bottom Sides of View
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
            if (_drawView.frame.origin.x < -500){
                _drawView.frame = CGRectMake(-500, _drawView.frame.origin.y, _drawView.frame.size.width, _drawView.frame.size.height);
            }
            
            if (_drawView.frame.origin.y < -1020){
                _drawView.frame = CGRectMake(_drawView.frame.origin.x, -1020, _drawView.frame.size.width, _drawView.frame.size.height);
            }
        } else if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
            if (_drawView.frame.origin.x < -765){
                _drawView.frame = CGRectMake(-765, _drawView.frame.origin.y, _drawView.frame.size.width, _drawView.frame.size.height);
            } 
            
            if (_drawView.frame.origin.y < -1020){
                _drawView.frame = CGRectMake(_drawView.frame.origin.x, -1020, _drawView.frame.size.width, _drawView.frame.size.height);
            }
        }
        
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

# pragma mark - Color Methods

- (void)initColorSegmentedControl
{
    NSArray *segments = [[NSArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", nil];
    _colorSegmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    [_colorSegmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_colorSegmentedControl setFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width - 400, COLOR_HEIGHT)];
    [_colorSegmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Indices change; need to tag the segments before rendering.
    [_colorSegmentedControl setTag:RED_TAG forSegmentAtIndex:0];
    [_colorSegmentedControl setTag:GREEN_TAG forSegmentAtIndex:1];
    [_colorSegmentedControl setTag:BLUE_TAG forSegmentAtIndex:2];
    [_colorSegmentedControl setTag:BLACK_TAG forSegmentAtIndex:3];
    [_colorSegmentedControl setTag:HILIGHT_TAG forSegmentAtIndex:4];
    [_colorSegmentedControl setTag:ERASER_TAG forSegmentAtIndex:5];
    
    [_colorSegmentedControl setTintColor:[UIColor redColor] forTag:RED_TAG];
    [_colorSegmentedControl setTintColor:[UIColor greenColor] forTag:GREEN_TAG];
    [_colorSegmentedControl setTintColor:[UIColor blueColor] forTag:BLUE_TAG];
    [_colorSegmentedControl setTintColor:[UIColor blackColor] forTag:BLACK_TAG];
    [_colorSegmentedControl setTintColor:[UIColor yellowColor] forTag:HILIGHT_TAG];
    [_colorSegmentedControl setTintColor:[UIColor whiteColor] forTag:ERASER_TAG];
    
    [self.toolbarView addSubview:_colorSegmentedControl];
    [self.view bringSubviewToFront:self.toolbarView];
}

/**
 * Called when the SegmentedControl is changed to a new color.
 */
- (void)segmentChanged:(id)sender
{
    [[_drawView tapStamp] setEnabled:NO]; // Disabling stamping during drawing.
    [[_drawView fingerDrag] setEnabled:YES];
    _selectedColor = [_colorSegmentedControl selectedSegmentIndex];
    
    switch (_selectedColor) {
        case 0:
            [_drawView setPenColor:[UIColor redColor]];
            break;
        case 1:
            [_drawView setPenColor:[UIColor greenColor]];
            break;
        case 2:
            [_drawView setPenColor:[UIColor blueColor]];
            break;
        case 3:
            [_drawView setPenColor:[UIColor blackColor]];
            break;
        case 4:
            [_drawView setPenColor:[UIColor yellowColor]];
            break;
        case 5:
            [_drawView setPenColor:[UIColor whiteColor]];
            break;
        default:
            break;
    }
}


#pragma mark - Buttons and Sliders

- (IBAction)clearNotesButtonPress:(id)sender
{
    for (NSObject *object in [_drawView shapes]){
        if ([object isMemberOfClass:[UIImageView class]]){
            [(UIView *)object removeFromSuperview];
        }
    }
    
    [[_drawView shapes] removeAllObjects];
    [[_drawView paths] removeAllObjects];
    [_drawView setNeedsDisplay]; // Calls DrawView's overriden drawRect() to update view.
}

- (IBAction)penSizeSlide:(id)sender
{
    [_drawView setPenSize:self.penSizeSlider.value];
    [_drawView setNeedsDisplay];
}

- (IBAction)undoButtonPress:(id)sender
{    
    if ([[[_drawView shapes] lastObject] isMemberOfClass:[UIImageView class]]){
         [[[_drawView shapes] lastObject] removeFromSuperview];
    } else if ([[[_drawView shapes] lastObject] isMemberOfClass:[AMBezierPath class]]){
        [[_drawView paths] removeLastObject]; // Removing AMBezierPaths...
    }
    
    [[_drawView shapes] removeLastObject];
    [_drawView setNeedsDisplay];
}

- (IBAction)shapeButtonPress:(id)sender
{
    [[_drawView tapStamp] setEnabled:YES];
    [[_drawView fingerDrag] setEnabled:NO];
}

#pragma mark Child View Controller Calls

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"will have new parent %@", parent);
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"new parent %@", parent);
    [self.view addSubview:self.toolbarView];
}

- (void)willSaveState
{
    NSLog(@"Will save state");
}

- (void)didSaveState
{
    NSLog(@"Did save state: %@", self.description);
}

- (void)willLeaveActiveState
{
    NSLog(@"Will leave active state");
}

- (void)didLeaveActiveState
{
    NSLog(@"Did leave active state: %@", self.description);
    [self.toolbarView removeFromSuperview];
}
@end
