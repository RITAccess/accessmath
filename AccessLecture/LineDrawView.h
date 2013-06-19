//
//  LineDrawViewController.h
//  AccessLecture
//
//  Created by Piper Chester on 6/6/13.
//
//

#import <UIKit/UIKit.h>

@interface LineDrawView : UIView

- (void)clearAllPaths;
+ (void)setLineWidth:(NSInteger)newLineWidth;

@property (nonatomic) UIBezierPath *bezierPath;
@property (nonatomic) UIBezierPath *bezierPath2;
@property (nonatomic) UIBezierPath *bezierPath3;
@property UIBezierPath *bezierPath4;
@property UIBezierPath *bezierPath5;
@property NSInteger currentPath;
@property BOOL isCreatingNote;
@property BOOL isDrawing;
@property UITapGestureRecognizer *tapToCreateNote;

@end
