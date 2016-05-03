//
//  MoreShuffle.m
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 7/24/15.
//  Copyright (c) 2015 Kimberly Sookoo. All rights reserved.
//

#import "NoteTakingNote.h"
#import "MoreShuffle.h"
#import "SaveData.h"
#import "BackgroundImages.h"
#import "LectureViewContainer.h"
#import "NoteTakingViewController.h"
#import "BackgroundTile.h"
#import "TextNoteViewController.h"
#import "ShuffleNoteActions.h"

@interface MoreShuffle()

@property BOOL created; //checks to see if scene is created
@property BOOL tappedTwice; //checks to see is node is tapped twice
@property SKSpriteNode *activeDragNode; //sets the node to be dragged

@end


@implementation MoreShuffle
{
    //original center
    CGPoint _originalCenter;
    
    //date node
    SKLabelNode *date;
    
    //black outlines for the nodes
    SKSpriteNode *outline;
    
    //the nodes themselves
    SKSpriteNode *newNode;
    SKSpriteNode *newNode2;
    SKSpriteNode *newNode3;
    
    //stack button
    UIButton *stackButton;
    //generate new node
    UIButton *newPaper;
    //reset button
    UIButton *reset;
    
    UISwipeGestureRecognizer *leftSwipe;
    
    UIPanGestureRecognizer *panRecognizer;
    
    //zoom
    UIPinchGestureRecognizer *zoomIn;
}

//paper nodes physics categories
static const int outline1Category = 1;
static const int outline2Category = 2;
static const int outline3Category = 3;


/*
 Creates the SpriteKit scene
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
    for (Note* note in notes) {
        // TODO: create note representation for each note
        NSLog(@"DEBUG from SKView: %@", note.title);
        [self newPaperFromLecture];
    }
    
    //Initializes array to add and remove notes
    _notesToSelectedLecture = [[NSMutableArray alloc] init];
    _notesToBeRemoved = [[NSMutableArray alloc] init];
    _sceneReset = FALSE;
    
    stackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stackButton.backgroundColor = [UIColor darkGrayColor];
    [stackButton setTitle:@"Stack Papers" forState:UIControlStateNormal];
    [stackButton addTarget:self action:@selector(stackPapers) forControlEvents:UIControlEventTouchUpInside];
    
    newPaper = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newPaper.backgroundColor = [UIColor darkGrayColor];
    [newPaper setTitle:@"Make More" forState:UIControlStateNormal];
    [newPaper addTarget:self action:@selector(newPaper) forControlEvents:UIControlEventTouchUpInside];
    
    reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reset.backgroundColor = [UIColor darkGrayColor];
    [reset setTitle:@"Reset" forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(resetButton) forControlEvents:UIControlEventTouchUpInside];

    NSArray* notes = _notesFromSelectedLecture;
    for (NoteTakingNote* note in notes) {
        // TODO: create note representation for each note
        NSLog(@"DEBUG from SKView: %@", note.title);
        [self newPaper];
    }
    
    //detects device orientation specifically for UIButtons
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        stackButton.frame = CGRectMake(640, 940, 100, 20);
        newPaper.frame = CGRectMake(640, 995, 100, 20);
        reset.frame = CGRectMake(500, 995, 100, 20);
    }
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        
        stackButton.frame = CGRectMake(890, 690, 100, 20);
        newPaper.frame = CGRectMake(890, 740, 100, 20);
        reset.frame = CGRectMake(750, 740, 100, 20);
    }
    
    [view addSubview:newPaper];
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
    
    [newPaper removeFromSuperview];
    [reset removeFromSuperview];
    [stackButton removeFromSuperview];
    
    [view removeGestureRecognizer:leftSwipe];
    [view removeGestureRecognizer:panRecognizer];
    [view removeGestureRecognizer:zoomIn];
    [self removeAllChildren];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

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
            newPaper.frame = CGRectMake(640, 995, 100, 20);
            reset.frame = CGRectMake(500, 995, 100, 20);
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            stackButton.frame = CGRectMake(890, 690, 100, 20);
            newPaper.frame = CGRectMake(890, 740, 100, 20);
            reset.frame = CGRectMake(750, 740, 100, 20);
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}

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
    BackgroundImages *backy = [[BackgroundImages alloc] initWithSize:CGSizeMake(1024, 768)];
    SKView *view = (SKView *) self.view;
    [view presentScene:backy];
}

#pragma mark: Textures

//original texture
-(SKTexture*)originalTexture
{
    ShuffleNoteActions *sna = [[ShuffleNoteActions alloc] init];
    
    SKSpriteNode *pap = [sna paperNode];
    pap.position = CGPointMake(CGRectGetMidX(outline.frame), CGRectGetMidY(outline.frame));
    
    outline = [sna outlineNode];
    [outline addChild:pap];
    
    SKTexture *tex = [self.scene.view textureFromNode:outline];
    
    return tex;
}

//make notecard with saved background image
-(SKTexture*)makeNotecardWithSavedImage
{
    ShuffleNoteActions *sna = [[ShuffleNoteActions alloc] init];
    BackgroundImages *images = [[BackgroundImages alloc] init];
    
    SKTexture *newTex;
    SKSpriteNode *node;
    
    for (BackgroundTile *image in [images createTiles]) {
        if ([[saveData sharedData].colorName isEqualToString:image.backgroundTileName]) {
            if (image.isColor) {
                node = [SKSpriteNode spriteNodeWithColor:image.colorName size:CGSizeMake(100, 100)];
            } else {
                node = [SKSpriteNode spriteNodeWithImageNamed:image.backgroundTileName];
                node.size = CGSizeMake(100, 100);
            }
            
            SKTexture *tex = [self.scene.view textureFromNode:node];
            SKSpriteNode *paper = [[SKSpriteNode alloc] initWithTexture:tex];
            paper.size = CGSizeMake(300, 200);
            
            SKSpriteNode *outliner = [sna outlineNode];
            [outliner addChild:paper];
            
            newTex = [self.scene.view textureFromNode:outliner];
        }
    }
    
    return newTex;
}

//generates more nodes
-(void)newPaper
{
    [self newPaperFromLecture];

    //Add to lecture view
    Note *newNote = [[Note alloc] init];
    [_notesToSelectedLecture addObject:newNote];
}

/**
 * Generates notecards from lecture
 */
