//
//  Note.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "NoteTakingNote.h"

@interface NoteTakingNote ()

@property (nonatomic) NSNumber *location_x;
@property (nonatomic) NSNumber *location_y;

@end

@implementation NoteTakingNote

@dynamic parent;
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

- (NSString *)title
{
    return self.parent.title;
}

- (void)setTitle:(NSString *)title
{
    self.parent.title = title;
}

- (NSString *)content
{
    return self.parent.content;
}

- (void)setContent:(NSString *)content
{
    self.parent.content = content;
}

@end
