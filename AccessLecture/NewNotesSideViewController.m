//
//  NewNotesSideViewController.m
//  AccessLecture
//
//  TODO: Fix up buttons and other elements of view so that they can be seen.
//  Created by Kimberly Sookoo on 2/11/16.
//
//

#import "NewNotesSideViewController.h"
#import "SaveImage.h"

@interface NewNotesSideViewController ()

@end

@implementation NewNotesSideViewController
{
    //user options to add image, text, or video
    UIButton *addImage;
    UIButton *addText;
    UIButton *addVideo;
    
    //original center
    CGPoint _originalCenter;
    UIPanGestureRecognizer *imageViewPan;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    addImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addImage.frame = CGRectMake(150, 150, 120, 50);
    addImage.backgroundColor = [UIColor grayColor];
    [addImage setTitle:@"Add Image" forState:UIControlStateNormal];
    [addImage addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    
    addText = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addText.backgroundColor = [UIColor grayColor];
    [addText setTitle:@"Add Text" forState:UIControlStateNormal];
    
    addVideo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addVideo.backgroundColor = [UIColor grayColor];
    [addVideo setTitle:@"Add Video" forState:UIControlStateNormal];
    
    [self.view addSubview:addImage];
}


/*- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [SaveImage sharedData].notesImage = chosenImage;
    [[SaveImage sharedData].selectedImagesArray addObject:chosenImage];
    [[SaveImage sharedData] save];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}*/

//allows the user to add images to their notes
- (IBAction)addImage:(id)sender
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor blueColor];
    imageView.userInteractionEnabled = YES;
    imageViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGensture:)];
    [imageView addGestureRecognizer:imageViewPan];
    imageView.frame = CGRectMake(150, 170, 100, 100);
    [self.view addSubview:imageView];
    //To implement the camera if need be, but gallery is available
    /*if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    } else {
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];*/
}

- (void)handlePanGensture:(UIPanGestureRecognizer*)panGesture {
    CGPoint translation = [panGesture translationInView:panGesture.view.superview];
    _originalCenter = imageViewPan.view.center;
    if (UIGestureRecognizerStateBegan == panGesture.state ||UIGestureRecognizerStateChanged == panGesture.state) {
        panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x,
                                             panGesture.view.center.y + translation.y);
        // Reset translation, so we can get translation delta's (i.e. change in translation)
        [panGesture setTranslation:CGPointZero inView:self.view];
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [panGesture velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200; //original divider 200
        
        float slideFactor = 0.1 * slideMult /4; // Increase for more of a slide (original doesn't have a divider)
        CGPoint finalPoint = CGPointMake(panGesture.view.center.x + (velocity.x * slideFactor),
                                         panGesture.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 70), self.view.bounds.size.width-70);
        finalPoint.y = MIN(MAX(finalPoint.y, 100), self.view.bounds.size.height-100);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            panGesture.view.center = finalPoint;
        } completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
