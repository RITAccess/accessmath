//
//  NotesViewController.m
//  AccessLecture
//
//  Created by Student on 6/26/13.
//
//

#import "NotesViewController.h"

@interface NotesViewController ()

@end

@implementation NotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isCreatingNote = YES;
        _isDrawing = YES;
        _tapToCreateNote = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                        :@selector(createNote:)];
        _tapToCreateNote.numberOfTapsRequired = 2;
        _tapToDismissKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                             :@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:_tapToDismissKeyboard];
        [self.view addGestureRecognizer:_tapToCreateNote];

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
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)createNote:(UIGestureRecognizer *)gesture
{
    if (_isCreatingNote){
        if(self.isCreatingNote){
            //            UIImageView *pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
            //            [pinImageView setCenter:[gesture locationInView:self]];
            //            [pinImageView setTransform:CGAffineTransformMakeScale(.25, .25)]; // Shrinking the pin...
            //            pinImageView.userInteractionEnabled = YES;
            //            [self addSubview:pinImageView];
            
            UIPanGestureRecognizer *panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
            
            UILongPressGestureRecognizer *longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
            longPressGestureRecognizer.numberOfTouchesRequired = 3;
            longPressGestureRecognizer2.numberOfTouchesRequired = 4;
            
            UITextView *textBubble = [[UITextView alloc]initWithFrame:CGRectMake([gesture locationInView:self.view].x + 15, [gesture locationInView:self.view].y + 10, 300, 120)];
            UIImageView * anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png" ]];
            [anImageView setCenter:textBubble.bounds.origin];
            [anImageView setBounds:CGRectMake([gesture locationInView:self.view].x, [gesture locationInView:self.view].y, 50, 50)];
            [textBubble addSubview:anImageView];
            textBubble.text = @"Type Notes Here...";
            textBubble.layer.borderWidth = 3;
            textBubble.layer.cornerRadius = 20;
            [textBubble setFont:[UIFont boldSystemFontOfSize:30]];
            [textBubble addGestureRecognizer:panToMoveNote];
            [textBubble addGestureRecognizer:longPressGestureRecognizer2];
            [textBubble addGestureRecognizer:longPressGestureRecognizer];
            
            
            [self.view addSubview:textBubble];
            [textBubble setClipsToBounds:NO];
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    [gestureRecognizer.view setFrame:CGRectMake([gestureRecognizer locationInView:self.view].x, [gestureRecognizer locationInView:self.view].y, 300, 120)];
}

- (void)longPressToRemoveNote:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //[gestureRecognizer.view removeFromSuperview];
    [gestureRecognizer.view setHidden:YES];
    NSLog(@"Three");
    
}
- (void)longPressToDisplayNote:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NSLog(@"Two");
}

@end
