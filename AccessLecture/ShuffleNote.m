//
//  ShuffleNote.m
//  AccessLecture
//
//  Created by Michael Timbrook on 3/15/16.
//
//

#import "ShuffleNote.h"

@interface ShuffleNote ()

@property (nonatomic) NSNumber *location_x;
@property (nonatomic) NSNumber *location_y;

@end

@implementation ShuffleNote

@dynamic title;
@dynamic content;
@dynamic location_x;
@dynamic location_y;

- (CGPoint)location
{
    return (CGPoint) { .x = self.location_x.floatValue, .y = self.location_y.floatValue };
}

- (void)setLocation:(CGPoint)location
{
    self.location_x = @(location.x);
    self.location_y = @(location.y);
}

@end
