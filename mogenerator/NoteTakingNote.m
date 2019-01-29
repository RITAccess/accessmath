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

- (NSString *)content
{
    return self.note.content;
}

- (void)setContent:(NSString *)content
{
    self.note.content = content;
}

-(UIImage *)topImage
{
    return self.note.topImage;
}

- (void)setTopImage:(UIImage *)topImage
{
    self.note.topImage = topImage;
}

-(UIImage *)image2
{
    return self.note.image2;
}

- (void)setImage2:(UIImage *)image2
{
    self.note.image2 = image2;
}

-(UIImage *)image3
{
    return self.note.image3;
}

- (void)setImage3:(UIImage *)image3
{
    self.note.image3 = image3;
}

-(UIImage *)image4
{
    return self.note.image4;
}

- (void)setImage4:(UIImage *)image4
{
    self.note.image4 = image4;
}

@end
