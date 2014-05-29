//
//  ACEViewController.m
//  ACEDrawingViewDemo
//
//  Created by Stefano Acerbetti on 1/6/13.
//  Copyright (c) 2013 Stefano Acerbetti. All rights reserved.
//

#import "DrawViewController.h"
#import "ACEDrawingView.h"
#import <QuartzCore/QuartzCore.h>

#define kActionSheetColor       100
#define kActionSheetTool        101

static const CGFloat SliderPaddingFromNavbarInLandscape = 300;
static const CGFloat SliderPaddingFromNavbarInPortrait = 200;
static const CGFloat SliderPaddingFromSides = 100;

@interface DrawViewController ()<UIActionSheetDelegate, ACEDrawingViewDelegate>

@end

@implementation DrawViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    _drawingView.delegate = self;

    _lineWidthSlider.value = _drawingView.lineWidth;

    // Draw on clear canvas
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
    
    // Ensure toolbar is properly oriented
    [self positionToolbar:self.interfaceOrientation withAnimation:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self positionToolbar:self.interfaceOrientation withAnimation:NO];
}


#pragma mark - Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self positionToolbar:toInterfaceOrientation withAnimation:NO];
}

/**
 *  Grabs the screen width and height and positions the toolbar and sliders from it.
 *
 *  @param toInterfaceOrientation - the current orientation of the device
 *  @param isAnimating            - whether or not the positioning should be animated
 */
- (void)positionToolbar:(UIInterfaceOrientation)toInterfaceOrientation withAnimation:(BOOL)isAnimating
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width; // 1024 on Mini
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height; // 768 on Mini
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        _toolbar.frame = CGRectMake(0,
                                      screenHeight - _toolbar.frame.size.height,
                                      screenWidth,
                                      _toolbar.frame.size.height);
        
        _lineAlphaSlider.frame = CGRectMake(SliderPaddingFromSides,
                                              screenWidth - (_toolbar.frame.size.height + _lineAlphaSlider.frame.size.height - SliderPaddingFromNavbarInPortrait),
                                              screenWidth - (SliderPaddingFromSides * 2),
                                              _lineAlphaSlider.frame.size.height);
        
        _lineWidthSlider.frame = CGRectMake(SliderPaddingFromSides,
                                              screenWidth - (_toolbar.frame.size.height + _lineAlphaSlider.frame.size.height - SliderPaddingFromNavbarInPortrait),
                                              screenWidth - (SliderPaddingFromSides * 2),
                                              _lineAlphaSlider.frame.size.height);
    } else {
        _toolbar.frame = CGRectMake(0,
                                      screenWidth - _toolbar.frame.size.height,
                                      screenHeight,
                                      _toolbar.frame.size.height);
        
        _lineAlphaSlider.frame = CGRectMake(SliderPaddingFromSides,
                                              screenHeight - (_toolbar.frame.size.height + _lineAlphaSlider.frame.size.height + SliderPaddingFromNavbarInLandscape),
                                              screenHeight - (SliderPaddingFromSides * 2),
                                              _lineAlphaSlider.frame.size.height);
        
        _lineWidthSlider.frame = CGRectMake(SliderPaddingFromSides,
                                              screenHeight - (_toolbar.frame.size.height + _lineAlphaSlider.frame.size.height + SliderPaddingFromNavbarInLandscape),
                                              screenHeight - (SliderPaddingFromSides * 2),
                                              _lineAlphaSlider.frame.size.height);
    }
}
/**
 *  Show the toolbar, with or without animation.
 *
 *  @param isAnimating - whether to animate or not
 */
- (void)displayToolbarWithAnimation:(BOOL)isAnimating
{
    _toolbar.hidden = NO;
    if (isAnimating){
        [UIView animateWithDuration:.3
                              delay: 0
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                             _toolbar.alpha = 1;
                             _lineWidthSlider.alpha = 1;
                             _lineAlphaSlider.alpha = 1;
                         }
                         completion:nil
         ];
    }
}

