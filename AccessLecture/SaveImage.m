//
//  SaveImage.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 2/23/16.
//
//

#import "SaveImage.h"

@implementation SaveImage

static NSString* const image = @"image";
static NSString* const selectedImages = @"selected images";

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        if (!_selectedImagesArray) {
            _selectedImagesArray = [[NSMutableArray alloc] init];
        }
        _selectedImagesArray = [[decoder decodeObjectForKey:selectedImages] mutableCopy];
        _notesImage = [decoder decodeObjectForKey:image];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if (!_selectedImagesArray) {
        _selectedImagesArray = [[NSMutableArray alloc] init];
    }
    [encoder encodeObject:_selectedImagesArray forKey:selectedImages];
    [encoder encodeObject:_notesImage forKey:image];
}

+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"ImageData"];
    }
    return filePath;
}

+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [SaveImage filePath]];
    if (decodedData) {
        SaveImage* data = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return data;
    }
    
    return [[SaveImage alloc] init];
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
    [encodedData writeToFile:[SaveImage filePath] atomically:YES];
}

@end