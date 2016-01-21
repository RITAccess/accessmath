//
//  saveData.m
//  LandScapeV2
//
//  Created by Student on 7/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "saveData.h"

@implementation saveData

static NSString* const array = @"array";
static NSString* const colorName = @"colorName";

static NSString* const currentTexture = @"currentTexture";
static NSString* const savedTexture = @"savedTexture";
static NSString* const dateColor = @"dateColor";

static NSString* const posi1 = @"posi1";
static NSString* const posi2 = @"posi2";
static NSString* const posi3 = @"posi3";

static NSString* const isStacked = @"isStacked";


/*
 "Deserializes" the data
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        if(!_array){
            _array = [[NSMutableArray alloc] init];
        }
        
        _array = [[decoder decodeObjectForKey:array] mutableCopy];
        
        _colorName =[decoder decodeObjectForKey:colorName];
        
        _current = [decoder decodeObjectForKey:currentTexture];
        _date = [decoder decodeObjectForKey:dateColor];
        
        _pos1 = [decoder decodeCGPointForKey:posi1];
        _pos2 = [decoder decodeCGPointForKey:posi2];
        _pos3 = [decoder decodeCGPointForKey:posi3];
        
        _isStacked = [decoder decodeBoolForKey:isStacked];
    }
    return self;
}

/*
 "Serializes" the data.
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    if(!self.array){
        self.array = [[NSMutableArray alloc] init];
    }
    [encoder encodeObject:self.array forKey:array];
    
    [encoder encodeObject:self.colorName forKey:colorName];
    [encoder encodeObject:self.current forKey:currentTexture];
    [encoder encodeObject:self.date forKey:dateColor];
    
    [encoder encodeCGPoint:self.pos1 forKey:posi1];
    [encoder encodeCGPoint:self.pos2 forKey:posi2];
    [encoder encodeCGPoint:self.pos3 forKey:posi3];
    
    [encoder encodeBool:self.isStacked forKey:isStacked];
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
         stringByAppendingPathComponent:@"userdata"];
    }
    return filePath;
}

/*
 Accesses the information stored
 */
+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [saveData filePath]];
    if (decodedData) {
        saveData* data = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return data;
    }
    
    return [[saveData alloc] init];
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
    [encodedData writeToFile:[saveData filePath] atomically:YES];
}

/*
 Resets the scene
 */
-(void)reset
{
    self.current = nil;
    self.colorName = @"";
    self.date = nil;
    [self.array removeAllObjects];
}

@end
