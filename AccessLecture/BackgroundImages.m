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

#import "BackgroundImages.h"
#import "MoreShuffle.h"
#import "saveData.h"

@interface BackgroundImages()

@property BOOL created; //checks to see if scene is created

@end

@implementation BackgroundImages
{
    //arrow to traverse pages
    SKSpriteNode *arrow;
    
    //returns to "Shuffle Notes" screen
    UISwipeGestureRecognizer *closeSwipe;
    //zoom
    UIPinchGestureRecognizer *zoomIn;
    
    //Array with images
    NSMutableArray *imageArray;
    
    //Array with colors and names
    NSMutableArray *colorArray;
    NSMutableArray *colorNames;
    
    //Dictionary with colors
    NSMutableDictionary *colorDict;
}

static NSString* const neon = @"IS787-189.jpg";
static NSString* const lights = @"IS787-191.jpg";
static NSString* const note = @"notebook-page.jpg";
static NSString* const sky = @"sky-183869_640.jpg";
static NSString* const velvet = @"background-68622_640.jpg";
static NSString* const ball = @"ball-443852_640.jpg";
static NSString* const cosmea = @"cosmea-583092_640.jpg";
static NSString* const ellipse = @"ellipse-784354_640.jpg";
static NSString* const abstract = @"abstract-21851_640.jpg";
static NSString* const lines = @"lines-593191_640.jpg";
static NSString* const stream = @"IS098Z75U.jpg";


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
    [saveData sharedData].savedTexture = NO;
    [[saveData sharedData] save];
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
    
    //Initialize the arrays
    imageArray = [[NSMutableArray alloc] initWithObjects:neon,lights,note,sky,velvet,ball,cosmea,ellipse,abstract,lines,stream, nil];
    
    colorArray = [[NSMutableArray alloc] initWithObjects:[SKColor yellowColor],[SKColor greenColor],[SKColor orangeColor],[SKColor purpleColor],[SKColor brownColor],[SKColor colorWithRed:0.0f/255.0f green:226.0f/255.0f blue:255.0f/255.0f alpha:1.0],[SKColor colorWithRed:130.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0],[SKColor colorWithRed:38.0f/255.0f green:167.0f/255.0f blue:162.0f/255.0f alpha:1.0],[SKColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:183.0f/255.0f alpha:1.0],[SKColor colorWithRed:39.0f/255.0f green:78.0f/255.0f blue:19.0f/255.0f alpha:1.0],[SKColor colorWithRed:208.0f/255.0f green:0.0f/255.0f blue:72.0f/255.0f alpha:1.0],[SKColor colorWithRed:158.0f/255.0f green:237.0f/255.0f blue:255.0f/255.0f alpha:1.0],[SKColor colorWithRed:0.0f/255.0f green:48.0f/255.0f blue:154.0f/255.0f alpha:1.0],[SKColor colorWithRed:196.0f/255.0f green:255.0f/255.0f blue:110.0f/255.0f alpha:1.0], nil];
    
    colorNames = [[NSMutableArray alloc] initWithObjects:@"yellow", @"green", @"orange", @"purple", @"brown", @"skyblue", @"darkpurple", @"turquoise", @"pink", @"moss", @"softred", @"lightblue", @"darkblue", @"lime", nil];
    
    colorDict = [[NSMutableDictionary alloc] initWithObjects:colorArray forKeys:colorNames];
    
    
    //Loop to generate background image/color choices
    CGFloat x = 80;
    CGFloat y = 600;
    
    for (NSString *str in imageArray) {
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:str];
        node.size = CGSizeMake(100, 100);
        node.position = CGPointMake(x, y);
        node.name = str;
        
        if (x < 920) {
            x += 120;
        }
        else {
            x = 80;
            y -= 150;
        }
        
        [self addChild:node];
    }
    
    for (NSString* key in colorNames) {
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[colorDict valueForKey:key] size:CGSizeMake(100, 100)];
        node.position = CGPointMake(x, y);
        
        node.name = key;
        
        if (x < 920) {
            x += 120;
        }
        else {
            x = 80;
            y -= 150;
        }
        
        [self addChild:node];
    }
    
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
    
    if(checkNode){
        [self.view removeGestureRecognizer:closeSwipe];
        [self.view removeGestureRecognizer:zoomIn];
        
        SKTexture *tex = [self.scene.view textureFromNode:checkNode];
        SKSpriteNode *paper = [[SKSpriteNode alloc] initWithTexture:tex];
        paper.size = CGSizeMake(300, 200);
        
        SKSpriteNode *outliner = [self outlineNode];
        [outliner addChild:paper];
        
        SKTexture *newTex = [self.scene.view textureFromNode:outliner];
        [saveData sharedData].current = newTex;
        
        [saveData sharedData].colorName = checkNode.name;
        [[saveData sharedData] save];
        
        MoreShuffle *backy = [[MoreShuffle alloc] initWithSize:CGSizeMake(2000, 1768)];
        SKView *view = (SKView *) self.view;
        [view presentScene:backy];
    }
    
}


@end

