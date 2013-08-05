//
//  NotesViewController.m
//  AccessLecture
//
//  Created by Student on 6/26/13.
//
//

#import "NotesViewController.h"

static NSString * VIEW_KEY = @"position_key";   // key to code for the position
static NSString * TEXT_KEY = @"text_key";         // key to code for the image
static NSString * TYPE_KEY = @"type_key";
static NSString * DRAW_KEY = @"draw_key";


@interface noteLoader:NSObject
   

@property(nonatomic) UIView *view;
@property(nonatomic) NSString *styleText;
@property(nonatomic) NSString *noteType;
@property(nonatomic) DrawView *drawContent;
@end

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
@implementation NotesViewController
#define RED_TAG 111
#define GREEN_TAG 112
#define BLUE_TAG 113
#define BLACK_TAG 114
#define HILIGHT_TAG 115
#define ERASER_TAG 116
#define COLOR_HEIGHT 85
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
   //assign this value from stream view controller lecture name
   [self.toolbarView setHidden:YES];
    [self.trashBin setHidden:YES];
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
    drawcolor = [UIColor blackColor];
    isBackSpacePressed = FALSE;
    // Do any additional setup after loading the view from its nib.
        if((!isOpened)){
        [self initializeView];
    //  [self loadNotes:currentDocument.notes];
        [self.trashBin setHidden:NO];
        isOpened = YES;
    }
    // Clear view
    [self.view setBackgroundColor:[UIColor clearColor]];
    
}
/**
 * Inititlizes main notes view which contains subviews for text notes and  drawing notes
 * 
 *
 */
-(void)initializeView{
    
    _mainView = [[UIView alloc] initWithFrame:self.view.frame];
   
    
    [self.view addSubview:_mainView];
    [self.view addSubview:self.toolbarView];
    [self initColorSegmentedControl];
    [self.view addSubview:self.trashBin];
    //[self.toolbarView addSubview:self.toolBar];
   // [self.view bringSubviewToFront:self.toolbarView];
    currentLecture = [[Lecture alloc] initWithName:@"Lecture001"];
    
}

