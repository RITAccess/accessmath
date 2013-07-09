//
//  NotesViewController.m
//  AccessLecture
//
//  Created by Student on 6/26/13.
//
//

#import "NotesViewController.h"
#import "UILargeAlertView.h"
#import "FTCoreTextView.h"
@interface NotesViewController ()

@end

@implementation NotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isCreatingNote = NO;
        _isDrawing = NO;
        _tapToDismissKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                             :@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:_tapToDismissKeyboard];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    startTag = @"<black>";
    endTag = @"</black>";
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
          //Initilize gesture recognizers for the view
            UIPanGestureRecognizer *panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
            
            UILongPressGestureRecognizer *longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
            longPressGestureRecognizer.numberOfTouchesRequired = 3;
            longPressGestureRecognizer2.numberOfTouchesRequired = 1;
          
            UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake([gesture locationInView:self.view].x, [gesture locationInView:self.view].y, 350, 150)];
         
            FTCoreTextView *text = [[FTCoreTextView alloc]initWithFrame:CGRectMake([gesture locationInView:outerView].x+10 , [gesture locationInView:outerView].y+10 , 300, 120)];
            [text setText:@"<bold>Type Notes...</bold>"];
            [text addStyles:[self coreTextStyle]];
            [text setUserInteractionEnabled:YES];
            UITextView *textBubble = [[UITextView alloc]initWithFrame:CGRectMake([gesture locationInView:outerView].x, [gesture locationInView:outerView].y , 310, 120)];
           //        outerView.layer.borderWidth = 3;
            [outerView addSubview:text];
           // text.layer.borderWidth = 3;
           
            //text.layer.cornerRadius = 20;
            [outerView addSubview:textBubble];
                        UIImageView * anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png" ]];
            [anImageView setCenter:textBubble.bounds.origin];
            [anImageView setBounds:CGRectMake([gesture locationInView:self.view].x, [gesture locationInView:self.view].y, 50, 50)];
           // textBubble.textColor = [UIColor clearColor];
            textBubble.textAlignment = NSTextAlignmentJustified;
           
            textBubble.text = @"Type Notes...";
            textBubble.delegate = self;
            textBubble.layer.borderWidth = 3;
            textBubble.layer.cornerRadius = 20;
            textBubble.backgroundColor = [UIColor clearColor];
           [textBubble setFont:[UIFont boldSystemFontOfSize:30]];
            [outerView addGestureRecognizer:panToMoveNote];
            [textBubble addGestureRecognizer:longPressGestureRecognizer];
            //[text addGestureRecognizer:longPressGestureRecognizer];
            [outerView addGestureRecognizer:longPressGestureRecognizer2];
            [textBubble addSubview:anImageView];
            [textBubble setScrollEnabled:YES];
            [textBubble scrollRectToVisible:CGRectMake([gesture locationInView:self.view].x+20, [gesture locationInView:self.view].y+15, 300, 120) animated:NO];
            [self.view addSubview:outerView];
            [textBubble setClipsToBounds:NO];
            [textBubble becomeFirstResponder];
         
          
        }
    }
}
- (void)createNoteDraw:(UIGestureRecognizer *)gesture{
   //Initilize gesture recognizers for the view
    UIPanGestureRecognizer *panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    UIPanGestureRecognizer *panToResize = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleResize:)];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
    UILongPressGestureRecognizer *longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
    longPressGestureRecognizer.numberOfTouchesRequired = 3;
    longPressGestureRecognizer2.numberOfTouchesRequired = 1;
    UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake([gesture locationInView:self.view].x+20, [gesture locationInView:self.view].y+15, 430, 330)];
    [panToMoveNote setEnabled:NO];
    [panToResize setEnabled:NO];
    LineDrawView *lineDrawView = [[LineDrawView alloc]initWithFrame:CGRectMake([gesture locationInView:outerView].x + 20, [gesture locationInView:outerView].y + 15, 400, 300)];
    lineDrawView.userInteractionEnabled = YES;
    lineDrawView.isDrawing = YES;
    //outerView.layer.borderWidth = 3;
    lineDrawView.layer.borderWidth = 3;
    lineDrawView.layer.cornerRadius = 20;
    UIImageView * anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png" ]];
    UIImageView * resizeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resize.png" ]];
    CGPoint point = CGPointMake(outerView.bounds.size.width-20, outerView.bounds.size.height-20);
    [resizeView setCenter:point];
    [anImageView setCenter:lineDrawView.bounds.origin];
    [resizeView setBounds:CGRectMake([gesture locationInView:self.view].x, [gesture locationInView:self.view].y, 50, 50)];
    [anImageView setBounds:CGRectMake([gesture locationInView:self.view].x, [gesture locationInView:self.view].y, 50, 50)];
   // resizeView.layer.borderWidth = 3;
    //Do not change the order in which the subviews and gestures are added
    [outerView addGestureRecognizer:panToMoveNote];
    [lineDrawView addGestureRecognizer:longPressGestureRecognizer];
    [outerView addGestureRecognizer:longPressGestureRecognizer2];
    [lineDrawView addSubview:anImageView];
    [outerView addGestureRecognizer:panToResize];
    [outerView addSubview:resizeView];
    [outerView addSubview:lineDrawView];
    [self.view addSubview:outerView];


   
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
   if(_isCreatingNote){
    [gestureRecognizer.view setFrame:CGRectMake([gestureRecognizer locationInView:self.view].x, [gestureRecognizer locationInView:self.view].y, [[[[gestureRecognizer view] subviews] objectAtIndex:0] size].width+20, [[[[gestureRecognizer view] subviews] objectAtIndex:0] size].height+20)];
//       [gestureRecognizer.view.superview setFrame:CGRectMake([gestureRecognizer locationInView:self.view].x, [gestureRecognizer locationInView:self.view].y, [[[[gestureRecognizer view] subviews] objectAtIndex:0] size].width+20, [[[[gestureRecognizer view] subviews] objectAtIndex:0] size].height+20)];
   }
    else if(_isDrawing)
    {
        [gestureRecognizer.view setFrame:CGRectMake([gestureRecognizer locationInView:self.view].x, [gestureRecognizer locationInView:self.view].y, 50, 50)];
    }
}

