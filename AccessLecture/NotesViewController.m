//
//  NotesViewController.m
//  AccessLecture
//
//  Created by Student on 6/26/13.
//
//

#import "NotesViewController.h"
#import "UILargeAlertView.h"

@interface noteLoader:NSObject{
   
}
@property(nonatomic) UIView *view;
@property(nonatomic) NSString *styleText;
@property(nonatomic) NSString *noteType;
@property(nonatomic) DrawView *drawContent;
@end

static NSString * VIEW_KEY = @"position_key";   // key to code for the position
static NSString * TEXT_KEY = @"text_key";         // key to code for the image
static NSString * TYPE_KEY = @"type_key";
static NSString * DRAW_KEY = @"draw_key";
@implementation noteLoader

-(id)init:(UIView*)noteView type:(NSString *)nType{
   self= [super init];
   
    if([nType isEqualToString:@"textNote"]){
    _view = noteView;
        _styleText = [[[noteView subviews] objectAtIndex:0] text];
    _noteType =[NSString stringWithString:nType];
        _drawContent = nil;
    }
    else if([nType isEqualToString:@"drawNote"]){
               _view = noteView;
        _styleText = @"";
        _noteType =[NSString stringWithString:nType];
        _drawContent = [[noteView subviews] objectAtIndex:1];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aCoder {
    if (self = [super init]) {
        _view = [aCoder decodeObjectForKey:VIEW_KEY];
        _styleText = [aCoder decodeObjectForKey:TEXT_KEY];
        _noteType = [aCoder decodeObjectForKey:TYPE_KEY];
        _drawContent = [aCoder decodeObjectForKey:DRAW_KEY];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_view forKey:VIEW_KEY];
    [aCoder encodeObject:_styleText forKey:TEXT_KEY];
    [aCoder encodeObject:_noteType forKey:TYPE_KEY];
    [aCoder encodeObject:_drawContent forKey:DRAW_KEY];
}
@end
@interface NotesViewController ()

@end
@implementation NotesViewController{
    
    }
 

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

-(void)viewDidAppear:(BOOL)animated{
    isOpened = NO;
    currentLecture.name = @"Lecture001";
    NSURL * currentDirectory = [FileManager iCloudDirectoryURL];
    if (currentDirectory == nil) currentDirectory = [FileManager localDocumentsDirectoryURL];
    NSString *docsPath =[[currentDirectory absoluteString] stringByAppendingString:[NSString stringWithFormat:@"AccessMath/%@.lecture",currentLecture.name]];
    NSURL *docURL = [NSURL URLWithString:docsPath];
    [[AccessLectureRuntime defaultRuntime] openDocument:docURL];
     currentDocument = [AccessLectureRuntime defaultRuntime].currentDocument;
   }
- (void)viewDidLoad
{
    [super viewDidLoad];
    startTag = @"<CD>";
    endTag = @"</CD>";
    isBackSpacePressed = FALSE;
    // Do any additional setup after loading the view from its nib.
    if(([currentDocument.notes count]>=0)&&(!isOpened)){
        [self initializeView];
        [self loadNotes:currentDocument.notes];
        isOpened = YES;
    }
    // Clear view
    [self.view setBackgroundColor:[UIColor clearColor]];

}
-(void)initializeView{
    _mainView = [[UIView alloc] initWithFrame:self.view.frame];
    self.toolBar.layer.cornerRadius = 20;
    [self.toolbarView addSubview:self.toolBar];
    [self.toolbarView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_mainView];
    [self.view addSubview:self.toolbarView];
   [self.view addSubview:self.trashBin];
    [self.toolbarView addSubview:self.toolBar];
    [self.view bringSubviewToFront:self.toolbarView];
    currentLecture = [[Lecture alloc] initWithName:@"Lecture001"];
}

-(void)loadNotes:(NSMutableArray *)notes{
    for(noteLoader *viewer in notes){
        if([viewer.noteType isEqualToString:@"textNote"]){
        panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        panToResize = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleResize:)];
        longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
           longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
        longPressGestureRecognizer.numberOfTouchesRequired = 3;
        longPressGestureRecognizer2.numberOfTouchesRequired = 1;
        [[viewer.view.subviews objectAtIndex:0] setText:viewer.styleText];
        [[viewer.view.subviews objectAtIndex:0] addStyles:[self coreTextStyle]];
        [[[viewer.view.subviews objectAtIndex:1] layer] setBorderWidth:3];
        [[[viewer.view.subviews objectAtIndex:1] layer] setCornerRadius:20];
        [[viewer.view.subviews objectAtIndex:1] setDelegate:self];
        [[viewer.view.subviews objectAtIndex:1] setClipsToBounds:NO];
        [viewer.view addGestureRecognizer:panToMoveNote];
        [[viewer.view.subviews objectAtIndex:1] addGestureRecognizer:longPressGestureRecognizer];
        [viewer.view addGestureRecognizer:longPressGestureRecognizer2];
        [_mainView addSubview:viewer.view];
       
        }
        else if([viewer.noteType isEqualToString:@"drawNote"]){
            panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            panToResize = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleResize:)];
            longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
            longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
            longPressGestureRecognizer.numberOfTouchesRequired = 3;
            longPressGestureRecognizer2.numberOfTouchesRequired = 1;
            [panToMoveNote setEnabled:NO];
            [panToResize setEnabled:NO];
            [[[viewer.view subviews] objectAtIndex:1] removeFromSuperview];
            [viewer.view addSubview:viewer.drawContent];
            [[[viewer.view.subviews objectAtIndex:1] layer] setBorderWidth:3];
            [[[viewer.view.subviews objectAtIndex:1] layer] setCornerRadius:20];
            [viewer.view addGestureRecognizer:panToMoveNote];
            [[viewer.view.subviews objectAtIndex:1]addGestureRecognizer:longPressGestureRecognizer];
            [viewer.view addGestureRecognizer:longPressGestureRecognizer2];
            [viewer.view addGestureRecognizer:panToResize];
            [_mainView addSubview:viewer.view];
        }
    }
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
            panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            panToResize = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleResize:)];
            longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
            longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
            longPressGestureRecognizer.numberOfTouchesRequired = 3;
            longPressGestureRecognizer2.numberOfTouchesRequired = 1;
            UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake([gesture locationInView:self.view].x, [gesture locationInView:self.view].y, 350, 150)];
            FTCoreTextView *text = [[FTCoreTextView alloc]initWithFrame:CGRectMake(outerView.frame.origin.x+10 , outerView.frame.origin.y+10 , 300, 120)];
            [text setText:@""];
            [text addStyles:[self coreTextStyle]];
            [text setUserInteractionEnabled:YES];
            UITextView *textBubble = [[UITextView alloc]initWithFrame:CGRectMake([gesture locationInView:outerView].x, [gesture locationInView:outerView].y , 310, 120)];
             //  outerView.layer.borderWidth = 3;
            [outerView addSubview:text];
            [outerView addSubview:textBubble];
            UIImageView * anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png" ]];
            [anImageView setCenter:textBubble.bounds.origin];
            [anImageView setBounds:CGRectMake([gesture locationInView:self.view].x, [gesture locationInView:self.view].y, 50, 50)];
            textBubble.textColor = [UIColor clearColor];
            [textBubble setAutocorrectionType: UITextAutocorrectionTypeNo];
            textBubble.text = @"";
            textBubble.delegate = self;
            textBubble.layer.borderWidth = 3;
            textBubble.layer.cornerRadius = 20;
            textBubble.backgroundColor = [UIColor clearColor];
            [textBubble setFont:[UIFont boldSystemFontOfSize:30]];
            [outerView addGestureRecognizer:panToMoveNote];
            [textBubble addGestureRecognizer:longPressGestureRecognizer];
            [outerView addGestureRecognizer:longPressGestureRecognizer2];
            [textBubble addSubview:anImageView];
            [textBubble setScrollEnabled:YES];
            [textBubble scrollRectToVisible:CGRectMake([gesture locationInView:self.view].x+20, [gesture locationInView:self.view].y+15, 300, 120) animated:NO];
            NSLog(@"%@",[[[self.view subviews] objectAtIndex:0] description]);
            [[[self.view subviews] objectAtIndex:1] addSubview:outerView];
            [textBubble setClipsToBounds:NO];
            [textBubble becomeFirstResponder];
                 
        }
    }
}
- (void)createNoteDraw:(UIGestureRecognizer *)gesture{
   //Initilize gesture recognizers for the view
    panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panToResize = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleResize:)];
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
    
    longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
    longPressGestureRecognizer.numberOfTouchesRequired = 3;
    longPressGestureRecognizer2.numberOfTouchesRequired = 1;

    UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake([gesture locationInView:_mainView].x+20, [gesture locationInView:_mainView].y+15, 430, 330)];
    [panToMoveNote setEnabled:NO];
    [panToResize setEnabled:NO];
    DrawView *lineDrawView = [[DrawView alloc]initWithFrame:CGRectMake([gesture locationInView:outerView].x + 20, [gesture locationInView:outerView].y + 15, 400, 300)];
    lineDrawView.userInteractionEnabled = YES;
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
    //Do not change the order in which the subviews and gestures are added
    [outerView addGestureRecognizer:panToMoveNote];
    [lineDrawView addGestureRecognizer:longPressGestureRecognizer];
    [outerView addGestureRecognizer:longPressGestureRecognizer2];
    [lineDrawView addSubview:anImageView];
    [outerView addGestureRecognizer:panToResize];
    [outerView addSubview:resizeView];
    [outerView addSubview:lineDrawView];
    [[[self.view subviews] objectAtIndex:1] addSubview:outerView];
  
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
   if(_isCreatingNote){
    [gestureRecognizer.view setFrame:CGRectMake([gestureRecognizer locationInView:_mainView].x, [gestureRecognizer locationInView:_mainView].y, [[[[gestureRecognizer view] subviews] objectAtIndex:0] size].width+50, [[[[gestureRecognizer view] subviews] objectAtIndex:0] size].height+50)];
       if(CGRectContainsPoint(self.trashBin.frame, gestureRecognizer.view.frame.origin)){
        [gestureRecognizer.view removeFromSuperview];
           return;
       }
    
   }
    else if(_isDrawing)
    {
        [gestureRecognizer.view setFrame:CGRectMake([gestureRecognizer locationInView:_mainView].x, [gestureRecognizer locationInView:_mainView].y, 50, 50)];
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
      [temp setFrame:CGRectMake([gestureRecognizer locationInView:gestureRecognizer.view].x, [gestureRecognizer locationInView:gestureRecognizer.view].y, 310, 120)];
        [tempView setFrame:CGRectMake([gestureRecognizer locationInView:gestureRecognizer.view].x-20, [gestureRecognizer locationInView:gestureRecognizer.view].y-20, 300, 120)];
        CGRect frame = temp.frame;
        frame.size.height = temp.contentSize.height;
        temp.frame = frame;
        tempView.frame = frame;
        [gestureRecognizer.view addSubview:tempView];
        [gestureRecognizer.view addSubview:temp];
        [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, temp.frame.size.width, temp.frame.size.height)];
        
    }
    else if((_isDrawing)&&([[[[gestureRecognizer view] subviews] objectAtIndex:1] isKindOfClass:[DrawView class]])&&(gestureRecognizer.view.frame.size.width==50))
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
     CGRect frame = textView.frame;
    if(!isBackSpacePressed&&(textView.text.length==textView.selectedRange.location)&&(textView.selectedRange.location>0)){
     char tempchar = [textView.text characterAtIndex:[textView.text length]-1];
    [[[textView.superview  subviews] objectAtIndex:0] setText:[NSString stringWithFormat:@"%@%@%c%@",temp.text,startTag,tempchar,endTag]];
    //textView.textColor = [UIColor clearColor];
   
    frame.size.height = textView.contentSize.height;
        frame.size.width = textView.contentSize.width;
    frame.origin = textView.frame.origin;
    textView.frame = frame;
    [textView.superview setFrame:CGRectMake(textView.superview.frame.origin.x, textView.superview.frame.origin.y, textView.frame.size.width+20, textView.frame.size.height+20)];
   [[[textView.superview  subviews] objectAtIndex:0] setFrame:CGRectMake(textView.frame.origin.x+10, textView.frame.origin.y+10, 300, textView.frame.size.height)];
   [[[textView.superview  subviews] objectAtIndex:1] becomeFirstResponder];
     }
    
    if((!isBackSpacePressed)&&(textView.text.length>textView.selectedRange.location)&&(textView.selectedRange.location>0)){
        NSRange preRange = NSMakeRange(0, (textView.selectedRange.location-1)*10);
        NSRange postRange = NSMakeRange((textView.selectedRange.location-1)*10, (textView.text.length-textView.selectedRange.location)*10);
        NSString *preText = [temp.text substringWithRange:preRange];
        NSString *postText = [temp.text substringWithRange:postRange];
        char tempchar = [textView.text characterAtIndex:textView.selectedRange.location-1];
        [[[textView.superview  subviews] objectAtIndex:0] setText:[NSString stringWithFormat:@"%@%@%c%@%@",preText,startTag,tempchar,endTag,postText]];
        [[[textView.superview  subviews] objectAtIndex:0] setNeedsDisplay];
        frame.size.height = textView.contentSize.height;
        frame.size.width = textView.contentSize.width;
        frame.origin = textView.frame.origin;
        textView.frame = frame;
        [textView.superview setFrame:CGRectMake(textView.superview.frame.origin.x, textView.superview.frame.origin.y, textView.frame.size.width+20, textView.frame.size.height+20)];
        [[[textView.superview  subviews] objectAtIndex:0] setFrame:CGRectMake(textView.frame.origin.x+10, textView.frame.origin.y+10, 300, textView.frame.size.height)];
        [[[textView.superview  subviews] objectAtIndex:1] becomeFirstResponder];
    }
  }

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
  FTCoreTextView *temp =  [[textView.superview  subviews] objectAtIndex:0];
    if((text.length<=0)&&(textView.selectedRange.location>0))
    {
       isBackSpacePressed = TRUE;
        if(textView.selectedRange.location==textView.text.length){
        NSRange selectedRange = NSMakeRange(0, (temp.text.length - startTag.length-endTag.length-1));
        NSString *str = [temp.text substringWithRange:selectedRange];
       // NSLog(@"%@",str);
        [[[textView.superview  subviews] objectAtIndex:0] setText:str];
        [[[textView.superview  subviews] objectAtIndex:0] setNeedsDisplay];
        [textView becomeFirstResponder];
        return true;
        }
        else{
           NSRange preRange = NSMakeRange(0, (textView.selectedRange.location-1)*10);
           NSRange postRange = NSMakeRange((textView.selectedRange.location)*10, ((textView.text.length-textView.selectedRange.location)*10));
            NSString *preText = [temp.text substringWithRange:preRange];
            NSString *postText = [temp.text substringWithRange:postRange];
            [[[textView.superview  subviews] objectAtIndex:0] setText:[preText stringByAppendingString:postText]];
            [[[textView.superview  subviews] objectAtIndex:0] setNeedsDisplay];
            [textView becomeFirstResponder];

        }
    }
    else{
        isBackSpacePressed = FALSE;
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notes"
                                                    message:@"Draw Note Selected" delegate:self cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    
    //note above delegate property
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notes"
                                                    message:@"Text Note Selected" delegate:self cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
     [alert show];
}

