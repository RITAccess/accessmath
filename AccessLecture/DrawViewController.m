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

    _drawView = [[DrawView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.toolbarView.frame.size.height)];
    
    _panGestureRecognzier = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panToMove:)];
    _panGestureRecognzier.maximumNumberOfTouches = 2;
    [_panGestureRecognzier setTranslation:CGPointMake(40, 40) inView:_drawView];
    [_drawView addGestureRecognizer:_panGestureRecognzier];
    
    [self.view addSubview:_drawView];
    [self initColorSegmentedControl];
}

- (void)viewDidUnload {
    [self setToolbarView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - Rotation Handling

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [_colorSegmentedControl setFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width - 200, COLOR_HEIGHT)];
    } else if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        [_colorSegmentedControl setFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width - 200, COLOR_HEIGHT)];
    }
}

# pragma  mark - Gestures

- (void)panToMove:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        NSLog(@"Panning...");
        
        CGPoint translation = [gesture translationInView:self.view];
        _drawView.center = CGPointMake(_drawView.center.x + translation.x,
                                          _drawView.center.y + translation.y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

# pragma mark - Color Methods

- (void)initColorSegmentedControl
{
    NSArray *segments = [[NSArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"Eraser", nil];
    _colorSegmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    [_colorSegmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait){
        [_colorSegmentedControl setFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width - 200, COLOR_HEIGHT)];
    } else {
        [_colorSegmentedControl setFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width - 200, COLOR_HEIGHT)];
    }
    
    [_colorSegmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Indices change; need to set tags on the segments before rendering.
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
    _panGestureRecognzier.enabled = NO;
    
    NSLog(@"Segment changed...");
    _selectedColor = [_colorSegmentedControl selectedSegmentIndex];
    
    switch (_selectedColor) {
        case 0:
            _drawView.selectedPath = _drawView.redBezierPath;
            break;
        case 1:
            _drawView.selectedPath = _drawView.greenBezierPath;
            break;
        case 2:
            _drawView.selectedPath = _drawView.blueBezierPath;
            break;
        case 3:
            _drawView.selectedPath = _drawView.blackBezierPath;
            break;
        case 4:
            _drawView.selectedPath = _drawView.yellowBezierPath;
            break;
        default:
            break;
    }
}

@end
