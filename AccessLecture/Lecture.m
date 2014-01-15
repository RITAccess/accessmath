//
//  Lecture.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/10/2014
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "Lecture.h"
#import "Note.h"
#import "ImageNote.h"
#import "AMLecture.h"

@interface Lecture ()

// Override public readonly
@property (readwrite, nonatomic, strong) NSArray *notes;

@end

@implementation Lecture

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aCoder {
    if (self = [super init]) {
        _notes = [aCoder decodeObjectForKey:@"NotesArray"];
        for (NSObject *obj in _notes) {
            [obj addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
            [obj addObserver:self forKeyPath:@"content" options:NSKeyValueObservingOptionNew context:NULL];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_notes forKey:@"NotesArray"];
}

#pragma mark - Data Modification

- (BOOL)addNotes:(NSSet *)objects
{
    NSSet *valid = [objects objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        return ([obj isKindOfClass:[Note class]] || [obj isKindOfClass:[ImageNote class]]);
    }];
    _notes = [(_notes ?: @[]) arrayByAddingObjectsFromArray:[valid allObjects]];
    for (NSObject *obj in [valid allObjects]) {
        [obj addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [obj addObserver:self forKeyPath:@"content" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return TRUE;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@ changed", keyPath);
    [(AMLecture *)self.parent saveWithCompletetion:^(BOOL success) {
        NSLog(@"Saved change %@", change);
    }];
}

@end
