//
//  MoreShuffle.m
//  LandScapeV2
//
//  Created by Student on 7/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "NoteTakingNote.h"

#import "MoreShuffle.h"
#import "SaveData.h"
#import "BackgroundImages.h"

@interface MoreShuffle()

@property BOOL created; //checks to see if scene is created
@property SKSpriteNode *activeDragNode; //sets the node to be dragged

@end


@implementation MoreShuffle
{
    //original center
    CGPoint _originalCenter;
    
    //black outlines for the nodes
    SKSpriteNode *outline;
    SKSpriteNode *outline1;
    SKSpriteNode *outline2;
    SKSpriteNode *outline3;
    
    //the nodes themselves
    SKSpriteNode *newNode;
    SKSpriteNode *newNode2;
    SKSpriteNode *newNode3;
    
    //button to expand the backgrounds for nodes
    SKSpriteNode *backButton;
    SKSpriteNode *opt;
    
    //background images
    SKSpriteNode *image;
    SKSpriteNode *image2;
    SKSpriteNode *image3;
    SKSpriteNode *image4;
    SKSpriteNode *image5;
    SKSpriteNode *image6;
    SKSpriteNode *image7;
    SKSpriteNode *image8;
    
    //arrow to traverse pages
    SKSpriteNode *arrow;
    
    //changes color of text
    SKSpriteNode *changeText;
    
    // button
    UIButton *stackButton;
    UIButton *createPaperNoteButton;
    UIButton *reset;
    
    //update date and texture
    SKTexture *curr;
    SKLabelNode *dateColor;
    
    // gestures
    UISwipeGestureRecognizer *leftSwipe;
    UIPanGestureRecognizer *panRecognizer;
    UIPinchGestureRecognizer *zoomIn;
}

//paper nodes physics categories
enum PHYSICS_CATEGORIES {
    PHYSICS_CATEGORY_OUTLINE_1 = 1, PHYSICS_CATEGORY_OUTLINE_2, PHYSICS_CATEGORY_OUTLINE_3
};

/*
 Creates the SpriteKity scene
 Determines what the current orientation of the device is and what the appropriate placement for the UIButtons will be
 Adds the left swipe functionality to display the background options for the papers/nodes.
 Adds the zoom in/zoom out functionality.
 Adds the panning ability.
 Checks to see if the device orientation is changed at any point to determine the appropriate view change via NSNotificationCenter.
 */
