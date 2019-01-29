//
//  Lecture.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/10/2014
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "Lecture.h"
#import "NoteTakingNote.h"
#import "ImageNoteViewController.h"
#import "Note.h"
#import "FileManager.h"//Added by Rafique
@interface Lecture ()

// Override public readonly
@property (readwrite, nonatomic, strong) NSArray *notes;

@end

@implementation Lecture

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aCoder {
    if (self = [super init]) {
        //_notes = [aCoder decodeObjectForKey:@"NotesArray"];
        _notes = _selectedLecture.notes;
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
        return ([obj isKindOfClass:[NoteTakingNote class]] || [obj isKindOfClass:[ImageNoteViewController class]]);
    }];
    _notes = [(_notes ?: @[]) arrayByAddingObjectsFromArray:[valid allObjects]];
    return TRUE;
}

/*
 Removes number of notes that corresponds to SKScene.
 */
- (BOOL) removeNotes:(NSSet *)objects
{
    NSSet *valid = [objects objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        return ([obj isKindOfClass:[Note class]]);
    }];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_notes];
    NSMutableArray *arrayCopy = [[NSMutableArray alloc] initWithArray:_notes];
    NSArray *validArray = [[NSArray alloc] initWithArray:[valid allObjects]];
    
    for (int i = 0; i < validArray.count; i++) {
        Note *note = [arrayCopy objectAtIndex:i];
        [array removeObject:note];
    }
    
    _notes = [[NSArray alloc] initWithArray:array];
    
    return TRUE;
}

/*
 * Sets note count to zero by initializing new array.
 */
- (BOOL)zeroNotes
{
    _notes = [[NSArray alloc] init];
    return TRUE;
}
@end
