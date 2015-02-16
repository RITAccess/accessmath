//
//  DocumentCreator.m
//  AccessLecture
//
//  Created by Michael on 1/10/14.
//
//

#import <RPFloatingPlaceholderTextField.h>
#import "DocumentCreator.h"
#import "StatusMark.h"
#import "FileMangerViewController.h"
#import "NSString+TrimmingAdditions.h"

@interface DocumentCreator ()

@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *docName;

@property (strong, nonatomic) StatusMark *titleValid;
@property (weak, nonatomic) IBOutlet UILabel *titleSubtext;

@end

@implementation DocumentCreator

- (id)init
{
    self = [super initWithNibName:@"DocumentCreator" bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleValid = [[StatusMark alloc] initWithPoint:CGPointMake(72, 125)];
    _titleValid.hidden = YES;
    _titleSubtext.hidden = YES;
    [self.view addSubview:_titleValid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark Animations

- (void)validTitleAnimation
{
    [_titleValid setNeedsDisplay];
    _titleSubtext.hidden = NO;
    _titleSubtext.alpha = 0.0;
    _titleValid.hidden = NO;
    _titleValid.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:0.8 options:UIViewAnimationCurveEaseOut animations:^{
        _titleValid.transform = CGAffineTransformIdentity;
        _titleSubtext.alpha = 1.0;
    } completion:nil];
}

#pragma mark IBActions

- (IBAction)finishedEditing:(id)sender
{
    _docName.text = [_docName.text stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    // Build Regex
    NSRange range = NSMakeRange(0, _docName.text.length);
    NSString *pattern = @"[.!@#$%^&*=+~{}\\|/<>`]";
    NSError *err;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&err];
    
    NSArray *matches = [regex matchesInString:_docName.text options:0 range:range];
    
    if (matches.count == 0) {
        _titleValid.isGood = YES;
        _titleSubtext.text = [NSString stringWithFormat:@"Document will be saved as %@.lec", _docName.text];
    } else {
        _titleValid.isGood = NO;
        _titleSubtext.text = @"Name cannot contain invalid characters.";
    }
    [self validTitleAnimation];
}

- (IBAction)createLecture:(id)sender
{
    // Check all valid then create
    [(FileMangerViewController *)self.parentViewController createDocumentNamed:_docName.text];
}

@end
