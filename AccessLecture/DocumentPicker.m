//
//  DocumentPicker.m
//  AccessLecture
//
//  Created by Michael on 1/9/14.
//
//

#import "DocumentPicker.h"
#import "FileMangerViewController.h"

@interface DocumentPicker ()

@property (strong) NSString *docName;

@end

@implementation DocumentPicker

- (instancetype)initWithDocumentName:(NSString *)name
{
    self = [super initWithNibName:@"DocumentPicker" bundle:nil];
    if (self) {
        _docName = name;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _noteTitle.text = _docName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions

- (IBAction)loadDocument:(id)sender
{
    FileMangerViewController *parent = (FileMangerViewController *)[self parentViewController];
    [parent loadDocument:_docName];
}

@end
