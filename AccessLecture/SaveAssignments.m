//
//  SaveAssignments.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/7/16.
//
//

#import "SaveAssignments.h"

@implementation SaveAssignments

static NSString* const segment = @"selected segment";
static NSString* const segmentSelected = @"segment was selected";
static NSString* const reminderInDays = @"remind in number of days";
static NSString* const reminderChosen = @"reminder chosen";

/*
 "Deserializes" the data
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _segment = [decoder decodeIntegerForKey:segment];
        _segmentSelected = [decoder decodeBoolForKey:segmentSelected];
        _reminderInDays = [decoder decodeIntegerForKey:reminderInDays];
        _reminder = [decoder decodeObjectForKey:reminderChosen];
    }
    return self;
}

/*
 "Serializes" the data.
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.segment forKey:segment];
    [encoder encodeBool:self.segmentSelected forKey:segmentSelected];
    [encoder encodeInteger:self.reminderInDays forKey:reminderInDays];
    [encoder encodeObject:self.reminder forKey:reminderChosen];
}

/*
 Creates the file path to store data
 */
+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"AssignmentData"];
    }
    return filePath;
}

/*
 Accesses the information stored
 */
+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [SaveAssignments filePath]];
    if (decodedData) {
        SaveAssignments* data = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return data;
    }
    
    return [[SaveAssignments alloc] init];
}

/*
 Creates an instance of the saved information
 */
+ (instancetype)sharedData
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

/*
 Saves the information to the file path
 */
-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[SaveAssignments filePath] atomically:YES];
}


@end
