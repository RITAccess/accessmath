//
//  SaveImage.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 2/23/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SaveImage : NSObject <NSCoding>

@property UIImage *notesImage;
@property NSMutableArray *selectedImagesArray;

+(instancetype)sharedData;
-(void)save;

@end
