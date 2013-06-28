//
//  LineDrawViewController.h
//  AccessLecture
//
//  Created by Piper Chester on 6/6/13.
//
//

#import <UIKit/UIKit.h>
#import "AMBezierPath.h"

@interface DrawView : UIView

- (void)clearAllPaths;

@property NSMutableArray *paths;
@property float penSize;
@property UIColor *penColor;

@end
