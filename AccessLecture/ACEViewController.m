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
    
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        [_drawingView setFrame:CGRectMake(0, 0, 768, 1024)];
    } else {
        [_drawingView setFrame:CGRectMake(0, 0, 1024, 690)];
    }
    
    _drawingView.delegate = self;
    
    _lineWidthSlider.value = _drawingView.lineWidth;
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
            
            _colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    _drawingView.lineColor = [UIColor blackColor];
                    break;
                    
                case 1:
                    _drawingView.lineColor = [UIColor redColor];
                    break;
                    
                case 2:
                    _drawingView.lineColor = [UIColor greenColor];
                    break;
                    
                case 3:
                    _drawingView.lineColor = [UIColor blueColor];
                    break;
            }
            
        } else {
            
            _toolButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    _drawingView.drawTool = PenTool;
                    break;
                    
                case 1:
                    _drawingView.drawTool = LineTool;
                    break;
                    
                case 2:
                    _drawingView.drawTool = RectangleStrokeTool;
                    break;
                    
                case 3:
                    _drawingView.drawTool = RectangleFillTool;
                    break;
                    
                case 4:
                    _drawingView.drawTool = EllipseStrokeTool;
                    break;
                    
                case 5:
                    _drawingView.drawTool = EllipseFillTool;
                    break;
                    
                case 6:
                    _drawingView.drawTool = EraserTool;
                    break;
            }
        
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
                                                    otherButtonTitles:@"Black", @"Red", @"Green", @"Blue", nil];
    
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
    return _drawingView;
}

@end
