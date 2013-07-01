//
//  StreamDrawing.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/28/13.
//
//

#import "StreamDrawing.h"

@implementation StreamDrawing {
    NSMutableArray *update;
}

- (CGPoint)pointFromData:(id)data
{
    return [self flipForCordinateSpace:CGPointMake([[data valueForKeyPath:@"x"] floatValue], [[data valueForKeyPath:@"y"] floatValue])];
}

- (CGPoint)flipForCordinateSpace:(CGPoint)point
{
    float height = self.frame.size.height;
    return CGPointMake(point.x, height - point.y);
}

- (void)drawBulkUpdate:(NSArray *)dataPack
{
    update = [NSMutableArray array];
    for (id data in dataPack) {
        if ([[data valueForKeyPath:@"action"] isEqualToString:@"moveTo"]) {
            UIBezierPath *new = [UIBezierPath bezierPath];
            [new moveToPoint:[self pointFromData:data]];
            [update addObject:new];
        } else {
            [(UIBezierPath *)[update lastObject] addLineToPoint:[self pointFromData:data]];
        }
    }
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] setStroke];
    for (UIBezierPath *path in update) {
        [path stroke];
    }
}

@end
