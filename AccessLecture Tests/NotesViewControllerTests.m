//
//  NotesViewControllerTests.m
//  AccessLecture
//
//  Created by Student on 8/6/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "NotesViewController.h"
@interface NotesViewControllerTests : SenTestCase

@end

@implementation NotesViewControllerTests
{
     NotesViewController *testNotesViewController;
}

- (void)setUp
{
    [super setUp];
    testNotesViewController = [NotesViewController new];
    testNotesViewController.mainView =  [[UIView alloc] initWithFrame:testNotesViewController.view.frame];
    [testNotesViewController viewDidLoad];
    testNotesViewController.tapToCreateNote = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                                           :@selector(createNoteText:)];
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


-(void)testOpen{
    [testNotesViewController viewDidAppear:YES];
    STAssertEqualObjects(@"Lecture001", testNotesViewController.currentLecture.name, @"Document not loaded successfully");
}

-(void)testDrawNoteMode{
    [testNotesViewController createDrawNote:self];
     STAssertTrue(testNotesViewController.isDrawing==YES, @"Drawing Mode not enabled");
}

-(void)testTextNoteMode{
    [testNotesViewController createTextNote:self];
   // STAssertTrue(testNotesViewController.isCreatingNote==YES, @"Drawing Mode not enabled");
}

-(void)testCreateTextNote{
    [testNotesViewController createTextNote:self];
    [testNotesViewController createNoteText:testNotesViewController.tapToCreateNote];
    STAssertTrue(testNotesViewController.mainView.subviews.count == 0 , @"Text Note not created");
}
-(void)testCreateDrawNote{
    [testNotesViewController createTextNote:self];
    [testNotesViewController createNoteText:testNotesViewController.tapToCreateNote];
   // STAssertTrue(testNotesViewController.mainView.subviews.count == 0 , @"Drawing Note not created");
}
//-(void)testSave{
//    [testNotesViewController viewDidAppear:YES];
//    [testNotesViewController loadNotes:testNotesViewController.currentDocument.notes];
//    [testNotesViewController willSaveState];
//    STAssertEquals((int)testNotesViewController.currentDocument.notes.count ,0 , @"Drawing Note not created");
//}
@end
