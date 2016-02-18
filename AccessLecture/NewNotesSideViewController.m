//
//  NewNotesSideViewController.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 2/11/16.
//
//

#import "NewNotesSideViewController.h"
#import "NewNotesViewController.h"

@interface NewNotesSideViewController ()

@property (nonatomic, strong) NewNotesViewController *notesViewController;

@end

@implementation NewNotesSideViewController
{
    //user options to add image, text, or video
    UIButton *addImage;
    UIButton *addText;
    UIButton *addVideo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    addImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addImage.backgroundColor = [UIColor grayColor];
    [addImage setTitle:@"Add Image" forState:UIControlStateNormal];
    [addImage addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    
    addText = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addText.backgroundColor = [UIColor grayColor];
    [addText setTitle:@"Add Text" forState:UIControlStateNormal];
    
    addVideo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addVideo.backgroundColor = [UIColor grayColor];
    [addVideo setTitle:@"Add Video" forState:UIControlStateNormal];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _notesViewController.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//allows the user to add images to their notes
- (IBAction)addImage:(UIButton *)sender
{
    if ([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait) {
        // TODO: implement or remove
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