- (void)handleResize:(UIPanGestureRecognizer *)gestureRecognizer {
    if((_isDrawing)){
        UIImageView *temp = [[[gestureRecognizer view] subviews] objectAtIndex:0];
        UIImageView *tempImage = [[[gestureRecognizer view] subviews] objectAtIndex:1];
        [[[[gestureRecognizer view] subviews] objectAtIndex:0] removeFromSuperview];
        [[[[gestureRecognizer view] subviews] objectAtIndex:0] removeFromSuperview];
        [gestureRecognizer.view addSubview:temp];
        [gestureRecognizer.view addSubview:tempImage];
        [tempImage setFrame:CGRectMake(gestureRecognizer.view.superview.frame.origin.x, gestureRecognizer.view.superview.frame.origin.x,[gestureRecognizer locationInView:gestureRecognizer.view].x, [gestureRecognizer locationInView:gestureRecognizer.view].y)];
        CGPoint point = CGPointMake(gestureRecognizer.view.frame.size.width-20, gestureRecognizer.view.frame.size.height-20);
        [temp setCenter:point];
       [temp setBounds:CGRectMake([gestureRecognizer locationInView:self.view].x, [gestureRecognizer locationInView:self.view].y, 50, 50)];
        [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, [gestureRecognizer locationInView:gestureRecognizer.view].x+20, [gestureRecognizer locationInView:gestureRecognizer.view].y+20)];
                       
        
    }
}
- (void)longPressToRemoveNote:(UILongPressGestureRecognizer *)gestureRecognizer
{

if(_isCreatingNote)
{
    [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, 5, 5)];
    [gestureRecognizer.view.superview setFrame:CGRectMake(gestureRecognizer.view.superview.frame.origin.x, gestureRecognizer.view.superview.frame.origin.y, 50, 50)];
     [[[gestureRecognizer.view.superview subviews] objectAtIndex:0] setFrame:CGRectMake(gestureRecognizer.view.superview.frame.origin.x, gestureRecognizer.view.superview.frame.origin.y, 5, 5)];
}
else if(_isDrawing)
    {
               
        [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, 5, 5)];
        [gestureRecognizer.view.superview setFrame:CGRectMake(gestureRecognizer.view.superview.frame.origin.x, gestureRecognizer.view.superview.frame.origin.y, 50, 50)];
        [[gestureRecognizer.view.superview.subviews  objectAtIndex:0] setHidden:YES];
        for(UIGestureRecognizer *recognizer in gestureRecognizer.view.superview.gestureRecognizers)
      {
                   if([recognizer isKindOfClass:[UIPanGestureRecognizer class]])
          {
              [recognizer setEnabled:YES];
                        }
      }
    [[gestureRecognizer.view.superview.gestureRecognizers objectAtIndex:2] setEnabled:NO];
    }
    
} 
- (void)longPressToDisplayNote:(UILongPressGestureRecognizer *)gestureRecognizer
{

    if((_isCreatingNote)&&([[[[gestureRecognizer view] subviews] objectAtIndex:1] isKindOfClass:[UITextView class]])){
    UITextView *temp = [[[gestureRecognizer view] subviews] objectAtIndex:1];
    FTCoreTextView *tempView = [[[gestureRecognizer view] subviews] objectAtIndex:0];
    [[[[gestureRecognizer view] subviews] objectAtIndex:1] removeFromSuperview];
    [[[[gestureRecognizer view] subviews] objectAtIndex:0] removeFromSuperview];
      [temp setFrame:CGRectMake([gestureRecognizer locationInView:gestureRecognizer.view].x, [gestureRecognizer locationInView:gestureRecognizer.view].y, 300, 120)];
        [tempView setFrame:CGRectMake([gestureRecognizer locationInView:gestureRecognizer.view].x, [gestureRecognizer locationInView:gestureRecognizer.view].y, 300, 120)];
        CGRect frame = temp.frame;
        frame.size.height = temp.contentSize.height;
        temp.frame = frame;
        tempView.frame = frame;
        [gestureRecognizer.view addSubview:tempView];
        [gestureRecognizer.view addSubview:temp];
        [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, temp.frame.size.width, temp.frame.size.height)];
        
    }
    else if((_isDrawing)&&([[[[gestureRecognizer view] subviews] objectAtIndex:1] isKindOfClass:[LineDrawView class]])&&(gestureRecognizer.view.frame.size.width==50))
    {
       
      
        [[gestureRecognizer.view.subviews objectAtIndex:0] setHidden:NO];
        UIImageView *temp = [[[gestureRecognizer view] subviews] objectAtIndex:1];
        [[[[gestureRecognizer view] subviews] objectAtIndex:1] removeFromSuperview];
        [temp setFrame:CGRectMake([gestureRecognizer locationInView:gestureRecognizer.view].x, [gestureRecognizer locationInView:gestureRecognizer.view].y, [[gestureRecognizer.view.subviews  objectAtIndex:0] center].x, [[gestureRecognizer.view.subviews  objectAtIndex:0] center].y)];
        [gestureRecognizer.view addSubview:temp];
         [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, [[gestureRecognizer.view.subviews  objectAtIndex:0] center].x+20, [[gestureRecognizer.view.subviews  objectAtIndex:0] center].y+20)];
        for(UIGestureRecognizer *recognizer in gestureRecognizer.view.gestureRecognizers)
        {
            if([recognizer isKindOfClass:[UIPanGestureRecognizer class]])
            {
                [recognizer setEnabled:NO];
            }
        }
        
    }
    else if(CGRectContainsPoint([[gestureRecognizer.view.subviews objectAtIndex:0] frame],[gestureRecognizer locationInView:gestureRecognizer.view] ))
    {
     

        [[gestureRecognizer.view.gestureRecognizers objectAtIndex:2] setEnabled:!([[gestureRecognizer.view.gestureRecognizers objectAtIndex:2] isEnabled])];
        return;
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
 
       return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {

}
- (void)textViewDidChange:(UITextView *)textView{
        
   
    FTCoreTextView *temp =  [[textView.superview  subviews] objectAtIndex:0];
    char tempchar = [textView.text characterAtIndex:[textView.text length]-1];
    [[[textView.superview  subviews] objectAtIndex:0] setText:[NSString stringWithFormat:@"%@%@%c%@",temp.text,startTag,tempchar,endTag]];
    textView.textColor = [UIColor clearColor];
    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height;
    frame.origin = textView.frame.origin;
    textView.frame = frame;
    [textView.superview setFrame:CGRectMake(textView.superview.frame.origin.x, textView.superview.frame.origin.y, textView.frame.size.width+20, textView.frame.size.height+20)];
   
      [[[textView.superview  subviews] objectAtIndex:0] setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, 300, textView.frame.size.height)];

    [[[textView.superview  subviews] objectAtIndex:1] becomeFirstResponder];
       //[textView becomeFirstResponder];
 
  }
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(text.length<=0)
    {
        FTCoreTextView *temp =  [[textView.superview  subviews] objectAtIndex:0];
        NSRange selectedRange = NSMakeRange(0, (temp.text.length - startTag.length-endTag.length-1));
        NSString *str = [temp.text substringWithRange:selectedRange];
        NSLog(@"%@",str);
        NSLog(@"backspace pressed");
        [[[textView.superview  subviews] objectAtIndex:0] setText:str];
        [[[textView.superview  subviews] objectAtIndex:0] setNeedsDisplay];
        [textView becomeFirstResponder];
        return true;
    }
   
        return true;
}
- (IBAction)createDrawNote:(id)sender {
    _isCreatingNote=NO;
    _isDrawing = YES;
    _tapToCreateNote = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                    :@selector(createNoteDraw:)];
    _tapToCreateNote.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:_tapToCreateNote];
    [self viewDidLoad];
    UIAlertView* alert = [[UILargeAlertView alloc] initWithText:NSLocalizedString(@"Drawing Mode", nil) fontSize:48];
    [alert show];
    
}


