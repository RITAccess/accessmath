#import "ShuffleNote.h"
#import "Note.h"

@interface ShuffleNote ()

// Private interface goes here.

@end

@implementation ShuffleNote

// Custom logic goes here.
- (CGPoint)location
{
    return (CGPoint) { .x = self.location_x.floatValue, .y = self.location_y.floatValue };
}

- (void)setLocation:(CGPoint)location
{
    self.location_x = @(location.x);
    self.location_y = @(location.y);
}

- (NSString *)title
{
    return self.note.title;
}

- (void)setTitle:(NSString *)title
{
    self.note.title = title;
}

@end
