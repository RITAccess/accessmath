//
//  TextNoteView.m
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import "TextNoteView.h"

@implementation TextNoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect boarder = CGRectMake(5, 5, rect.size.width - 20, rect.size.height - 10);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGContextStrokeRect(context, boarder);
}

@end
