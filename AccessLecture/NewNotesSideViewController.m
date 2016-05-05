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
#import "DraggableView.h"

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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [SaveImage sharedData].notesImage = chosenImage;
    DraggableView *imageView = [[DraggableView alloc] initWithImage:chosenImage];
    imageView.frame = CGRectMake(50, 600, 100, 100);
    [[SaveImage sharedData].selectedImagesArray addObject:imageView];
    [[SaveImage sharedData] save];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//allows the user to add images to their notes
- (IBAction)addImage:(id)sender
{
    //To implement the camera if need be, but gallery is available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
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
