#import "NoteTakingNote.h"
#import "Note.h"

@interface NoteTakingNote ()

// Private interface goes here.

@end

@implementation NoteTakingNote

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