- (void)didMoveToView: (SKView *) view
{
    if (!self.created) {
        [self createScene];
        self.created = YES;
    }
    
    NSArray* notes = _notesFromSelectedLecture;
    for (NoteTakingNote* note in notes) {
        // TODO: create note representation for each note
        NSLog(@"DEBUG from SKView: %@", note.title);
        [self newPaper];
    }
    
    //detects device orientation specifically for UIButtons
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        stackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        stackButton.backgroundColor = [UIColor darkGrayColor];
        [stackButton setTitle:@"Stack Papers" forState:UIControlStateNormal];
        [stackButton addTarget:self action:@selector(stackPapers:) forControlEvents:UIControlEventTouchUpInside];
        
        createPaperNoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        createPaperNoteButton.backgroundColor = [UIColor darkGrayColor];
        [createPaperNoteButton setTitle:@"Make More" forState:UIControlStateNormal];
        [createPaperNoteButton addTarget:self action:@selector(newPaper) forControlEvents:UIControlEventTouchUpInside];
        
        reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        reset.backgroundColor = [UIColor darkGrayColor];
        [reset setTitle:@"Reset" forState:UIControlStateNormal];
        [reset addTarget:self action:@selector(resetButton) forControlEvents:UIControlEventTouchUpInside];
        
        stackButton.frame = CGRectMake(640, 940, 100, 20);
        createPaperNoteButton.frame = CGRectMake(640, 995, 100, 20);
        reset.frame = CGRectMake(500, 995, 100, 20);
    }
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        stackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        stackButton.backgroundColor = [UIColor darkGrayColor];
        [stackButton setTitle:@"Stack Papers" forState:UIControlStateNormal];
        [stackButton addTarget:self action:@selector(stackPapers:) forControlEvents:UIControlEventTouchUpInside];
        
        createPaperNoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        createPaperNoteButton.backgroundColor = [UIColor darkGrayColor];
        [createPaperNoteButton setTitle:@"Make More" forState:UIControlStateNormal];
        [createPaperNoteButton addTarget:self action:@selector(newPaper) forControlEvents:UIControlEventTouchUpInside];
        
        reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        reset.backgroundColor = [UIColor darkGrayColor];
        [reset setTitle:@"Reset" forState:UIControlStateNormal];
        [reset addTarget:self action:@selector(resetButton) forControlEvents:UIControlEventTouchUpInside];
        
        stackButton.frame = CGRectMake(890, 690, 100, 20);
        createPaperNoteButton.frame = CGRectMake(890, 740, 100, 20);
        reset.frame = CGRectMake(750, 740, 100, 20);
    }
    
    [view addSubview:createPaperNoteButton];
    [view addSubview:reset];
    [view addSubview:stackButton];
    
    //swipes to show backgrounds
    leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action: @selector(leftFlip:)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [leftSwipe setNumberOfTouchesRequired:2];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    [view addGestureRecognizer:leftSwipe];
    
    zoomIn = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [view addGestureRecognizer:zoomIn];
    
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [view addGestureRecognizer:panRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)willMoveFromView:(SKView *)view
{
    [super willMoveFromView:view];
    
    self.created = NO;
    
    [createPaperNoteButton removeFromSuperview];
    [reset removeFromSuperview];
    [stackButton removeFromSuperview];
    
    [view removeGestureRecognizer:leftSwipe];
    [view removeGestureRecognizer:panRecognizer];
    [view removeGestureRecognizer:zoomIn];
    [self removeAllChildren];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - Orientation

//updates view based on changes
- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

//The button placement depends on what case the current orientation falls under
- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            stackButton.frame = CGRectMake(640, 940, 100, 20);
            createPaperNoteButton.frame = CGRectMake(640, 995, 100, 20);
            reset.frame = CGRectMake(500, 995, 100, 20);
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            stackButton.frame = CGRectMake(890, 690, 100, 20);
            createPaperNoteButton.frame = CGRectMake(890, 740, 100, 20);
            reset.frame = CGRectMake(750, 740, 100, 20);
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}


#pragma mark - Gestures

//Allows for user to be able to pan around scence
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:panGesture.view.superview];
    _originalCenter = panRecognizer.view.center;
    if (UIGestureRecognizerStateBegan == panGesture.state ||UIGestureRecognizerStateChanged == panGesture.state) {
        panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x,
                                             panGesture.view.center.y + translation.y);
        // Reset translation, so we can get translation delta's (i.e. change in translation)
        [panGesture setTranslation:CGPointZero inView:self.view];
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [panGesture velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200; //original divider 200
        
        float slideFactor = 0.1 * slideMult /4; // Increase for more of a slide (original doesn't have a divider)
        CGPoint finalPoint = CGPointMake(panGesture.view.center.x + (velocity.x * slideFactor),
                                         panGesture.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 70), self.view.bounds.size.width-70);
        finalPoint.y = MIN(MAX(finalPoint.y, 100), self.view.bounds.size.height-100);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            panGesture.view.center = finalPoint;
        } completion:nil];
    }
    // Don't need any logic for ended/failed/canceled states
}

