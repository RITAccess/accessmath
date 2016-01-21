//
//  ShuffleNoteContents.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 11/29/15.
//
//

#import "ShuffleNoteContents.h"
#import "saveData.h"
#import "MoreShuffle.h"

@implementation ShuffleNoteContents

//action to stack papers
-(void)stackPapers
{
    [saveData sharedData].isStacked = YES;
    
    MoreShuffle *more = [[MoreShuffle alloc] init];
    
    for (SKSpriteNode *node in self.children) {
        if ([node.name isEqualToString:@"newNode"]) {
            more.newNode.position = CGPointMake(600, 1000);
            [saveData sharedData].statPos = more.newNode.position;
        }
        if ([node.name isEqualToString:@"newNode2"]) {
            more.newNode2.position = CGPointMake(610, 990);
            [saveData sharedData].statPos2 = more.newNode2.position;
        }
        if ([node.name isEqualToString:@"newNode3"]) {
            more.newNode3.position = CGPointMake(620, 980);
            [saveData sharedData].statPos3 = more.newNode3.position;
        }
    }
    
    float x = 1200;
    float y = 1000;
    
    if ([saveData sharedData].array != nil) {
        for (SKSpriteNode *sprite in [saveData sharedData].array) {
            sprite.position = CGPointMake(x, y);
            x -= 10;
            y += 15;
        }
    }
    
    [[saveData sharedData] save];
}

@end
