//
//  MTFlowerMenu.h
//  AccessLecture
//
//  Created by Michael on 1/13/14.
//
//

#import <UIKit/UIKit.h>
#import "MTMenuItem.h"

@interface MTFlowerMenu : UIControl

@property NSString *selectedIdentifier;
@property CGPoint location;

- (void)addMenuItem:(MTMenuItem *)item;

@end
