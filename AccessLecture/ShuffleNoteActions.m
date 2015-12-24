//
//  ShuffleNoteActions.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 12/6/15.
//
//

#import "ShuffleNoteActions.h"
#import "saveData.h"
#import "BackgroundImages.h"
#import "BackgroundTile.h"

@implementation ShuffleNoteActions
{
    //black outlines for the nodes
    SKSpriteNode *outline;
    
    //changes color of text
    SKSpriteNode *changeText;
}

#pragma mark: Notecard elements

- (SKSpriteNode *)paperNode
{
    SKSpriteNode *paper = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeMake(300, 200)];
    paper.name = @"paper";
    
    return paper;
}

#pragma mark

- (SKSpriteNode *)outlineNode
{
    outline = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(325, 225)];
    outline.name = @"outline";
    
    return outline;
}

#pragma mark

- (SKLabelNode *)dateNode
{
    SKLabelNode *datey = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
    datey.name = @"date";
    datey.text = @"Date: ";
    datey.fontSize = 35;
    datey.fontColor = [SKColor whiteColor];
    return datey;
}

#pragma mark

- (SKSpriteNode*)changeDateColor
{
    //Change the color of the text
    SKSpriteNode *color1 = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(120, 60)];
    color1.position = CGPointMake(-240, 0);
    color1.name = @"color1";
    
    SKSpriteNode *color2 = [[SKSpriteNode alloc] initWithColor:[SKColor darkGrayColor] size:CGSizeMake(120, 60)];
    color2.position = CGPointMake(-120, 0);
    color2.name = @"color2";
    
    SKSpriteNode *color3 = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(120, 60)];
    color3.position = CGPointMake(0, 0);
    color3.name = @"color3";
    
    SKSpriteNode *color4 = [[SKSpriteNode alloc] initWithColor:[SKColor lightGrayColor] size:CGSizeMake(120, 60)];
    color4.position = CGPointMake(120, 0);
    color4.name = @"color4";
    
    SKSpriteNode *color5 = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(120, 60)];
    color5.position = CGPointMake(240, 0);
    color5.name = @"color5";
    
    changeText = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(612, 66)];
    changeText.position = CGPointMake(325, 40);
    [changeText addChild:color1];
    [changeText addChild:color2];
    [changeText addChild:color3];
    [changeText addChild:color4];
    [changeText addChild:color5];
    
    return changeText;
}

@end
