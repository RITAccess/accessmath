//
//  saveColor.h
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 10/6/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SaveColor : NSObject <NSCoding>

@property UIColor* hightlightColor;
@property UIColor* textColor;
@property NSMutableArray* highlighted;

+(instancetype)sharedData;
-(void)save;

@end
