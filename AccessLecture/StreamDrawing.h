//
//  StreamDrawing.h
//  AccessLecture
//
//  Created by Michael Timbrook on 6/28/13.
//
//

#import <UIKit/UIKit.h>

@interface StreamDrawing : UIView

- (void)drawBulkUpdate:(NSArray *)dataPack;
- (void)addPointToLine:(CGPoint)point;
- (void)startNewLineAtPoint:(CGPoint)point;

@end