-(void)newPaperFromLecture
{
    SKSpriteNode *newPap;
    
    if ([saveData sharedData].current != nil) {
        newPap = [[SKSpriteNode alloc] initWithTexture:[saveData sharedData].current];
    } else {
        newPap = [[SKSpriteNode alloc] initWithTexture:[self originalTexture]];
    }
    
    newPap.position = CGPointMake(450, 500);
    newPap.name = @"newNodeX";
    
    [self addPositionConstraints:newPap];
    [self makePhysicsBody:newPap];
    [self addDeleteButton:newPap];
    
    [self addChild:newPap];
}

/*
 * Resets the entire soon.
 */
- (IBAction)resetButton
{
    [self removeAllChildren];
    [[saveData sharedData] reset];
    [[saveData sharedData] save];
    [self createScene];
    [_notesToSelectedLecture removeAllObjects];
    [_notesToBeRemoved removeAllObjects];
    _sceneReset = TRUE;
}

//action to stack papers
-(IBAction)stackPapers
{
    float x = 1200;
    float y = 1000;
    
    [saveData sharedData].isStacked = YES;
    
    newNode.position = CGPointMake(600, 1000);
    newNode2.position = CGPointMake(610, 990);
    newNode3.position = CGPointMake(620, 980);
    
    for (SKSpriteNode *node in self.children) {
        if ([node.name isEqualToString:@"newNodeX"])
        {
            node.position = CGPointMake(x, y);
            x -= 10;
            y += 15;
        }
    }
    
    [[saveData sharedData] save];
}

#pragma mark

//notecard position constraints
-(void)addPositionConstraints:(SKSpriteNode*)notecard
{
    // get the screensize
    CGSize scr = self.scene.frame.size;
    // setup a position constraint
    SKConstraint *positionConstraint = [SKConstraint positionX:[SKRange rangeWithLowerLimit:150 upperLimit:(scr.width-150)] Y:[SKRange rangeWithLowerLimit:200 upperLimit:(scr.height-100)]];
    
    notecard.constraints = @[positionConstraint];
}

//adds delete button to notecard
-(void)addDeleteButton:(SKSpriteNode*)sprite
{
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
    
    [sprite addChild:deleteButton];
}

