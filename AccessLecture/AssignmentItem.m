//
//  AssignmentItem.m
//  LandScapeV2
//
//  Created by Student on 6/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "AssignmentItem.h"

@implementation AssignmentItem

static NSString* const assignmentName = @"assignment name";
static NSString* const associatedLecture = @"associated lecture";
static NSString* const associatedNotes = @"associated notes";
static NSString* const completed = @"completed";
static NSString* const dueDate = @"due date";

-(instancetype)initWithName:(NSString*)name Date:(NSDate*)creationDate Lecture:(NSString*)associatedLecture {
    self.itemName = name;
    self.creationDate = creationDate;
    self.associatedLecture = associatedLecture;
    self.notes = nil;
    self.completed = NO;
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.itemName = [aDecoder decodeObjectForKey:assignmentName];
        self.creationDate = [aDecoder decodeObjectForKey:dueDate];
        self.associatedLecture = [aDecoder decodeObjectForKey:associatedLecture];
        self.notes = [aDecoder decodeObjectForKey:associatedNotes];
        self.completed = [aDecoder decodeBoolForKey:completed];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.itemName forKey:assignmentName];
    [aCoder encodeObject:self.creationDate forKey:dueDate];
    [aCoder encodeObject:self.associatedLecture forKey:associatedLecture];
    [aCoder encodeObject:self.notes forKey:associatedNotes];
    [aCoder encodeBool:self.completed forKey:completed];
}

+ (void)saveAssignment:(AssignmentItem*)assignment {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [defaults objectForKey:@"saved array"];
    NSMutableArray *arrayToSave = [[NSMutableArray alloc] init];
    if (dataRepresentingSavedArray != nil) {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        for (AssignmentItem *item in oldSavedArray) {
            [arrayToSave addObject:item];
        }
    }
    [arrayToSave addObject:assignment];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrayToSave];
    [defaults setObject:encodedObject forKey:@"saved array"];
    [defaults synchronize];
}

+ (void)replaceArrayOfAssignmentsWith:(NSMutableArray*)replacement {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:replacement];
    [defaults setObject:encodedObject forKey:@"saved array"];
}

+ (NSMutableArray*)loadAssignments {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"saved array"];
    NSMutableArray *savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return savedArray;
}

@end
