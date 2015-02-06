//
//  NewLectureController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/26/15.
//
//

#import "NewLectureController.h"
#import "NavBackButton.h"
#import "PureLayout.h"
#import "CheckButton.h"
#import "FileManager.h"
#import "UIAlertController+Blocks.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface NewLectureController ()

@end

@implementation NewLectureController
{
    NSArray *_navigationItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *back = ({
        UIButton *b = [NavBackButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"back";
        b;
    });
    
    UIButton *done = ({
        UIButton *b = [CheckButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"done";
        b;
    });

    _navigationItems = @[back, done];
    
    [_navigationItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.navigationController.navigationBar addSubview:obj];
    }];
    
    [self.navigationController.navigationBar setNeedsUpdateConstraints];
    
}

- (void)updateViewConstraints
{
    [_navigationItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view autoSetDimensionsToSize:CGSizeMake(120, 100)];
        [view autoAlignAxis:ALAxisLastBaseline toSameAxisOfView:view.superview];
        [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0 relation:NSLayoutRelationEqual];
    }];
    
    [_navigationItems.firstObject autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_navigationItems.lastObject autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    [super updateViewConstraints];
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done
{
    [self.lectureName setEnabled:NO];
    
    NSLog(@"DEBUG: creating new lecture: %@", self.lectureName.text);
    
    [FileManager createDocumentWithName:self.lectureName.text success:^(AMLecture *current) {
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(newLectureViewController:didCreateNewLecture:)]) {
                [self.delegate newLectureViewController:self didCreateNewLecture:current];
            }
        }];
    } failure:^(NSError *error) {
        NSString *errorMsg = @"An unknown error occurred";
        if (error.code == FileManagerErrorFileExists) {
            errorMsg = @"File already excists";
        }
        [UIAlertController showAlertInViewController:self
                                           withTitle:@"Failed to create Lecture"
                                             message:errorMsg
                                   cancelButtonTitle:@"Ok"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:nil
                                            tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
                                                [self.lectureName setEnabled:YES];
                                            }];
    }];
}

@end
