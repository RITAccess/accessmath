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
#define COLOR_HEIGHT 80

@interface DrawViewController ()

@end

@implementation DrawViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initColorSegmentedControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initColorSegmentedControl
{
    NSArray *segments = [[NSArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"Eraser", nil];
    _colorSegmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    [_colorSegmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait){
        [_colorSegmentedControl setFrame:CGRectMake(0, self.view.frame.size.height - COLOR_HEIGHT, 768, COLOR_HEIGHT)];
    } else {
        [_colorSegmentedControl setFrame:CGRectMake(0, self.view.frame.size.width - COLOR_HEIGHT, 1024, COLOR_HEIGHT)];
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
    
//    [self.view addSubview:_colorSegmentedControl];
}

#pragma mark - Rotation Handling

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        
//        if (lineDrawView){
//            lineDrawView.frame = CGRectMake(0, 180, IPAD_MINI_HEIGHT, 450);
//        }
        
        if (_colorSegmentedControl){
            [_colorSegmentedControl setFrame:CGRectMake(0, self.view.frame.size.width - COLOR_HEIGHT, 1024, COLOR_HEIGHT)];
        }
        
//        if (scrollView){
//            scrollView.frame = CGRectMake(0, 180, IPAD_MINI_HEIGHT, 450);
//        }
    } else if (self.interfaceOrientation == UIInterfaceOrientationPortrait){
        
        if (_colorSegmentedControl){
            [_colorSegmentedControl setFrame:CGRectMake(0, 927, 768, COLOR_HEIGHT)];
        }
        
//        if (scrollView){
//            scrollView.frame = CGRectMake(0, 180, IPAD_MINI_HEIGHT, 710); // Extending ScrollView past LineDrawView height
//        }
    }
}

- (void)viewDidUnload {
    [self setToolbarView:nil];
    [super viewDidUnload];
}
@end