- (IBAction)createTextNote:(id)sender {
    _isDrawing = NO;
    _isCreatingNote = YES;
    _tapToCreateNote = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                    :@selector(createNoteText:)];
    _tapToCreateNote.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:_tapToCreateNote];
    [self viewDidLoad];
    UIAlertView* alert = [[UILargeAlertView alloc] initWithText:NSLocalizedString(@"Text Mode", nil) fontSize:48];
    [alert show];
}
- (IBAction)setBlueColor:(id)sender {
    textColor = [UIColor blueColor];
    startTag = @"<blue>";
    endTag = @"</blue>";
}
- (IBAction)setYellowColor:(id)sender {
    textColor = [UIColor yellowColor];
    startTag = @"<yellow>";
    endTag = @"</yellow>";
}

- (IBAction)setRedColor:(id)sender {
    textColor = [UIColor redColor];
    startTag = @"<red>";
    endTag = @"</red>";
}
- (NSArray *)coreTextStyle{
    NSMutableArray *result = [NSMutableArray array];
    FTCoreTextStyle *boldStyle = [FTCoreTextStyle new];
    boldStyle.name = @"bold";
    boldStyle.font = [UIFont boldSystemFontOfSize:30];
    [result addObject:boldStyle];
    FTCoreTextStyle *blueColor = [FTCoreTextStyle new];
    [blueColor setName:@"blue"];
    blueColor.font = [UIFont boldSystemFontOfSize:30];
    [blueColor setColor:[UIColor blueColor]];
    [result addObject:blueColor];
    FTCoreTextStyle *redColor = [FTCoreTextStyle new];
    [redColor setName:@"red"];
     redColor.font = [UIFont boldSystemFontOfSize:30];
    [redColor setColor:[UIColor redColor]];
    [result addObject:redColor];
    FTCoreTextStyle *yellowColor = [FTCoreTextStyle new];
    [yellowColor setName:@"yellow"];
    [yellowColor setColor:[UIColor yellowColor]];
    yellowColor.font = [UIFont boldSystemFontOfSize:30];
   [result addObject:yellowColor];
    FTCoreTextStyle *blackColor = [FTCoreTextStyle new];
    [blackColor setName:@"black"];
    [blackColor setColor:[UIColor blackColor]];
    blackColor.font = [UIFont boldSystemFontOfSize:30];
    [result addObject:blackColor];
    return result;

}
@end