/**
 *  Hide the toolbar, with or without animation.
 *
 *  @param isAnimating - whether to animate or not
 */
- (void)dismissToolbarWithAnimation:(BOOL)isAnimating
{
    if (isAnimating){
        [UIView animateWithDuration:.3
                              delay: 0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             _toolbar.alpha = 0;
                             _lineAlphaSlider.alpha = 0;
                             _lineWidthSlider.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             _toolbar.hidden = YES;
                             _lineWidthSlider.hidden = YES;
                             _lineAlphaSlider.hidden = YES;
                         }
         ];
    } else {
        _toolbar.hidden = YES;
    }
}

#pragma mark - Undo/Redo and Clear Actions

/**
 * If the pathArray and/or bufferArray are not empty, enable undo/redo
 */
- (void)updateUndoRedoButtonStatus
{
    _undoButton.enabled = [_drawingView canUndo];
    _redoButton.enabled = [_drawingView canRedo];
}

- (IBAction)undo:(id)sender
{
    [_drawingView undoLatestStep];
    [self updateUndoRedoButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [_drawingView redoLatestStep];
    [self updateUndoRedoButtonStatus];
}

- (IBAction)clear:(id)sender
{
    [_drawingView clear];
    [self updateUndoRedoButtonStatus];
}


#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateUndoRedoButtonStatus];
}


#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        if (actionSheet.tag == kActionSheetColor) {

            NSDictionary *colorDictionary = [[NSDictionary alloc] initWithObjects:@[[UIColor blackColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor], [UIColor purpleColor]]
                                                                          forKeys:@[@0, @1, @2, @3, @4, @5]];
            NSNumber *numberForColorDictionary = [NSNumber numberWithInteger:buttonIndex];

            _drawingView.lineColor = [colorDictionary objectForKey:numberForColorDictionary];
            _colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
        } else {
            _drawingView.drawTool = buttonIndex; // ToolType is an enum, can assign the buttonIndex directly

            _toolButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];

            // if eraser, disable color and alpha selection
            _colorButton.enabled = _alphaButton.enabled = buttonIndex != 6;
        }
    }
}

#pragma mark - ActionSheet Creation for Color and Tool Selection

- (IBAction)colorChange:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selet a color"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Black", @"Red", @"Green", @"Blue", @"Yellow", @"Purple", nil];

    [actionSheet setTag:kActionSheetColor];
    [actionSheet showInView:self.view];
}

- (IBAction)toolChange:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selet a tool"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Pen", @"Line",
                                  @"Rect (Stroke)", @"Rect (Fill)",
                                  @"Ellipse (Stroke)", @"Ellipse (Fill)",
                                  @"Eraser",
                                  nil];

    [actionSheet setTag:kActionSheetTool];
    [actionSheet showInView:self.view];
}

#pragma mark - Slider Visibility and Toggling

- (IBAction)toggleWidthSlider:(id)sender
{
    _lineWidthSlider.hidden = !_lineWidthSlider.hidden;
    _lineAlphaSlider.hidden = YES;
}


- (IBAction)widthChange:(UISlider *)sender
{
    _drawingView.lineWidth = sender.value;
}

- (IBAction)toggleAlphaSlider:(id)sender
{
    _lineAlphaSlider.hidden = !_lineAlphaSlider.hidden;
    _lineWidthSlider.hidden = YES;
}

- (IBAction)alphaChange:(UISlider *)sender
{
    _drawingView.lineAlpha = sender.value;
}

#pragma mark - LectureChildDelegate Protocol Methods

- (void)willMoveToParentViewController:(UIViewController *)parent
{

}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [_toolbar setHidden:NO];
}

- (void)willSaveState
{

}

- (void)didSaveState
{

}

- (void)willLeaveActiveState
{
   [_toolbar setHidden:YES];
}

- (void)didLeaveActiveState
{

}

- (UIView *)contentView
{
    return self.view;
}

- (void)hideToolbar:(BOOL)hide
{

}

@end
