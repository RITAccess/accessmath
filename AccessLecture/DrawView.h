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

@property NSMutableArray *paths, *shapes;
@property float penSize;
@property UIColor *penColor;
@property bool shapeSelected;

@property UITapGestureRecognizer *tapStamp;
@property UIPanGestureRecognizer *fingerDrag;
@property NSMutableString *buttonString;

- (void)tapToStamp:(UITapGestureRecognizer *)gesture;

@end
