//
//  UISegmentedControlExtension.h
//  AccessLecture
//
//  Created by Piper Chester on 6/12/13.
//
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl(CustomTintExtension)

-(void)setTag:(NSInteger)tag forSegmentAtIndex:(NSUInteger)segment;
-(void)setTintColor:(UIColor*)color forTag:(NSInteger)aTag;
-(void)setShadowColor:(UIColor*)color forTag:(NSInteger)aTag;

@end
