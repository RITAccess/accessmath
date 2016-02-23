//
//  SaveImage.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 2/23/16.
//
//

#import <Foundation/Foundation.h>

@interface SaveImage : NSObject <NSCoding>

@property UIImage *notesImage;

+(instancetype)sharedData;
-(void)save;

@end
