// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>

/**
 * DEPRECATED FOR NOW
 * INCOMPLETE
 *
 *  Shows a note-taking box at the bottom of the lecture view
 */

@interface InlineNotesViewController : UIViewController {
    
    // Pen variables
	CGPoint lastPoint;
    UIImageView* eraser;
	int r;
	int g;
	int b;
	int penRadius;
	int eraserRadius;
	BOOL isEraserOn;
    BOOL isMouseMoved;
	int mouseMoved;
	
    // View that holds the background image and the drawings on top of it
    IBOutlet UIImageView* drawingView;
    
    // The color picking segmented control
	IBOutlet UISegmentedControl* segmentedControl;
    
    // Height of the inline notebox
    float viewHeight;
    
    // The parent scrollview
    UIScrollView* parentScrollView; 
}

-(id)initWithScrollView:(UIScrollView*)sv;
-(id)initWithHeight:(float)height : (UIScrollView*) sv;
-(IBAction)backButton:(id)sender;
-(IBAction)saveButton:(id)sender;
-(IBAction)segmentedControlIndexChanged;
-(void)setColorRGB:(int)red green:(int)green blue:(int)blue;
-(void)setPenRadius:(int)pixels;
-(void)resetEraser:(BOOL)isSet;
-(void)changeEraserLocationTo:(CGPoint)locationPoint;

@property (nonatomic) IBOutlet UISegmentedControl* segmentedControl;

@end
