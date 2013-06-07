//
//  LineDrawViewController.h
//  AccessLecture
//
//  Created by Piper Chester on 6/6/13.
//
//

#import <UIKit/UIKit.h>

@interface LineDrawView : UIView

@property (nonatomic) UIColor *brushColor;
@property (nonatomic) UIBezierPath *bezierPath;
@property (nonatomic) UIBezierPath *bezierPath2;
@property (nonatomic) UIBezierPath *bezierPath3;
@property (nonatomic) UIBezierPath *bezierPath4;
@property (nonatomic) UIBezierPath *bezierPath5;
@property (nonatomic) NSInteger currentPath;

@end
