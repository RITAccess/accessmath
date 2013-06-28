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
        _isCreatingNote = NO;
        _isDrawing = NO;
//        _tapToCreateNote = [[UITapGestureRecognizer alloc]initWithTarget:self action
//                                                                        :@selector(createNote:)];
        _tapToDismissKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                             :@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:_tapToDismissKeyboard];
      //  [self.view addGestureRecognizer:_tapToCreateNote];

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

- (void)createNoteText:(UIGestureRecognizer *)gesture
{
    if (_isCreatingNote){
        if(self.isCreatingNote){
           UIPanGestureRecognizer *panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
            
            UILongPressGestureRecognizer *longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
            longPressGestureRecognizer.numberOfTouchesRequired = 3;
            longPressGestureRecognizer2.numberOfTouchesRequired = 1;
          
            UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake([gesture locationInView:self.view].x+20, [gesture locationInView:self.view].y+15, 350, 150)];
                        
            UITextView *textBubble = [[UITextView alloc]initWithFrame:CGRectMake([gesture locationInView:outerView].x + 20, [gesture locationInView:outerView].y + 15, 300, 120)];
            [outerView addSubview:textBubble];
           
            UIImageView * anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png" ]];
            [anImageView setCenter:textBubble.bounds.origin];
            [anImageView setBounds:CGRectMake([gesture locationInView:self.view].x, [gesture locationInView:self.view].y, 50, 50)];
            textBubble.text = @"Type Notes Here...";
            textBubble.layer.borderWidth = 3;
            textBubble.layer.cornerRadius = 20;
            [textBubble setFont:[UIFont boldSystemFontOfSize:30]];
            [outerView addGestureRecognizer:panToMoveNote];
            [textBubble addGestureRecognizer:longPressGestureRecognizer];
            [outerView addGestureRecognizer:longPressGestureRecognizer2];
            [textBubble addSubview:anImageView];
            [textBubble setScrollEnabled:YES];
            [self.view addSubview:outerView];
            [textBubble setClipsToBounds:NO];
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
   if(_isCreatingNote){
    [gestureRecognizer.view setFrame:CGRectMake([gestureRecognizer locationInView:self.view].x, [gestureRecognizer locationInView:self.view].y, 350, 150)];
   }
    else if(_isDrawing)
    {
        [gestureRecognizer.view setFrame:CGRectMake([gestureRecognizer locationInView:self.view].x, [gestureRecognizer locationInView:self.view].y, 500, 500)];
    }
}

- (void)longPressToRemoveNote:(UILongPressGestureRecognizer *)gestureRecognizer
{

if(_isCreatingNote)
{
    [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, 5, 5)];
}
else if(_isDrawing)
    {
        [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, 5, 5)];
      [gestureRecognizer.view gestureRecognizerShouldBegin:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)]];
    }
}
- (void)longPressToDisplayNote:(UILongPressGestureRecognizer *)gestureRecognizer
{

    if((_isCreatingNote)&&([gestureRecognizer.view isKindOfClass:[UIView class]])){
    UITextView *temp = [[[gestureRecognizer view] subviews] objectAtIndex:0];
    [[[[gestureRecognizer view] subviews] objectAtIndex:0] removeFromSuperview];
      [temp setFrame:CGRectMake([gestureRecognizer locationInView:gestureRecognizer.view].x, [gestureRecognizer locationInView:gestureRecognizer.view].y, 300, 120)];
    [gestureRecognizer.view addSubview:temp];
    }
    else if((_isDrawing)&&([gestureRecognizer.view isKindOfClass:[LineDrawView class]]))
    {
        NSLog(@"Reached");
        UITextView *temp = [[[gestureRecognizer view] subviews] objectAtIndex:0];
        [[[[gestureRecognizer view] subviews] objectAtIndex:0] removeFromSuperview];
        [temp setFrame:CGRectMake([gestureRecognizer locationInView:gestureRecognizer.view].x, [gestureRecognizer locationInView:gestureRecognizer.view].y, 400, 300)];
        [gestureRecognizer.view addSubview:temp];
    }
}

- (IBAction)createDrawNote:(id)sender {
    _isCreatingNote=NO;
    _isDrawing = YES;
    _tapToCreateNote = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                    :@selector(createNoteDraw:)];
    _tapToCreateNote.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:_tapToCreateNote];
    [self viewDidLoad];
    NSLog(@" Draw pressed");

}

- (void)createNoteDraw:(UIGestureRecognizer *)gesture{
     UIPanGestureRecognizer *panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
      UILongPressGestureRecognizer *longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
    longPressGestureRecognizer.numberOfTouchesRequired = 3;
    longPressGestureRecognizer2.numberOfTouchesRequired = 1;
    UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake([gesture locationInView:self.view].x+20, [gesture locationInView:self.view].y+15, 500, 500)];
    [panToMoveNote setEnabled:NO];
    LineDrawView *lineDrawView = [[LineDrawView alloc]initWithFrame:CGRectMake([gesture locationInView:outerView].x + 20, [gesture locationInView:outerView].y + 15, 400, 300)];
    lineDrawView.userInteractionEnabled = YES;
    lineDrawView.isDrawing = YES;
    lineDrawView.layer.borderWidth = 3;
    lineDrawView.layer.cornerRadius = 20;
    UIImageView * anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png" ]];
    [anImageView setCenter:lineDrawView.bounds.origin];
    [anImageView setBounds:CGRectMake([gesture locationInView:self.view].x, [gesture locationInView:self.view].y, 50, 50)];
    [outerView addGestureRecognizer:panToMoveNote];
    [lineDrawView addGestureRecognizer:longPressGestureRecognizer];
    [outerView addGestureRecognizer:longPressGestureRecognizer2];
    [lineDrawView addSubview:anImageView];
    outerView.layer.borderWidth = 2;
    [outerView addSubview:lineDrawView];
    [self.view addSubview:outerView];
    
    
}
- (IBAction)createTextNote:(id)sender {
    _isDrawing = NO;
    _isCreatingNote = YES;
    _tapToCreateNote = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                    :@selector(createNoteText:)];
    _tapToCreateNote.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:_tapToCreateNote];
    [self viewDidLoad];
NSLog(@" Note pressed");
}
@end
