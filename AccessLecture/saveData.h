//
//  saveData.h
//  LandScapeV2
//
//  Created by Student on 7/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface saveData : NSObject <NSCoding>

//array that stores SKSpriteNodes
@property NSMutableArray* array;

@property SKSpriteNode *node;

//saves the background image as a texture
@property SKTexture *current;

//saves the label to be added
@property SKLabelNode *date;

//saves the positions of the SKSpriteNodes not created by the user
//booleans helps decide if data is stacked or not
@property CGPoint pos1;
@property BOOL isSet;
@property CGPoint pos2;
@property BOOL isSet2;
@property CGPoint pos3;
@property BOOL isSet3;

//the location of the SKSpriteNodes when stacked
@property CGPoint statPos;
@property CGPoint statPos2;
@property CGPoint statPos3;

//determines if they're stacked
@property BOOL isStacked;


+(instancetype)sharedData;
-(void)save;
-(void)reset;

@end