//creates the initial SKScene
-(void)createScene
{
    self.backgroundColor = [SKColor lightGrayColor];
    self.scaleMode = SKSceneScaleModeFill;
    
    ShuffleNoteActions *sna = [[ShuffleNoteActions alloc] init];
    
    if ([saveData sharedData].date != nil) {
        date = [saveData sharedData].date;
        [date removeFromParent];
    } else {
        
        date = [sna dateNode];
    }
    date.position = CGPointMake(-110, 70);
    
    if ([[saveData sharedData].colorName length] == 0) {
        //for the following nodes, the ability to return to default needs to be instantiated
        
        newNode = [SKSpriteNode spriteNodeWithTexture:[self originalTexture]];
        newNode2 = [SKSpriteNode spriteNodeWithTexture:[self originalTexture]];
        newNode3 = [SKSpriteNode spriteNodeWithTexture:[self originalTexture]];
        
    } else {
        newNode = [[SKSpriteNode alloc] initWithTexture:[self makeNotecardWithSavedImage]];
        newNode2 = [[SKSpriteNode alloc] initWithTexture:[self makeNotecardWithSavedImage]];
        newNode3 = [[SKSpriteNode alloc] initWithTexture:[self makeNotecardWithSavedImage]];
    }
    
    newNode.name = @"newNode";
    [newNode addChild:date];
    newNode2.name = @"newNode2";
    newNode3.name = @"newNode3";
    
    if ([saveData sharedData].isStacked == NO) {
        newNode.position = [saveData sharedData].pos1;
        newNode2.position = [saveData sharedData].pos2;
        newNode3.position = [saveData sharedData].pos3;
        
    } else {
        newNode.position = CGPointMake(600, 1000);
        newNode2.position = CGPointMake(610, 990);
        newNode3.position = CGPointMake(620, 980);
    }
    
    [self addChild:newNode3];
    [self addChild:newNode2];
    [self addChild:newNode];
    
    //Undergoing revision
    
    for (int i = 0; i < [[saveData sharedData].array count]; i++) {
        
        SKSpriteNode *sprite;
        
        if ([[saveData sharedData].colorName length] == 0) {
            
            sprite = [[SKSpriteNode alloc] initWithTexture:[self originalTexture]];
            
        } else {
            sprite = [[SKSpriteNode alloc] initWithTexture:[self makeNotecardWithSavedImage]];
        }
        
        sprite.name = @"newNodeX";
        sprite.position = [[[saveData sharedData].array objectAtIndex:i] position];
        
        [self addDeleteButton:sprite];
        
        [self addChild:sprite];
    }
    
    for (SKSpriteNode* notecard in self.children) {
        [self makePhysicsBody:notecard];
        [self addPositionConstraints:notecard];
    }
    
    [self addChild:sna.changeDateColor];
    
    [[saveData sharedData] save];
}

#pragma mark: Instantiating Physics Bodies

//detects if contact is made
-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if ((firstBody.categoryBitMask == (outline2Category | outline3Category)) || (secondBody.categoryBitMask == (outline2Category | outline3Category))) {
    }
}

//make physics body for specific notecard
-(void)makePhysicsBody:(SKSpriteNode*)notecard
{
    notecard.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    notecard.physicsBody.categoryBitMask = outline1Category;
    notecard.physicsBody.contactTestBitMask = outline2Category | outline3Category;
    notecard.physicsBody.collisionBitMask = outline2Category | outline3Category;
    notecard.physicsBody.affectedByGravity = NO;
    notecard.physicsBody.allowsRotation = NO;
}

#pragma mark: User Interaction with Notecards

//in this section, the nodes' backgrounds will be able to by customized by the students using Access Math
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _tappedTwice = NO;
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
            _tappedTwice = YES;
            if ([checkNode.name isEqualToString:@"newNode"] || [checkNode.name isEqualToString:@"newNode2"] || [checkNode.name isEqualToString:@"newNode3"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoNotes" object:nil];
            } else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoNewNotes" object:nil];
            }
        } else if ([touch tapCount] == 1 && !_tappedTwice) {
            _activeDragNode = (SKSpriteNode *)checkNode;
            [checkNode removeFromParent];
            [self addChild:checkNode];
            [self.view removeGestureRecognizer:leftSwipe];
            [self.view removeGestureRecognizer:panRecognizer];
        }
        //changes the color of the text and stores it.
    }
    else if (checkNode && [checkNode.name hasPrefix:@"color"]) {
        for(SKNode *check in self.children) {
            if ([check.name isEqualToString:@"newNode"]) {
                for(SKLabelNode *label in check.children) {
                    if ([checkNode.name isEqualToString:@"color1"]) {
                        label.fontColor = [SKColor blackColor];
                        [saveData sharedData].date = label;
                    }
                    if ([checkNode.name isEqualToString:@"color2"]) {
                        label.fontColor = [SKColor darkGrayColor];
                        [saveData sharedData].date = label;
                    }
                    if ([checkNode.name isEqualToString:@"color3"]) {
                        label.fontColor = [SKColor grayColor];
                        [saveData sharedData].date = label;
                    }
                    if ([checkNode.name isEqualToString:@"color4"]) {
                        label.fontColor = [SKColor lightGrayColor];
                        [saveData sharedData].date = label;
                    }
                    if ([checkNode.name isEqualToString:@"color5"]) {
                        label.fontColor = [SKColor whiteColor];
                        [saveData sharedData].date = label;
                    }
                }
            }
        }
    }
    else if (checkNode && [checkNode.name hasPrefix:@"delete"]) {
        //The number of notes deleted in this manner (via the "delete" button) will be reflected in the lecture.
        Note *note = [[Note alloc] init];
        [_notesToBeRemoved addObject:note];
        
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
        }
        if ([checkNode.name isEqualToString:@"newNode2"]) {
            [saveData sharedData].pos2 = newLoc;
        }
        if ([checkNode.name isEqualToString:@"newNode3"]) {
            [saveData sharedData].pos3 = newLoc;
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