//
//  Lecture.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/10/2014
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "Lecture.h"
#import "Note.h"
#import "ImageNoteViewController.h"
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
        return ([obj isKindOfClass:[Note class]] || [obj isKindOfClass:[ImageNoteViewController class]]);
    }];
    _notes = [(_notes ?: @[]) arrayByAddingObjectsFromArray:[valid allObjects]];
    return TRUE;
}

- (BOOL) removeNotes:(NSSet *)objects
{
    NSSet *valid = [objects objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        return ([obj isKindOfClass:[Note class]]);
    }];
    
    int remainingNotes = (_notes.count - valid.count);
    _notes = [[NSArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= remainingNotes; i++) {
        for (Note *note in valid) {
            [array addObject:note];
        }
    }
    _notes = [[NSArray alloc] initWithArray:array];
    return TRUE;
}

- (BOOL)zeroNotes
{
    _notes = [[NSArray alloc] init];
    return TRUE;
}

@end
