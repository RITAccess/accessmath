//
//  MTFlowerMenu.m
//  AccessLecture
//
//  Created by Michael on 1/13/14.
//
//

#import "MTFlowerMenu.h"

#import "AddNoteView.h"

@implementation MTFlowerMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)showMenuAnimated:(BOOL)animated
{
    // Create menu items
    AddNoteView *addNote = [[AddNoteView alloc] initWithFrame:({
        CGRect frame = self.frame;
        frame.size = CGSizeMake(45, 75);
        frame;
    })];
    [self addSubview:addNote];
    
    // Animate them
    CGAffineTransform scale = CGAffineTransformMakeScale(0.0, 0.0);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(180);
    CGAffineTransform start = CGAffineTransformConcat(scale, rotation);
    addNote.transform = start;
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0.3 options:UIViewAnimationCurveEaseOut animations:^{
        addNote.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

- (void)drawRect:(CGRect)rect
{
    
}

@end
