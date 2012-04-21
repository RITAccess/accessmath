//
//  AccessDocument.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "AccessDocument.h"

static NSString * NOTES_KEY = @"notes_key";
static NSString * LECTURE_KEY = @"lecture_key";

static NSString * FILE_TYPE = @"lecture";

@implementation AccessDocument

//
//  Note object to store all data
//
@synthesize notes = _notes;
@synthesize lecture = _lecture;

+ (NSString *)fileType {
    return FILE_TYPE;
}

//
//  load the contents of this document from the given contents
//
//  UIDocument gives you exactly what you saved, so contents is what contentsForType:error: returns
//
//  since we serialized our data into NSData with NSKeyedArchiver, we can use [NSKeyedUnarchiver unarchivedObjectWithData:]
// 
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    
    if ([typeName isEqual:FILE_TYPE]) {    
        NSData * archivedData = (NSData *)contents;
        NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archivedData];
        
        _notes = [unarchiver decodeObjectForKey:NOTES_KEY];
        _lecture = [unarchiver decodeObjectForKey:LECTURE_KEY];
        
        return YES;
    }    
    return NO;
}

//
//  save the contents of this document
//
//  UIDocument will actually save the content to a file for you, but you need to return the contents that will be saved
//
//  the easiest thing to do is to serialize the data into an NSData object with [NSKeyedArchiver archivedDataWithRootObject:]
//
- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    
    NSMutableData * archivedData = [[NSMutableData alloc] init];
    
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archivedData];
    
    [archiver encodeObject:_notes forKey:NOTES_KEY];
    [archiver encodeObject:_lecture forKey:LECTURE_KEY];
    
    return (NSData*)archivedData;
}

@end