//Pinch zoom functionality
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture
{
    
    if (UIGestureRecognizerStateBegan == pinchGesture.state ||
        UIGestureRecognizerStateChanged == pinchGesture.state) {
        
        // Use the x or y scale, they should be the same for typical zooming (non-skewing)
        float currentScale = [[pinchGesture.view.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        
        // Variables to adjust the max/min values of zoom
        float minScale = 1.0;
        float maxScale = 3.0;
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES; // Works for most use cases of pinch + zoom + pan
}

/*
 Checks to see if the change background button has been clicked, and opens the menu to choose the
 available backgrounds from.
 */
- (void)leftFlip:(id)sender
{
    [self.view setCenter:CGPointMake(512, 384)];
    [self.view removeGestureRecognizer:zoomIn];
    [self.view removeGestureRecognizer:leftSwipe];
    [self.view removeGestureRecognizer:panRecognizer];
    BackgroundImages *backgroundImages = [[BackgroundImages alloc] initWithSize:CGSizeMake(1024, 768)];
    SKView *view = (SKView *) self.view;
    [view presentScene:backgroundImages];
}


#pragma mark - Scene Creation

//creates the initial SKScene
-(void)createScene
{
    self.backgroundColor = [SKColor lightGrayColor];
    self.scaleMode = SKSceneScaleModeFill;
    
    // setup a position constraint
    CGSize screenSize = self.scene.frame.size;
    SKConstraint *positionConstraint = [SKConstraint positionX:[SKRange rangeWithLowerLimit:150 upperLimit:(screenSize.width-150)] Y:[SKRange rangeWithLowerLimit:200 upperLimit:(screenSize.height-100)]];
    
    // Create date label if NULL
    SKLabelNode *dateLabelNode;
    if ([saveData sharedData].date != nil) {
        dateLabelNode = [saveData sharedData].date;
        [dateLabelNode removeFromParent];
    } else {
        dateLabelNode = [self dateNode];
    }
    dateLabelNode.position = CGPointMake(-110, 70);
    
    if ([saveData sharedData].currentTexture == nil) {
        //for the following nodes, the ability to return to default needs to be instantiated
        SKSpriteNode *paperNode = [self createPaperNode];
        paperNode.position = CGPointMake(CGRectGetMidX(outline1.frame), CGRectGetMidY(outline1.frame));
        
        outline1 = [self outlineNode];
        [outline1 addChild:paperNode];
        
        SKTexture *tex = [self.scene.view textureFromNode:outline1];
        newNode = [SKSpriteNode spriteNodeWithTexture:tex];
        newNode.name = @"newNode";
        newNode.constraints = @[positionConstraint];
        [newNode addChild:dateLabelNode];
        
        SKSpriteNode *pap2 = [self createPaperNode];
        pap2.position = CGPointMake(CGRectGetMidX(outline2.frame), CGRectGetMidY(outline2.frame));
        
        outline2 = [self outlineNode];
        [outline2 addChild:pap2];
        
        SKTexture *tex2 = [self.scene.view textureFromNode:outline2];
        
        newNode2 = [SKSpriteNode spriteNodeWithTexture:tex2];
        newNode2.name = @"newNode2";
        newNode2.constraints = @[positionConstraint];
        
        SKSpriteNode *pap3 = [self createPaperNode];
        pap3.position = CGPointMake(CGRectGetMidX(outline3.frame), CGRectGetMidY(outline3.frame));
        
        outline3 = [self outlineNode];
        [outline3 addChild:pap3];
        
        SKTexture *tex3 = [self.scene.view textureFromNode:outline3];
        
        newNode3 = [SKSpriteNode spriteNodeWithTexture:tex3];
        newNode3.name = @"newNode3";
        newNode3.constraints = @[positionConstraint];
    } else {
        newNode = [[SKSpriteNode alloc] initWithTexture:[saveData sharedData].currentTexture];
        newNode.name = @"newNode";
        newNode.constraints = @[positionConstraint];
        [newNode addChild:dateLabelNode];
        
        newNode2 = [[SKSpriteNode alloc] initWithTexture:[saveData sharedData].currentTexture];
        newNode2.name = @"newNode2";
        newNode2.constraints = @[positionConstraint];
        
        newNode3 = [[SKSpriteNode alloc] initWithTexture:[saveData sharedData].currentTexture];
        newNode3.name = @"newNode3";
        newNode3.constraints = @[positionConstraint];
    }
    
    for (SKSpriteNode *sprite in [saveData sharedData].array) {
        if ([saveData sharedData].array != nil) {
            sprite.name = @"newNodeX";
            if ([saveData sharedData].currentTexture != nil) {
                sprite.texture = [saveData sharedData].currentTexture;
            } else {
                
                SKSpriteNode *outliner = [self outlineNode];
                SKSpriteNode *paperNode = [self createPaperNode];
                paperNode.position = CGPointMake(CGRectGetMidX(outliner.frame), CGRectGetMidY(outliner.frame));
                [outliner addChild:paperNode];
            
                sprite.texture = [self.scene.view textureFromNode:outliner];
            }
            // TODO: CRASHES. might need to clear notes/save properly on shuffle dismissal
            sprite.constraints = @[positionConstraint];
            [self addChild:sprite];
        }
    }
    
    if ([saveData sharedData].isStacked == NO) {
        if ([saveData sharedData].isStacked) {
            newNode.position = [saveData sharedData].pos1;
        } else {
            newNode.position =  CGPointMake(CGRectGetMidX(self.frame)-200, CGRectGetMidY(self.frame)+250);
        }
        
        if ([saveData sharedData].isStacked2) {
            newNode2.position = [saveData sharedData].pos2;
        } else{
            newNode2.position = CGPointMake(CGRectGetMidX(self.frame)-195, CGRectGetMidY(self.frame)+240);
        }
        
        if ([saveData sharedData].isStacked3) {
            newNode3.position = [saveData sharedData].pos3;
        } else{
            newNode3.position = CGPointMake(CGRectGetMidX(self.frame)-190, CGRectGetMidY(self.frame)+230);
        }
    } else{
        newNode.position = [saveData sharedData].statPos;
        newNode2.position = [saveData sharedData].statPos2;
        newNode3.position = [saveData sharedData].statPos3;
    }
    
    //newNode1 physics body
    newNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    newNode.physicsBody.categoryBitMask = PHYSICS_CATEGORY_OUTLINE_1;
    newNode.physicsBody.contactTestBitMask = PHYSICS_CATEGORY_OUTLINE_2 | PHYSICS_CATEGORY_OUTLINE_3;
    newNode.physicsBody.collisionBitMask = PHYSICS_CATEGORY_OUTLINE_2 | PHYSICS_CATEGORY_OUTLINE_3;
    newNode.physicsBody.affectedByGravity = NO;
    newNode.physicsBody.allowsRotation = NO;
    
    //newNode2 physics body
    newNode2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    newNode2.physicsBody.categoryBitMask = PHYSICS_CATEGORY_OUTLINE_2;
    newNode2.physicsBody.contactTestBitMask = PHYSICS_CATEGORY_OUTLINE_1 | PHYSICS_CATEGORY_OUTLINE_3;
    newNode2.physicsBody.collisionBitMask = PHYSICS_CATEGORY_OUTLINE_1 | PHYSICS_CATEGORY_OUTLINE_3;
    newNode2.physicsBody.affectedByGravity = NO;
    newNode2.physicsBody.allowsRotation = NO;
    
    //newNode3
    newNode3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    newNode3.physicsBody.categoryBitMask = PHYSICS_CATEGORY_OUTLINE_3;
    newNode3.physicsBody.contactTestBitMask = PHYSICS_CATEGORY_OUTLINE_2 | PHYSICS_CATEGORY_OUTLINE_1;
    newNode3.physicsBody.collisionBitMask = PHYSICS_CATEGORY_OUTLINE_2 | PHYSICS_CATEGORY_OUTLINE_1;
    newNode3.physicsBody.affectedByGravity = NO;
    newNode3.physicsBody.allowsRotation = NO;
    
    [self addChild:newNode3];
    [self addChild:newNode2];
    [self addChild:newNode];
    
    //Change the color of the text
    SKSpriteNode *blackColorNode = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(120, 60)];
    blackColorNode.position = CGPointMake(-240, 0);
    blackColorNode.name = @"blackColorNode";
    
    SKSpriteNode *darkGrayColorNode = [[SKSpriteNode alloc] initWithColor:[SKColor darkGrayColor] size:CGSizeMake(120, 60)];
    darkGrayColorNode.position = CGPointMake(-120, 0);
    darkGrayColorNode.name = @"darkGrayColorNode";
    
    SKSpriteNode *grayColorNode = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(120, 60)];
    grayColorNode.position = CGPointMake(0, 0);
    grayColorNode.name = @"grayColorNode";
    
    SKSpriteNode *lightGrayColorNode = [[SKSpriteNode alloc] initWithColor:[SKColor lightGrayColor] size:CGSizeMake(120, 60)];
    lightGrayColorNode.position = CGPointMake(120, 0);
    lightGrayColorNode.name = @"lightGrayColorNode";
    
    SKSpriteNode *whiteColorNode = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(120, 60)];
    whiteColorNode.position = CGPointMake(240, 0);
    whiteColorNode.name = @"whiteColorNode";
    
    changeText = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(612, 66)];
    changeText.position = CGPointMake(325, 40);
    [changeText addChild:blackColorNode];
    [changeText addChild:darkGrayColorNode];
    [changeText addChild:grayColorNode];
    [changeText addChild:lightGrayColorNode];
    [changeText addChild:whiteColorNode];
    [self addChild:changeText];
    
    [[saveData sharedData] save];
}


