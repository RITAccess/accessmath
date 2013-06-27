//
//  LineDrawViewController.h
//  AccessLecture
//
//  Created by Piper Chester on 6/6/13.
//
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

- (void)clearAllPaths;

// Bezier Paths
@property UIBezierPath *redBezierPath;
@property UIBezierPath *greenBezierPath;
@property UIBezierPath *blueBezierPath;
@property UIBezierPath *blackBezierPath;
@property UIBezierPath *yellowBezierPath;
@property UIBezierPath *eraserBezierPath;
@property NSInteger currentPath;
@property UIBezierPath *selectedPath;

@end