- (IBAction)resizeDraw:(id)sender {
}
- (IBAction)setBlueColor:(id)sender {
    textColor = [UIColor blueColor];
    startTag = @"<CB>";
    endTag = @"</CB>";
}
- (IBAction)setYellowColor:(id)sender {
    textColor = [UIColor yellowColor];
    startTag = @"<CY>";
    endTag = @"</CY>";
}

- (IBAction)setRedColor:(id)sender {
    textColor = [UIColor redColor];
    startTag = @"<CR>";
    endTag = @"</CR>";
}
- (NSArray *)coreTextStyle{
    NSMutableArray *result = [NSMutableArray array];
    FTCoreTextStyle *boldStyle = [FTCoreTextStyle new];
    boldStyle.name = @"FB";
    boldStyle.font = [UIFont boldSystemFontOfSize:30];
    [result addObject:boldStyle];
    FTCoreTextStyle *blueColor = [FTCoreTextStyle new];
    [blueColor setName:@"CB"];
    blueColor.font = [UIFont boldSystemFontOfSize:30];
    [blueColor setColor:[UIColor blueColor]];
    [result addObject:blueColor];
    FTCoreTextStyle *redColor = [FTCoreTextStyle new];
    [redColor setName:@"CR"];
     redColor.font = [UIFont boldSystemFontOfSize:30];
    [redColor setColor:[UIColor redColor]];
    [result addObject:redColor];
    FTCoreTextStyle *yellowColor = [FTCoreTextStyle new];
    [yellowColor setName:@"CY"];
    [yellowColor setColor:[UIColor yellowColor]];
    yellowColor.font = [UIFont boldSystemFontOfSize:30];
   [result addObject:yellowColor];
    FTCoreTextStyle *blackColor = [FTCoreTextStyle new];
    [blackColor setName:@"CD"];//D-> Default color
    [blackColor setColor:[UIColor blackColor]];
    blackColor.font = [UIFont boldSystemFontOfSize:30];
    [result addObject:blackColor];
    return result;

}
#pragma mark Child View Controller Calls

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"will have new parent %@", parent);
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"new parent %@", parent);
    [self.toolbarView setHidden:NO];
}

