//
//  MTFlowerMenu.h
//  AccessLecture
//
//  Created by Michael on 1/13/14.
//
//

#import <UIKit/UIKit.h>

@interface MTFlowerMenu : UIControl

- (void)longPressGesture:(UILongPressGestureRecognizer *)reg;

@property NSString *selectedIdentifier;

@end