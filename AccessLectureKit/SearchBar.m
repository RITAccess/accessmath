//
//  SearchBar.m
//  AccessLecture
//
//  Created by Arun on 2/9/16.
//
//

#import "SearchBar.h"

@implementation SearchBar

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    UIView *searchTextFieldView;
    
    for (UIView *aView in [[self.subviews objectAtIndex:0] subviews]) {
        
        if ([aView isKindOfClass:[UITextField class]]) {
            searchTextFieldView = aView;
            break;
        }
    }
    
    [searchTextFieldView removeFromSuperview];
    
    self.searchBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(5.0, 5.0, self.frame.size.width - 10.0 , self.frame.size.height - 10.0)];
    self.searchBarTextField.font = [UIFont systemFontOfSize:48];
    self.searchBarTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBarTextField.delegate = self;
    self.searchBarTextField.opaque = NO;
    self.searchBarTextField.placeholder = @"Search";
    self.searchBarTextField.backgroundColor = [UIColor whiteColor];
    [[self.subviews objectAtIndex:0] addSubview:self.searchBarTextField];
    
    self.searchBarTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.searchBarTextField.layer.borderWidth = 7.0;
    
    //Padding the view so the placeholder is not hidden
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.searchBarTextField.leftView = paddingView;
    self.searchBarTextField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *searchString;
    
    if (range.length == 0) {
        searchString = [textField.text stringByAppendingFormat:@"%@", string];
    } else {
        searchString = [textField.text substringToIndex:textField.text.length - range.length];
    }
    
    self.text = searchString;
    [self.delegate searchBar:self textDidChange:searchString];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = @"";
    self.searchBarTextField.text = @"";
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

@end
