//
//  SaveColor.m
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 10/6/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "SaveColor.h"

@implementation SaveColor

static NSString* const highlightColor = @"highlightColor";
static NSString* const textColor = @"textColor";

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        self.hightlightColor = [decoder decodeObjectForKey:highlightColor];
        self.textColor = [decoder decodeObjectForKey:textColor];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.hightlightColor forKey:highlightColor];
    [encoder encodeObject:self.textColor forKey:textColor];
}

+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"colordata"];
    }
    return filePath;
}

+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [SaveColor filePath]];
    if (decodedData) {
        SaveColor* data = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return data;
    }
    
    return [[SaveColor alloc] init];
}

+ (instancetype)sharedData
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[SaveColor filePath] atomically:YES];
}

@end
