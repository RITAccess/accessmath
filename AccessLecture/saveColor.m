//
//  saveColor.m
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 10/6/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "saveColor.h"

@implementation saveColor

static NSString* const highlightColor = @"highlightColor";

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        self.hightlightColor = [decoder decodeObjectForKey:highlightColor];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.hightlightColor forKey:highlightColor];
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
    NSData* decodedData = [NSData dataWithContentsOfFile: [saveColor filePath]];
    if (decodedData) {
        saveColor* data = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return data;
    }
    
    return [[saveColor alloc] init];
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
    [encodedData writeToFile:[saveColor filePath] atomically:YES];
}

@end
