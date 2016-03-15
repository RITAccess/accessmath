//
//  SaveTextSize.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 2/25/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SaveTextSize : NSObject <NSCoding>

@property UIFont* textFont;

+(instancetype)sharedData;
-(void)save;

@end