- (void)initColorSegmentedControl
{
    NSArray *segments = [[NSArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", nil];
    _notesPanelControl = [[UISegmentedControl alloc] initWithItems:segments];
    [_notesPanelControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_notesPanelControl setFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width - 400, COLOR_HEIGHT)];
    [_notesPanelControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Indices change; need to tag the segments before rendering.
    [_notesPanelControl setTag:RED_TAG forSegmentAtIndex:0];
    [_notesPanelControl setTag:GREEN_TAG forSegmentAtIndex:1];
    [_notesPanelControl setTag:BLUE_TAG forSegmentAtIndex:2];
    [_notesPanelControl setTag:BLACK_TAG forSegmentAtIndex:3];
    [_notesPanelControl setTag:HILIGHT_TAG forSegmentAtIndex:4];
   
    
    [_notesPanelControl setTintColor:[UIColor redColor] forTag:RED_TAG];
    [_notesPanelControl setTintColor:[UIColor greenColor] forTag:GREEN_TAG];
    [_notesPanelControl setTintColor:[UIColor blueColor] forTag:BLUE_TAG];
    [_notesPanelControl setTintColor:[UIColor blackColor] forTag:BLACK_TAG];
    [_notesPanelControl setTintColor:[UIColor yellowColor] forTag:HILIGHT_TAG];
    
    [self.toolbarView addSubview:_notesPanelControl];
    [self.view bringSubviewToFront:self.toolbarView];
}
- (void)segmentChanged:(id)sender
{
    if(_isDrawing){
    switch ([_notesPanelControl selectedSegmentIndex]) {
        case 0:
           drawcolor = [UIColor redColor];
            break;
        case 1:
             drawcolor = [UIColor greenColor];
            break;
        case 2:
            drawcolor = [UIColor blueColor];
            break;
        case 3:
             drawcolor = [UIColor blackColor];
            break;
        case 4:
            drawcolor = [UIColor yellowColor];
            break;
        
        default:
            break;
    }
    for(DrawView *draws in [[[self.view subviews] objectAtIndex:1] subviews ]){
        if([[[draws subviews] objectAtIndex:1] isKindOfClass:[DrawView class]]){
            [[[draws subviews] objectAtIndex:1]setPenColor:drawcolor];
            [[[draws subviews] objectAtIndex:1]setPenSize:2];
        }
    }
    }
    else if(_isCreatingNote){
        switch ([_notesPanelControl selectedSegmentIndex]) {
            case 0:
                textColor = [UIColor redColor];
                startTag = @"<CR>";
                endTag = @"</CR>";
                break;
            case 1:
                textColor = [UIColor greenColor];
                startTag = @"<CG>";
                endTag = @"</CG>";
                break;
            case 2:
                textColor = [UIColor blueColor];
                startTag = @"<CB>";
                endTag = @"</CB>";
                break;
            case 3:
                textColor = [UIColor blackColor];
                startTag = @"<CD>";
                endTag = @"</CD>";
                break;
            case 4:
                textColor = [UIColor yellowColor];
                startTag = @"<CY>";
                endTag = @"</CY>";
                break;
           
            default:
                break;
        }
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_notesPanelControl setFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width - 400, COLOR_HEIGHT)];
}

/**
 * Loads saved notes from the current document's notes array
 * 
 *
 */
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
            [viewer.view.layer setBorderWidth:3];
            [[[viewer.view.subviews objectAtIndex:0] layer] setBorderWidth:3];
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
# pragma mark - TextNote Creation
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
            [text setText:@"<CD></CD>"];
            [text addStyles:[self coreTextStyle]];
            [text setUserInteractionEnabled:YES];
            UITextView *textBubble = [[UITextView alloc]initWithFrame:CGRectMake([gesture locationInView:outerView].x, [gesture locationInView:outerView].y , 310, 120)];
           // outerView.layer.borderWidth = 3;
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
            [[[self.view subviews] objectAtIndex:1] addSubview:outerView];
            [textBubble setClipsToBounds:NO];
            [textBubble becomeFirstResponder];
                 
        }
    }
}
# pragma mark - DrawNote Creation
- (void)createNoteDraw:(UIGestureRecognizer *)gesture
{
   //Initilize gesture recognizers for the view
   
    panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panToResize = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleResize:)];
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
        longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
    longPressGestureRecognizer.numberOfTouchesRequired = 3;
    longPressGestureRecognizer2.numberOfTouchesRequired = 1;
    //Outerview contains lineDrawView for drawing, anImageView for displaying pin, and resizeView  for displaying red resize circle
    UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake([gesture locationInView:_mainView].x+20, [gesture locationInView:_mainView].y+15, 430, 330)];
    [panToMoveNote setEnabled:NO];
    [panToResize setEnabled:YES];
    DrawView *lineDrawView = [[DrawView alloc]initWithFrame:CGRectMake([gesture locationInView:outerView].x + 20, [gesture locationInView:outerView].y + 15, 400, 300)];
    [lineDrawView setPenColor:drawcolor];
    lineDrawView.userInteractionEnabled = YES;
    outerView.layer.borderWidth = 3;
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
    [outerView addGestureRecognizer:panToResize];
    [lineDrawView addSubview:anImageView];
    [outerView addSubview:resizeView];
    [outerView addSubview:lineDrawView];
    [[[self.view subviews] objectAtIndex:1] addSubview:outerView];
     //NSLog(@"%u", [[[[self.view subviews] objectAtIndex:1] subviews] indexOfObject:outerView]);
    drawIndex = [[[[self.view subviews] objectAtIndex:1] subviews] indexOfObject:outerView];
  
}
# pragma mark - Handle pan for text and draw note
- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
   if(_isCreatingNote){
      
       [gestureRecognizer.view setFrame:CGRectMake([gestureRecognizer locationInView:_mainView].x, [gestureRecognizer locationInView:_mainView].y, [[[[gestureRecognizer view] subviews] objectAtIndex:0] size].width+50, [[[[gestureRecognizer view] subviews] objectAtIndex:0] size].height+50)];
       if(CGRectContainsPoint(self.trashBin.frame, gestureRecognizer.view.frame.origin)){
        [gestureRecognizer.view removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notes"
                                                           message:@"Note deleted" delegate:self cancelButtonTitle: @"OK"
                                                 otherButtonTitles: nil];
           [alert show];
                    return;
       }
   
   }
    else if(_isDrawing)
    {
        [gestureRecognizer.view setFrame:CGRectMake([gestureRecognizer locationInView:_mainView].x, [gestureRecognizer locationInView:_mainView].y, 50, 50)];
        if(CGRectContainsPoint(self.trashBin.frame, gestureRecognizer.view.frame.origin)){
            [gestureRecognizer.view removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notes"
                                                            message:@"Note deleted" delegate:self cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
}
# pragma mark - Handle resize for draw note
- (void)handleResize:(UIPanGestureRecognizer *)gestureRecognizer
{
    if((_isDrawing)){
        drawIndex = [[[[self.view subviews] objectAtIndex:1] subviews] indexOfObject:gestureRecognizer.view];
        UIImageView *temp = [[[gestureRecognizer view] subviews] objectAtIndex:0];
        UIImageView *tempImage = [[[gestureRecognizer view] subviews] objectAtIndex:1];
        [[[[gestureRecognizer view] subviews] objectAtIndex:0] removeFromSuperview];
        [[[[gestureRecognizer view] subviews] objectAtIndex:0] removeFromSuperview];
        [gestureRecognizer.view addSubview:temp];
        [gestureRecognizer.view addSubview:tempImage];
        [tempImage setBounds:gestureRecognizer.view.bounds];
        [tempImage setFrame:CGRectMake(_mainView.frame.origin.x,_mainView.frame.origin.y,[gestureRecognizer locationInView:gestureRecognizer.view].x, [gestureRecognizer locationInView:gestureRecognizer.view].y)];
        CGPoint point = CGPointMake(gestureRecognizer.view.frame.size.width-20, gestureRecognizer.view.frame.size.height-20);
        [temp setCenter:point];
        [temp setBounds:CGRectMake([gestureRecognizer locationInView:self.view].x, [gestureRecognizer locationInView:self.view].y, 50, 50)];
        [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, [gestureRecognizer locationInView:gestureRecognizer.view].x+20, [gestureRecognizer locationInView:gestureRecognizer.view].y+20)];
        
    }
}
# pragma mark - Hide notes on long tap using three fingers
- (void)longPressToRemoveNote:(UILongPressGestureRecognizer *)gestureRecognizer
{

    if(_isCreatingNote){
        [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, 5, 5)];
        [gestureRecognizer.view.superview setFrame:CGRectMake(gestureRecognizer.view.superview.frame.origin.x, gestureRecognizer.view.superview.frame.origin.y, 50, 50)];
       [[[gestureRecognizer.view.superview subviews] objectAtIndex:0] setFrame:CGRectMake(gestureRecognizer.view.superview.frame.origin.x, gestureRecognizer.view.superview.frame.origin.y, 5, 5)];
    }
    else if(_isDrawing){
    
        [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, 5, 5)];
        [gestureRecognizer.view.superview setFrame:CGRectMake(gestureRecognizer.view.superview.frame.origin.x, gestureRecognizer.view.superview.frame.origin.y, 50, 50)];
        [[gestureRecognizer.view.superview.subviews  objectAtIndex:0] setHidden:YES];
        for(UIGestureRecognizer *recognizer in gestureRecognizer.view.superview.gestureRecognizers){
                   if([recognizer isKindOfClass:[UIPanGestureRecognizer class]]){
              [recognizer setEnabled:YES];
                        }
      }
    [[gestureRecognizer.view.superview.gestureRecognizers objectAtIndex:2] setEnabled:NO];
    }
    
} 
# pragma mark - Display hidden note by long press using one finger on pin
- (void)longPressToDisplayNote:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if((_isCreatingNote)&&([[[[gestureRecognizer view] subviews] objectAtIndex:1] isKindOfClass:[UITextView class]])&&(gestureRecognizer.view.frame.size.width==50)){
        NSLog(@"Reached");
        UITextView *temp = [[[gestureRecognizer view] subviews] objectAtIndex:1];
        FTCoreTextView *tempView = [[[gestureRecognizer view] subviews] objectAtIndex:0];
        [[[[gestureRecognizer view] subviews] objectAtIndex:1] removeFromSuperview];
        [[[[gestureRecognizer view] subviews] objectAtIndex:0] removeFromSuperview];
        [temp setFrame:CGRectMake([gestureRecognizer locationInView:gestureRecognizer.view].x, [gestureRecognizer locationInView:gestureRecognizer.view].y, 310, 120)];
        [tempView setFrame:CGRectMake([gestureRecognizer locationInView:gestureRecognizer.view].x, [gestureRecognizer locationInView:gestureRecognizer.view].y, 300, 120)];
        CGRect frame = temp.frame;
        frame.size.height = temp.contentSize.height;
        temp.frame = frame;
        tempView.frame = frame;
        [gestureRecognizer.view addSubview:tempView];
        [gestureRecognizer.view addSubview:temp];
        [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, temp.frame.size.width, temp.frame.size.height)];
        
        
    }
    else if((_isDrawing)&&([[[[gestureRecognizer view] subviews] objectAtIndex:1] isKindOfClass:[DrawView class]])&&(gestureRecognizer.view.frame.size.width==50)){
      
      
        [[gestureRecognizer.view.subviews objectAtIndex:0] setHidden:NO];
        UIImageView *temp = [[[gestureRecognizer view] subviews] objectAtIndex:1];
        [[[[gestureRecognizer view] subviews] objectAtIndex:1] removeFromSuperview];
        [temp setFrame:CGRectMake(temp.frame.origin.x, temp.frame.origin.y, [[gestureRecognizer.view.subviews  objectAtIndex:0] center].x, [[gestureRecognizer.view.subviews  objectAtIndex:0] center].y)];
        [gestureRecognizer.view addSubview:temp];
         [gestureRecognizer.view setFrame:CGRectMake(gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y, [[gestureRecognizer.view.subviews  objectAtIndex:0] center].x+25, [[gestureRecognizer.view.subviews  objectAtIndex:0] center].y+25)];
        for(UIGestureRecognizer *recognizer in gestureRecognizer.view.gestureRecognizers){
            
            if([recognizer isKindOfClass:[UIPanGestureRecognizer class]]){
            [recognizer setEnabled:NO];
            }
        }
      [[gestureRecognizer.view.gestureRecognizers objectAtIndex:2] setEnabled:YES];
    }    
}

