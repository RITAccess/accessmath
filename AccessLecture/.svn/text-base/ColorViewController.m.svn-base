// Copyright 2011 Access Lecture. All rights reserved.

#import "ColorViewController.h"

@implementation ColorViewController

/**
 Initialize with a certain xib file
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

/**
 * Returns to the previous screen by popping the top of the controller stack
 */
-(IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 Set up when the view loads
 */
- (void)viewDidLoad {
    // Hide navigation bar, we have our own toolbar
    self.navigationController.navigationBarHidden = YES;
    
    // Users default settings
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Observe NSUserDefaults for setting changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChange) name:NSUserDefaultsDidChangeNotification object:nil];
    
    // Set up toolbar sliders
    [redToolSlider setValue:[defaults floatForKey:@"tbRed"]];
    [greenToolSlider setValue:[defaults floatForKey:@"tbGreen"]];
    [blueToolSlider setValue:[defaults floatForKey:@"tbBlue"]];
    
    // Set up text sliders
    [redTextSlider setValue:[defaults floatForKey:@"textRed"]];
    [greenTextSlider setValue:[defaults floatForKey:@"textGreen"]];
    [blueTextSlider setValue:[defaults floatForKey:@"textBlue"]];
    
    // Set up transparency slider
    [transparencySlider setValue:[defaults floatForKey:@"toolbarAlpha"]];
    
    // User settings
    [self settingsChange];
    
    // Observe NSUserDefaults for setting changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChange) name:NSUserDefaultsDidChangeNotification object:nil];
    
    [super viewDidLoad];
}

/**
 Deallocate memory
 */
- (void)dealloc {
    [redToolSlider release];
    [greenToolSlider release];
    [blueToolSlider release];
    [redTextSlider release];
    [greenTextSlider release];
    [blueTextSlider release];
    [transparencySlider release];
    [preview release];
    [previewLabel release];
    [super dealloc];
}

/**
 Memory warning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 When the view unloads
 */
- (void)viewDidUnload {
    [super viewDidUnload];
}

/**
 View is unrotateable for now
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

/**
 Called when a slider is changed
 */
- (IBAction)sliderWasChanged:(id)sender {
    // Toolbar
    [defaults setFloat:[redTextSlider value] forKey:@"textRed"];
    [defaults setFloat:[greenTextSlider value] forKey:@"textGreen"];
    [defaults setFloat:[blueTextSlider value]forKey:@"textBlue"];
    
    // Text
    [defaults setFloat:[redToolSlider value] forKey:@"tbRed"];
    [defaults setFloat:[greenToolSlider value] forKey:@"tbGreen"];
    [defaults setFloat:[blueToolSlider value] forKey:@"tbBlue"];
    
    // Transparency
    [defaults setFloat:[transparencySlider value] forKey:@"toolbarAlpha"];
}


/**
* Update settings when user defaults change 
 */
- (void)settingsChange {
    // Update toolbar color
    UIColor* toolbarColor = [UIColor colorWithRed:[redToolSlider value] green:[greenToolSlider value] blue:[blueToolSlider value] alpha:1.0];
    [preview setBackgroundColor:toolbarColor];
    
    toolRed = [defaults floatForKey:@"tbRed"];
    toolGreen = [defaults floatForKey:@"tbGreen"];
    toolBlue = [defaults floatForKey:@"tbBlue"];
    [toolbar setBackgroundColor:[UIColor colorWithRed:toolRed green:toolGreen blue:toolBlue alpha:1.0]];
    
    // Update text color
    UIColor* textColor = [UIColor colorWithRed:[redTextSlider value] green:[greenTextSlider value] blue:[blueTextSlider value] alpha:1.0];
    previewLabel.textColor = textColor;
    
    textRed = [defaults floatForKey:@"textRed"];
    textGreen = [defaults floatForKey:@"textGreen"];
    textBlue = [defaults floatForKey:@"textBlue"];
    toolbarLabel.textColor = [UIColor colorWithRed:textRed green:textGreen blue:textBlue alpha:1.0];
    
    // Update toolbar transparency
    float newAlpha = 1 - [defaults floatForKey:@"toolbarAlpha"]; 
    [preview setAlpha:newAlpha];
}

@end
