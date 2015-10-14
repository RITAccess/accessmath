//
//  backgroundImages.m
//  LandScapeV2
//
//  Accessed via swiping left, has preview of images presented that the user
//  can choose from to set the background of the shuffling note cards as.
//
//  Created by Kimberly Sookoo on 7/24/15.
//  Copyright (c) 2015 Kimberly Sookoo. All rights reserved.
//

#import "backgroundImages.h"
#import "MoreShuffle.h"
#import "saveData.h"

@interface backgroundImages()

@property BOOL created; //checks to see if scene is created

@end

@implementation backgroundImages
{
    //background images
    SKSpriteNode *image;
    SKSpriteNode *image2;
    SKSpriteNode *image3;
    SKSpriteNode *image4;
    SKSpriteNode *image5;
    SKSpriteNode *image6;
    SKSpriteNode *image7;
    SKSpriteNode *image8;
    SKSpriteNode *image9;
    SKSpriteNode *image10;
    SKSpriteNode *image11;
    SKSpriteNode *image12;
    SKSpriteNode *image13;
    SKSpriteNode *image14;
    SKSpriteNode *image15;
    SKSpriteNode *image16;
    SKSpriteNode *image17;
    SKSpriteNode *image18;
    SKSpriteNode *image19;
    SKSpriteNode *image20;
    SKSpriteNode *image21;
    SKSpriteNode *image22;
    SKSpriteNode *image23;
    SKSpriteNode *image24;
    SKSpriteNode *image25;
    
    //arrow to traverse pages
    SKSpriteNode *arrow;
    
    //returns to "Shuffle Notes" screen
    UISwipeGestureRecognizer *closeSwipe;
    //zoom
    UIPinchGestureRecognizer *zoomIn;
}

- (void)didMoveToView: (SKView *) view
{
    self.anchorPoint = CGPointMake(0, 0);
    if (!self.created) {
        [self createScene];
        self.created = YES;
    }
    closeSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action: @selector(rightFlip:)];
    [closeSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [closeSwipe setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:closeSwipe];
    
    zoomIn = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.view addGestureRecognizer:zoomIn];
}

//removes the change background menu
-(void)rightFlip:(id)sender
{
    [self.view removeGestureRecognizer:closeSwipe];
    [self.view removeGestureRecognizer:zoomIn];
    MoreShuffle *backy = [[MoreShuffle alloc] initWithSize:CGSizeMake(2000, 1768)];
    SKView *view = (SKView *) self.view;
    [view presentScene:backy];
}