#pragma mark - Button Creation

//generates more nodes
-(IBAction)newPaper
{
    SKSpriteNode *paperSpriteNode;
    
    if ([saveData sharedData].currentTexture != nil) {
        paperSpriteNode = [[SKSpriteNode alloc] initWithTexture:[saveData sharedData].currentTexture];
    } else {
        
        SKSpriteNode *pap = [self createPaperNode];
        pap.position = CGPointMake(CGRectGetMidX(outline1.frame), CGRectGetMidY(outline1.frame));
        
        outline1 = [self outlineNode];
        [outline1 addChild:pap];
        
        SKTexture *tex = [self.scene.view textureFromNode:outline1];
        paperSpriteNode = [[SKSpriteNode alloc] initWithTexture:tex];
    }
    // get the screensize
    CGSize scr = self.scene.frame.size;
    // setup a position constraint
    SKConstraint *c = [SKConstraint positionX:[SKRange rangeWithLowerLimit:150 upperLimit:(scr.width-150)] Y:[SKRange rangeWithLowerLimit:200 upperLimit:(scr.height-100)]];
    
    paperSpriteNode.position = CGPointMake(450, 500);
    paperSpriteNode.name = @"newNodeX";
    paperSpriteNode.constraints = @[c];
    
    paperSpriteNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    paperSpriteNode.physicsBody.categoryBitMask = PHYSICS_CATEGORY_OUTLINE_1;
    paperSpriteNode.physicsBody.contactTestBitMask = PHYSICS_CATEGORY_OUTLINE_2 | PHYSICS_CATEGORY_OUTLINE_3;
    paperSpriteNode.physicsBody.collisionBitMask = PHYSICS_CATEGORY_OUTLINE_2 | PHYSICS_CATEGORY_OUTLINE_3;
    paperSpriteNode.physicsBody.affectedByGravity = NO;
    paperSpriteNode.physicsBody.allowsRotation = NO;
    
    //delete button for user generated note cards
    SKLabelNode *delText = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
    delText.text = @"Delete";
    delText.fontColor = [SKColor blueColor];
    delText.fontSize = 12;
    delText.position = CGPointMake(0, -5);
    
    SKSpriteNode *delete = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(50, 20)];
    [delete addChild:delText];
    
    SKTexture *deleture = [self.scene.view textureFromNode:delete];
    
    SKSpriteNode *deleteButton = [SKSpriteNode spriteNodeWithTexture:deleture];
    deleteButton.position = CGPointMake(125, -90);
    deleteButton.name = @"delete";
    [paperSpriteNode addChild:deleteButton];
    
    /*
     Creating more nodes that have their physicsBodies instantiated and can adapt to changes in texture like those in
     the original stack can be stored and saved via the NSMutableArray.
     */
    [saveData sharedData].node = paperSpriteNode;
    [[saveData sharedData].array addObject:paperSpriteNode];
    [[saveData sharedData] save];
    
    [self addChild:paperSpriteNode];
}