# pragma mark - Render FTCoreTextView behind transparent textView
- (void)textViewDidChange:(UITextView *)textView
{
     FTCoreTextView *temp =  [[textView.superview  subviews] objectAtIndex:0];
     CGRect frame = textView.frame;
    if(!isBackSpacePressed&&(textView.text.length==textView.selectedRange.location)&&(textView.selectedRange.location>0)){
     char tempchar = [textView.text characterAtIndex:[textView.text length]-1];
    [[[textView.superview  subviews] objectAtIndex:0] setText:[NSString stringWithFormat:@"%@%@%c%@",temp.text,startTag,tempchar,endTag]];
    //textView.textColor = [UIColor clearColor];
      //  [textView setSelectedRange:NSMakeRange(0, 5)];
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

# pragma mark - Handle backspace press events
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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
    else if((text.length<=0)&&(textView.selectedRange.location==0)){
        [[[textView.superview  subviews] objectAtIndex:0] setText:@"<CD></CD>"];
        [[[textView.superview  subviews] objectAtIndex:0] setNeedsDisplay];
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
   
    [self viewDidLoad];
    [_mainView addGestureRecognizer:_tapToCreateNote];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notes"
                                                    message:@"Draw Note Selected" delegate:self cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];

}


- (IBAction)createTextNote:(id)sender {
   
    _isDrawing = NO;
    _isCreatingNote = YES;
    _tapToCreateNote = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                    :@selector(createNoteText:)];
    _tapToCreateNote.numberOfTapsRequired = 2;
    
    //[self.view addGestureRecognizer:_tapToCreateNote];
    [self viewDidLoad];
     [_mainView addGestureRecognizer:_tapToCreateNote];
  [_mainView addGestureRecognizer:_tapToCreateNote];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notes"
                                                    message:@"Text Note Selected" delegate:self cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
     [alert show];
}