- (void)willSaveState
{
   
    NSLog(@"Will save state");
    NSMutableArray *notes = [[NSMutableArray alloc] init];
    for(UIView *saver in [[[self.view subviews] objectAtIndex:1] subviews])
    {
        if(![saver isKindOfClass:[UIToolbar class]]&&![saver isKindOfClass:[UIImageView class]])
            {
                
                if([[[saver subviews] objectAtIndex:1] isKindOfClass:[DrawView class]]){
                    noteLoader *loader = [[noteLoader alloc] init:saver type:@"drawNote"];
                [notes addObject:loader];
                   
                }
                else if([[[saver subviews] objectAtIndex:0] isKindOfClass:[FTCoreTextView class]])
                {
                    noteLoader *loader = [[noteLoader alloc] init:saver type:@"textNote"];
                    [notes addObject:loader];
                }
            }
    }
    
    currentDocument.notes = notes;
    currentDocument.lecture = currentLecture;
   [FileManager saveDocument:currentDocument];
}

- (void)didSaveState
{
    NSLog(@"Did save state: %@", self.description);
}

- (void)willLeaveActiveState
{
    NSLog(@"Will leave active state");
      
}


- (void)didLeaveActiveState
{
    NSLog(@"Did leave active state: %@", self.description);
    [self.toolBar setHidden:YES];
}

- (UIView *)contentView
{
    return _mainView;
}


@end