- (IBAction)resetButton
{
    [self removeAllChildren];
    [[saveData sharedData] reset];
    [[saveData sharedData] save];
    [self createScene];
}

//saves the texture of the nodes and keeps it; also used to keep the nodes in their specific positions
- (IBAction)saveButton:(UIButton *)pressed
{
    // TODO: implement save
}

//action to stack papers
-(IBAction)stackPapers:(UIButton *)pressed
{
    [saveData sharedData].isStacked = YES;
    
    for (SKSpriteNode *node in self.children) {
        if ([node.name isEqualToString:@"newNode"]) {
            newNode.position = CGPointMake(600, 1000);
            [saveData sharedData].statPos = newNode.position;
        }
        if ([node.name isEqualToString:@"newNode2"]) {
            newNode2.position = CGPointMake(610, 990);
            [saveData sharedData].statPos2 = newNode2.position;
        }
        if ([node.name isEqualToString:@"newNode3"]) {
            newNode3.position = CGPointMake(620, 980);
            [saveData sharedData].statPos3 = newNode3.position;
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

#pragma mark - Node Creation

- (SKSpriteNode *)createPaperNode
{
    SKSpriteNode *paper = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeMake(300, 200)];
    paper.name = @"paper";    
    return paper;
}

- (SKSpriteNode *)outlineNode
{
    outline = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(325, 225)];
    outline.name = @"outline";
    
    return outline;
}

- (SKLabelNode *)dateNode
{
    SKLabelNode *dateLabelNode = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
    dateLabelNode.name = @"date";
    dateLabelNode.text = @"Date: ";
    dateLabelNode.fontSize = 35;
    dateLabelNode.fontColor = [SKColor whiteColor];
    return dateLabelNode;
}
-(SKSpriteNode *)optionsView
{
    SKSpriteNode *opt2 = [[SKSpriteNode alloc] initWithColor:[SKColor lightGrayColor] size:CGSizeMake(300, 2600)];
    opt2.position = CGPointMake(CGRectGetMaxX(self.frame)-100, CGRectGetMaxY(self.frame)-500);
    return opt2;
}

#pragma mark - Touches

//detects if contact is made
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if ((contact.bodyA.categoryBitMask == (PHYSICS_CATEGORY_OUTLINE_2 | PHYSICS_CATEGORY_OUTLINE_3)) ||
        (contact.bodyB.categoryBitMask == (PHYSICS_CATEGORY_OUTLINE_2 | PHYSICS_CATEGORY_OUTLINE_3))) {
        // TODO: implement
    }
}

