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
    return CGPointMake(point.x, ( self.bounds.size.height - point.y ) );
}

- (void)drawBulkUpdate:(NSArray *)dataPack
{
    update = [NSMutableArray array];
    for (id data in dataPack) {
        if ([[data valueForKeyPath:@"action"] isEqualToString:@"moveTo"]) {
            UIBezierPath *new = [UIBezierPath bezierPath];
            [new setLineWidth:3.0];
            [new setLineCapStyle:kCGLineCapRound];
            [new moveToPoint:[self pointFromData:data]];
            [update addObject:new];
        } else {
            [(UIBezierPath *)[update lastObject] addLineToPoint:[self pointFromData:data]];
        }
    }
    [self setNeedsDisplay];
}

- (void)addPointToLine:(CGPoint)point
{
    [(UIBezierPath *)[update lastObject] addLineToPoint:[self flipForCordinateSpace:point]];
}

- (void)startNewLineAtPoint:(CGPoint)point
{
    UIBezierPath *new = [UIBezierPath bezierPath];
    [new setLineWidth:3.0];
    [new setLineCapStyle:kCGLineCapRound];
    [new moveToPoint:[self flipForCordinateSpace:point]];
    [update addObject:new];
}

- (void)drawRect:(CGRect)rect
{
    [self setBackgroundColor:[UIColor clearColor]]; // Ensuring background isn't white.
    [[UIColor blackColor] setStroke];
    for (UIBezierPath *path in update) {
        [path stroke];
    }
}

@end
