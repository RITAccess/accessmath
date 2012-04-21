// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>

@interface ColorViewController : UIViewController {
    
    // Toolbar sliders
    IBOutlet UISlider* redToolSlider;
    IBOutlet UISlider* greenToolSlider;
    IBOutlet UISlider* blueToolSlider;
    
    // Text sliders
    IBOutlet UISlider* redTextSlider;
    IBOutlet UISlider* greenTextSlider;
    IBOutlet UISlider* blueTextSlider;
    
    // Transparency slider
    IBOutlet UISlider* transparencySlider;
    
    // The preview view
    IBOutlet UIView* preview;
    
    // The text on the preview
    IBOutlet UILabel* previewLabel;
    
    // Top toolbar
    IBOutlet UIView* toolbar;
    
    // Top toolbar label
    IBOutlet UILabel* toolbarLabel;
    
    // Floats representating the current values of the sliders
    float toolRed, toolGreen, toolBlue, textRed, textGreen, textBlue;
    
    // User settings
    NSUserDefaults* defaults;
    
}

- (void)settingsChange;
- (IBAction)sliderWasChanged:(id)sender;

@end