//in this section, the nodes' backgrounds will be able to by customized by the students using Access Math
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    BOOL tappedTwice = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint scenePosition = [touch locationInNode:self];
    
    SKNode *checkNode = [self nodeAtPoint:scenePosition];
    /*
     The following section is divided into cycling through nodes with different names.
     Each has different properties.
     The first if checks to see if the node being clicked is the SKSpriteNode for the paper itself, and thus checks to see if
     it is being dragged or being double clicked to transition to another page.
     */
    if (checkNode && ([checkNode.name hasPrefix:@"newNode"])) {
        
        if ([touch tapCount] == 2) {
            tappedTwice = YES;
            if ([checkNode.name isEqualToString:@"newNode"] || [checkNode.name isEqualToString:@"newNode2"] || [checkNode.name isEqualToString:@"newNode3"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoNotes" object:nil];
            } else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoNewNotes" object:nil];
            }
        } else if ([touch tapCount] == 1 && !tappedTwice) {
            _activeDragNode = (SKSpriteNode *)checkNode;
            [checkNode removeFromParent];
            [self addChild:checkNode];
            [self.view removeGestureRecognizer:leftSwipe];
            [self.view removeGestureRecognizer:panRecognizer];
        }
        //changes the color of the text and stores it.
    }
    else if (checkNode && [checkNode.name hasPrefix:@"color"]) {
        for (SKNode *check in self.children) {
            if ([check.name isEqualToString:@"newNode"]) {
                for (SKLabelNode *label in check.children) {
                    if ([checkNode.name isEqualToString:@"blackColorNode"]) {
                        label.fontColor = [SKColor blackColor];
                    }
                    if ([checkNode.name isEqualToString:@"darkGrayColorNode"]) {
                        label.fontColor = [SKColor darkGrayColor];
                    }
                    if ([checkNode.name isEqualToString:@"grayColorNode"]) {
                        label.fontColor = [SKColor grayColor];
                    }
                    if ([checkNode.name isEqualToString:@"lightGrayColorNode"]) {
                        label.fontColor = [SKColor lightGrayColor];
                    }
                    if ([checkNode.name isEqualToString:@"whiteColorNode"]) {
                        label.fontColor = [SKColor whiteColor];
                    }
                    
                    [saveData sharedData].date = label;
                }
            }
        }
    }
    else if (checkNode && [checkNode.name hasPrefix:@"delete"]) {
        [[saveData sharedData].array removeObject:checkNode.parent];
        [checkNode.parent removeFromParent];
        [checkNode removeFromParent];
    }
    
    [[saveData sharedData] save];
}