- (IBAction)undoButtonPressed:(id)sender
{
    //[[[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:drawIndex] subviews] objectAtIndex:1] => is the drawView currently in focus
    if(_isDrawing&&([[[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:drawIndex] subviews] count]!=0)){
    if ([[[[[[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:drawIndex] subviews] objectAtIndex:1] shapes] lastObject] isMemberOfClass:[UIImageView class]]){
        [[[[[[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:drawIndex] subviews] objectAtIndex:1] shapes] lastObject] removeFromSuperview];
    } else if ([[[[[[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:drawIndex] subviews] objectAtIndex:1] shapes] lastObject] isMemberOfClass:[AMBezierPath class]]){
        [[[[[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:drawIndex] subviews] objectAtIndex:1] paths] removeLastObject]; // Removing AMBezierPaths...
    }
    
    [[[[[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:drawIndex] subviews] objectAtIndex:1] shapes] removeLastObject];
    [[[[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:drawIndex] subviews] objectAtIndex:1] setNeedsDisplay];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notes"
                                                        message:@"Nothing to undo! Please select draw mode." delegate:self cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    }

- (IBAction)erasePressed:(id)sender
{
    if(_isDrawing){
    [[[[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:drawIndex] subviews] objectAtIndex:1] setPenColor:[UIColor whiteColor]];
    [[[[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:drawIndex] subviews] objectAtIndex:1] setPenSize:20];
    }
        else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notes"
                                                        message:@"Nothing to erase! Please select draw mode." delegate:self cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
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

    FTCoreTextStyle *greenColor = [FTCoreTextStyle new];
    [greenColor setName:@"CG"];//D-> Default color
    [greenColor setColor:[UIColor greenColor]];
    greenColor.font = [UIFont boldSystemFontOfSize:30];
    [result addObject:greenColor];
    return result;

}
#pragma mark Child View Controller Calls

- (void)willMoveToParentViewController:(UIViewController *)parent
{

}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [self.toolbarView setHidden:NO];
}

- (void)willSaveState
{
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
 
}

- (void)willLeaveActiveState
{
      
}


- (void)didLeaveActiveState
{
    [self.toolbarView setHidden:YES];
   // [self.trashBin setHidden:YES];

}

- (UIView *)contentView
{
   _mainView.frame = self.view.frame;
    return _mainView;
}



@end
