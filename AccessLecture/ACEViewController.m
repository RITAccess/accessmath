//
//  ACEViewController.m
//  ACEDrawingViewDemo
//
//  Created by Stefano Acerbetti on 1/6/13.
//  Copyright (c) 2013 Stefano Acerbetti. All rights reserved.
//

#import "ACEViewController.h"
#import "ACEDrawingView.h"
#import <QuartzCore/QuartzCore.h>

#define kActionSheetColor       100
#define kActionSheetTool        101

@interface ACEViewController ()<UIActionSheetDelegate, ACEDrawingViewDelegate>

@end

@implementation ACEViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    _drawingView.delegate = self;

    _lineWidthSlider.value = _drawingView.lineWidth;

    // Draw on clear canvas
    [self.view setBackgroundColor:[UIColor clearColor]];

    // Rotating toolbar, Y values are not what you'd expect
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        [_toolbar setFrame:CGRectMake(0, 1024 -  _toolbar.frame.size.height, 768, _toolbar.frame.size.height)];
    } else {
        [_toolbar setFrame:CGRectMake(0, 1024 + _toolbar.frame.size.height, 1024, _toolbar.frame.size.height)];
    }
}


#pragma mark - Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        [_toolbar setFrame:CGRectMake(0, screenHeight - _toolbar.frame.size.height, 768, _toolbar.frame.size.height)];
        [_lineAlphaSlider setFrame:CGRectMake(100, 700 - _toolbar.frame.size.height, 800, _lineAlphaSlider.frame.size.height)];
        [_lineWidthSlider setFrame:CGRectMake(100, 700 - _toolbar.frame.size.height, 800, _lineAlphaSlider.frame.size.height)];
    } else {
        [_toolbar setFrame:CGRectMake(0, screenWidth - _toolbar.frame.size.height, 1024, _toolbar.frame.size.height)];
        [_lineAlphaSlider setFrame:CGRectMake(100, 930 - _toolbar.frame.size.height, 550, _lineAlphaSlider.frame.size.height)];
        [_lineWidthSlider setFrame:CGRectMake(100, 930 - _toolbar.frame.size.height, 550, _lineAlphaSlider.frame.size.height)];
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