/*
 Creates the dragging motion.
 Saves the new location of the papers.
 Papers are not stacked, therefore the boolean is set to 'NO'.
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint scenePosition = [touch locationInNode:self];
    
    SKNode *checkNode = [self nodeAtPoint:scenePosition];
    
    if (_activeDragNode != nil) {
        CGPoint lastPos = [touch previousLocationInNode:self];
        
        CGPoint newLoc = CGPointMake(_activeDragNode.position.x + (scenePosition.x - lastPos.x), _activeDragNode.position.y + (scenePosition.y - lastPos.y));
        
        _activeDragNode.position = newLoc;
        
        if ([checkNode.name isEqualToString:@"newNode"]) {
            [saveData sharedData].pos1 = newLoc;
            [saveData sharedData].isStacked = YES;
        }
        if ([checkNode.name isEqualToString:@"newNode2"]) {
            [saveData sharedData].pos2 = newLoc;
            [saveData sharedData].isStacked2 = YES;
        }
        if ([checkNode.name isEqualToString:@"newNode3"]) {
            [saveData sharedData].pos3 = newLoc;
            [saveData sharedData].isStacked3 = YES;
        }
        
        [saveData sharedData].isStacked = NO;
    }
}

/*
 Detects when the "touches" has ended and re-instantiates the swipe and pan gestures.
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[saveData sharedData] save];
    UITouch *touch = [touches anyObject];
    CGPoint scenePosition = [touch locationInNode:self];
    
    SKNode *checkNode = [self nodeAtPoint:scenePosition];
    
    _activeDragNode = nil;
    
    //stops the swipe gesture from crashing
    if ([checkNode.name hasPrefix:@"newNode"]) {
        [self.view addGestureRecognizer:leftSwipe];
        [self.view addGestureRecognizer:panRecognizer];
    }
}

@end