//Pinch to zoom functionality.
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture
{
    
    if (UIGestureRecognizerStateBegan == pinchGesture.state ||
        UIGestureRecognizerStateChanged == pinchGesture.state) {
        
        // Use the x or y scale, they should be the same for typical zooming (non-skewing)
        float currentScale = [[pinchGesture.view.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        
        // Variables to adjust the max/min values of zoom
        float minScale = 1.0;
        float maxScale = 1.0;
        float zoomSpeed = .5;
        
        float deltaScale = pinchGesture.scale;
        
        // You need to translate the zoom to 0 (origin) so that you
        // can multiply a speed factor and then translate back to "zoomSpace" around 1
        deltaScale = ((deltaScale - 1) * zoomSpeed) + 1;
        
        // Limit to min/max size (i.e maxScale = 2, current scale = 2, 2/2 = 1.0)
        //  A deltaScale is ~0.99 for decreasing or ~1.01 for increasing
        //  A deltaScale of 1.0 will maintain the zoom size
        deltaScale = MIN(deltaScale, maxScale / currentScale);
        deltaScale = MAX(deltaScale, minScale / currentScale);
        
        CGAffineTransform zoomTransform = CGAffineTransformScale(pinchGesture.view.transform, deltaScale, deltaScale);
        pinchGesture.view.transform = zoomTransform;
        
        // Reset to 1 for scale delta's
        //  Note: not 0, or we won't see a size: 0 * width = 0
        pinchGesture.scale = 1;
    }
}

//Creates the scene and presents the images.
-(void)createScene
{
    self.backgroundColor = [SKColor grayColor];
    self.scaleMode = SKSceneScaleModeFill;
    
    //creates clickable background images
    image = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(100, 100)];
    image.position = CGPointMake(80, 600);
    image.name = @"image1";
    
    image2 = [SKSpriteNode spriteNodeWithImageNamed:@"IS787-189.jpg"];
    image2.size = CGSizeMake(100, 100);
    image2.position = CGPointMake(200, 600);
    image2.name = @"image2";
    
    image3 = [SKSpriteNode spriteNodeWithImageNamed:@"IS787-191.jpg"];
    image3.size = CGSizeMake(100, 100);
    image3.position = CGPointMake(320, 600);
    image3.name = @"image3";
    
    image4 = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(100, 100)];
    image4.position = CGPointMake(440, 600);
    image4.name = @"image4";
    
    image5 = [SKSpriteNode spriteNodeWithColor:[SKColor orangeColor] size:CGSizeMake(100, 100)];
    image5.position = CGPointMake(560, 600);
    image5.name = @"image5";
    
    image6 = [SKSpriteNode spriteNodeWithColor:[SKColor purpleColor] size:CGSizeMake(100, 100)];
    image6.position = CGPointMake(680, 600);
    image6.name = @"image6";
    
    image7 = [SKSpriteNode spriteNodeWithColor:[SKColor brownColor] size:CGSizeMake(100, 100)];
    image7.position = CGPointMake(800, 600);
    image7.name = @"image7";
    
    image8 = [SKSpriteNode spriteNodeWithImageNamed:@"notebook-page.jpg"];
    image8.size = CGSizeMake(100, 100);
    image8.position = CGPointMake(920, 600);
    image8.name = @"image8";
    
    image9 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.0f/255.0f green:226.0f/255.0f blue:255.0f/255.0f alpha:1.0] size:CGSizeMake(100, 100)];
    image9.position = CGPointMake(80, 450);
    image9.name = @"image9";
    
    image10 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:130.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0] size:CGSizeMake(100, 100)];
    image10.position = CGPointMake(200, 450);
    image10.name = @"image10";
    
    image11 = [SKSpriteNode spriteNodeWithImageNamed:@"sky-183869_640.jpg"];
    image11.size = CGSizeMake(100, 100);
    image11.position = CGPointMake(320, 450);
    image11.name = @"image11";
    
    image12 = [SKSpriteNode spriteNodeWithImageNamed:@"background-68622_640.jpg"];
    image12.size = CGSizeMake(100, 100);
    image12.position = CGPointMake(440, 450);
    image12.name = @"image12";
    
    image13 = [SKSpriteNode spriteNodeWithImageNamed:@"ball-443852_640.jpg"];
    image13.size = CGSizeMake(100, 100);
    image13.position = CGPointMake(560, 450);
    image13.name = @"image13";
    
    image14 = [SKSpriteNode spriteNodeWithImageNamed:@"cosmea-583092_640.jpg"];
    image14.size = CGSizeMake(100, 100);
    image14.position = CGPointMake(680, 450);
    image14.name = @"image14";
    
    image15 = [SKSpriteNode spriteNodeWithImageNamed:@"ellipse-784354_640.jpg"];
    image15.size = CGSizeMake(100, 100);
    image15.position = CGPointMake(800, 450);
    image15.name = @"image15";
    
    image16 = [SKSpriteNode spriteNodeWithImageNamed:@"abstract-21851_640.jpg"];
    image16.size = CGSizeMake(100, 100);
    image16.position = CGPointMake(920, 450);
    image16.name = @"image16";
    
    image17 = [SKSpriteNode spriteNodeWithImageNamed:@"lines-593191_640.jpg"];
    image17.size = CGSizeMake(100, 100);
    image17.position = CGPointMake(80, 300);
    image17.name = @"image17";
    
    image18 = [SKSpriteNode spriteNodeWithImageNamed:@"IS098Z75U.jpg"];
    image18.size = CGSizeMake(100, 100);
    image18.position = CGPointMake(200, 300);
    image18.name = @"image18";
    
    image19 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:38.0f/255.0f green:167.0f/255.0f blue:162.0f/255.0f alpha:1.0] size:CGSizeMake(100, 100)];
    image19.position = CGPointMake(320, 300);
    image19.name = @"image19";
    
    image20 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:183.0f/255.0f alpha:1.0] size:CGSizeMake(100, 100)];
    image20.position = CGPointMake(440, 300);
    image20.name = @"image20";
    
    image21 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:39.0f/255.0f green:78.0f/255.0f blue:19.0f/255.0f alpha:1.0] size:CGSizeMake(100, 100)];
    image21.position = CGPointMake(560, 300);
    image21.name = @"image21";
    
    image22 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:208.0f/255.0f green:0.0f/255.0f blue:72.0f/255.0f alpha:1.0] size:CGSizeMake(100, 100)];
    image22.position = CGPointMake(680, 300);
    image22.name = @"image22";
    
    image23 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:158.0f/255.0f green:237.0f/255.0f blue:255.0f/255.0f alpha:1.0] size:CGSizeMake(100, 100)];
    image23.position = CGPointMake(800, 300);
    image23.name = @"image23";
    
    image24 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.0f/255.0f green:48.0f/255.0f blue:154.0f/255.0f alpha:1.0] size:CGSizeMake(100, 100)];
    image24.position = CGPointMake(920, 300);
    image24.name = @"image24";
    
    image25 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:196.0f/255.0f green:255.0f/255.0f blue:110.0f/255.0f alpha:1.0] size:CGSizeMake(100, 100)];
    image25.position = CGPointMake(80, 150);
    image25.name = @"image25";
    
    //arrow to go cycle through backgrounds
    arrow = [SKSpriteNode spriteNodeWithImageNamed:@"transparent-arrow-th.png"];
    arrow.size = CGSizeMake(100, 30);
    arrow.position = CGPointMake(500, 50);
    arrow.name = @"arrow";
    
    [self addChild:image];
    [self addChild:image2];
    [self addChild:image3];
    [self addChild:image4];
    [self addChild:image5];
    [self addChild:image6];
    [self addChild:image7];
    [self addChild:image8];
    [self addChild:image9];
    [self addChild:image10];
    [self addChild:image11];
    [self addChild:image12];
    [self addChild:image13];
    [self addChild:image14];
    [self addChild:image15];
    [self addChild:image16];
    [self addChild:image17];
    [self addChild:image18];
    [self addChild:image19];
    [self addChild:image20];
    [self addChild:image21];
    [self addChild:image22];
    [self addChild:image23];
    [self addChild:image24];
    [self addChild:image25];
    //[self addChild:arrow];
}

#pragma mark

//Forms the basic outline of the node.
- (SKSpriteNode *)outlineNode
{
    SKSpriteNode* outline = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(325, 225)];
    outline.name = @"outline";
    
    return outline;
}

//Selected image becomes the new background of the SKSpriteNodes
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint scenePosition = [touch locationInNode:self];
    
    SKNode *checkNode = [self nodeAtPoint:scenePosition];
    
    if(checkNode && ([checkNode.name hasPrefix:@"image"])){
        [self.view removeGestureRecognizer:closeSwipe];
        [self.view removeGestureRecognizer:zoomIn];
        
        SKTexture *tex = [self.scene.view textureFromNode:checkNode];
        SKSpriteNode *paper = [[SKSpriteNode alloc] initWithTexture:tex];
        paper.size = CGSizeMake(300, 200);
        
        SKSpriteNode *outliner = [self outlineNode];
        [outliner addChild:paper];
        
        SKTexture *newTex = [self.scene.view textureFromNode:outliner];
        [saveData sharedData].current = newTex;
        
        MoreShuffle *backy = [[MoreShuffle alloc] initWithSize:CGSizeMake(2000, 1768)];
        SKView *view = (SKView *) self.view;
        [view presentScene:backy];
    }
    
}


@end

