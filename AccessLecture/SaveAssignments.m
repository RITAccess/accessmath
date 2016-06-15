//
//  SaveAssignments.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/7/16.
//
//

#import "SaveAssignments.h"

@implementation SaveAssignments

static NSString* const assignmentsDict = @"assignments dictionary";
static NSString* const assignmentsArray = @"assignments array";
static NSString* const assignment = @"assignment";
static NSString* const changedName = @"changed name";
static NSString* const initial = @"initial name";
static NSString* const segment = @"selected segment";
static NSString* const segmentSelected = @"segment was selected";


/*
 "Deserializes" the data
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        if (!_savedArray) {
            _savedArray = [[NSMutableArray alloc] init];
        }
        _savedArray = [[decoder decodeObjectForKey:assignmentsArray] mutableCopy];
        if(!_savedAssignments){
            _savedAssignments = [[NSMutableDictionary alloc] init];
        }
        
        _savedAssignments = [[decoder decodeObjectForKey:assignmentsDict] mutableCopy];
        _savedItem = [decoder decodeObjectForKey:assignment];
        _changedName = [decoder decodeObjectForKey:changedName];
        _initialName = [decoder decodeObjectForKey:initial];
        _segment = [decoder decodeIntegerForKey:segment];
        _segmentSelected = [decoder decodeBoolForKey:segmentSelected];
    }
    return self;
}

/*
 "Serializes" the data.
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    if(!self.savedArray){
        self.savedArray = [[NSMutableArray alloc] init];
    }
    [encoder encodeObject:self.savedArray forKey:assignmentsArray];
    if(!self.savedAssignments){
        self.savedAssignments = [[NSMutableDictionary alloc] init];
    }
    [encoder encodeObject:self.savedAssignments forKey:assignmentsDict];
    [encoder encodeObject:self.savedItem forKey:assignment];
    [encoder encodeObject:self.changedName forKey:changedName];
    [encoder encodeObject:self.initialName forKey:initial];
    [encoder encodeInteger:self.segment forKey:segment];
    [encoder encodeBool:self.segmentSelected forKey:segmentSelected];
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
