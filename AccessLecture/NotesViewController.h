// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface NotesViewController : UIViewController<UITextViewDelegate>{
    
    // The color picking segmented control
	IBOutlet UISegmentedControl* segmentedControl;
    
    // Pen variables
	CGPoint lastPoint;
	int r;
	int g;
	int b;
	int penRadius;
	int eraserRadius;
	BOOL isEraserOn;
    BOOL isMouseMoved;
	int mouseMoved;
    UIImageView* eraser;
    
    // ImageView you're drawing on
	IBOutlet UIImageView* imageView;
    
    // Holds the user preferences
    NSUserDefaults* defaults;
    
    // Images for segmented control
    UIImage* redDown;
    UIImage* redUp;
    UIImage* greenDown;
    UIImage* greenUp;
    UIImage* blueDown;
    UIImage* blueUp;
    UIImage* blackDown;
    UIImage* blackUp;
    UIImage* eraserDown;
    UIImage* eraserUp;

}

@property (nonatomic) IBOutlet UISegmentedControl* segmentedControl;
@property (nonatomic) IBOutlet UIImageView* imageView;

-(IBAction) segmentedControlIndexChanged;
-(void)settingsChange;
-(void)setColorRGB:(int)red green:(int)green blue:(int)blue;
-(void)setPenRadius:(int)pixels;
-(int)penRadius;
-(void)resetEraser:(BOOL)isSet;
-(void)changeEraserLocationTo:(CGPoint)locationPoint;
- (UIBezierPath *)makeCircleAtLocation:(CGPoint)location radius:(CGFloat)radius;
@end
