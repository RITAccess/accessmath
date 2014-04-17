//
//  ImageNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/13/14.
//
//

#import "ImageNoteViewController.h"
#import "UIImage+Screenshot.h"

@interface ImageNoteViewController ()

@end

@implementation ImageNoteViewController

- (id)init
{
    self = [super initWithNibName:@"ImageNoteViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)captureView:(id)sender
{
    UIImage *image = [UIImage screenshot];
    CGImageRef cropped = CGImageCreateWithImageInRect(image.CGImage, self.view.frame);
    UIImage *viewScreenshot = [UIImage imageWithCGImage:cropped];
    CGImageRelease(cropped);
    #pragma unused(viewScreenshot)
}

@end
