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
    _drawView = [[DrawView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_drawView];
    [self.view addSubview:self.toolbarView];
    [self initColorSegmentedControl];
    
    _buttonStrings = [[NSMutableArray alloc] initWithObjects:@"star.png", @"arrow.png", @"undo.png", @"circle.png", nil];
    
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
    } else {
        [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    }
    
    // Clear view
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidUnload
{
    [self setPenSizeSlider:nil];
    [self setShapeButton:nil];
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
    
    [_drawView setFrame:CGRectMake(0, 0, CGRectGetWidth(_drawView.frame), CGRectGetHeight(_drawView.frame))];
    [_drawView setTransform:CGAffineTransformIdentity]; // Resets the view to state before transformation.
    
    [[_drawView shapes] removeAllObjects];
    [[_drawView paths] removeAllObjects];
    [_drawView setNeedsDisplay];
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
    shapeButtonIndex >= SHAPE_MAX - 1 ? shapeButtonIndex = 0 : shapeButtonIndex++;
    
    [[_drawView buttonString] setString:[_buttonStrings objectAtIndex:shapeButtonIndex]];
    [[_drawView tapStamp] setEnabled:YES];
    [[_drawView fingerDrag] setEnabled:NO];
    
    [self.shapeButton setBackgroundImage:[UIImage imageNamed:[_drawView buttonString]] forState:UIControlStateNormal];
}
    
#pragma mark Child View Controller Calls

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"will have new parent %@", parent);
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"new parent %@", parent);
    [self.toolbarView setHidden:NO];
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
    [self.toolbarView setHidden:YES];
}

- (UIView *)contentView
{
    return _drawView;
}

@end
