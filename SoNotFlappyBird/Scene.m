//
//  StartScene.m
//  SoNotFlappyBird
//
//  Created by Daniel Duan on 3/16/14.
//  Copyright (c) 2014 Daniel Duan. All rights reserved.
//

#import "Scene.h"
#import "Constants.h"
#import "PillarPair.h"

@interface Scene () <SKPhysicsContactDelegate>
@property (nonatomic) BOOL contentCreated;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL isEnded;
@property (nonatomic) SKAction *headTurn;
@property (nonatomic) SKAction *showUp;
@property (nonatomic) NSUInteger score;
@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) CGRect mainFrame;
@property (nonatomic) SKSpriteNode *bird;
@property (nonatomic) SKLabelNode *restartButton;
@property (nonatomic) SKSpriteNode *deathCurtain;
@end

@implementation Scene



#pragma mark Accessors

- (SKAction *)headTurn
{
    if (!_headTurn) {
        _headTurn = [SKAction sequence: @[
                                          [SKAction rotateToAngle: M_PI_4 duration: 0.0f],
                                          [SKAction waitForDuration: kBirdThrustTurnUpTime],
                                          [SKAction rotateToAngle: -M_PI_2 duration: kBirdFallTurnDownTime]
                                          ]];
    }
    return _headTurn;
}

- (SKAction *)showUp
{
    if (!_showUp) {
        CGFloat restartButtonHeight = self.mainFrame.size.height * 0.4f + kGroundLevelHeight;
        CGPoint startPoint = CGPointMake(CGRectGetMidX(self.mainFrame), restartButtonHeight - 60.0f);
        SKAction *hide = [SKAction group: @[
                                            [SKAction moveTo: startPoint duration: 0.0f],
                                            [SKAction fadeInWithDuration: 0.0f]
                                            ]];
        SKAction *show = [SKAction group: @[
                                            [SKAction fadeInWithDuration: kRestartButtonAppearTime],
                                             [SKAction moveToY: restartButtonHeight duration:kRestartButtonAppearTime]
                                             ]];
        _showUp = [SKAction sequence: @[hide, show]];
    }
    return _showUp;
}

- (SKSpriteNode *)bird
{
    if (!_bird) {
        _bird = [SKSpriteNode spriteNodeWithImageNamed: @"Bird"];
        _bird.size = CGSizeMake(kBirdSize, kBirdSize);
        _bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: kBirdSize / 2];
        _bird.physicsBody.dynamic = NO;
        _bird.name = @"bird";
    }
    return _bird;

}

- (SKLabelNode *)restartButton
{
    if (!_restartButton) {
        _restartButton = [SKLabelNode labelNodeWithFontNamed: @"Chalkduster"];
        _restartButton.text = @"Restart";
        _restartButton.name = @"restartButton";
    }
    return _restartButton;
}

- (SKLabelNode *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed: @"Chalkduster"];
        _scoreLabel.fontColor = [SKColor whiteColor];
        _scoreLabel.text = @"0";
    }
    return _scoreLabel;
}

- (SKSpriteNode *)deathCurtain
{
    if (!_deathCurtain) {
        _deathCurtain = [SKSpriteNode spriteNodeWithColor: [SKColor whiteColor] size:self.frame.size];
        _deathCurtain.anchorPoint = CGPointZero;
        _deathCurtain.alpha = 0.75f;
    }
    return _deathCurtain;
}

- (void)setScore:(NSUInteger)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat: @"%u", self.score];
}
#pragma mark -

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        [self resetGame];
        self.contentCreated = YES;
    }
}

- (void)didSimulatePhysics
{
    __block PillarPair *disappeared = nil;
    __block CGFloat maxX = 0;
    [self enumerateChildNodesWithName: @"pillars" usingBlock: ^(SKNode *node, BOOL *stop) {
        PillarPair *pair = (PillarPair *)node;
        if (maxX < pair.position.x) {
            maxX = pair.position.x;
        }
        if (pair.position.x == -kPillarWidth) {
            disappeared = pair;
        }
        if (pair.position.x < kBirdPositionX && !pair.cleared) {
            pair.cleared = YES;
            self.score += 1;
        }
    }];
    if (disappeared) {
        CGFloat xSpeed = self.mainFrame.size.width / kHorizontalPeriod;
        disappeared.position = CGPointMake(maxX + kPillarDistance + kPillarWidth, 0);
        [disappeared randomize];
        disappeared.cleared = NO;
        [disappeared runAction: [SKAction moveToX: -kPillarWidth duration: disappeared.position.x / xSpeed]];
    }
}

- (void)createSceneContents
{
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0, kGravityConstantY);
    self.physicsWorld.contactDelegate = self;
    self.physicsBody.categoryBitMask = sceneCategory;
    self.physicsBody.contactTestBitMask = birdCategory;
    
    self.mainFrame = CGRectMake(
                                self.frame.origin.x,
                                self.frame.origin.y + kGroundLevelHeight,
                                self.frame.size.width,
                                self.frame.size.height - kGroundLevelHeight
                                );
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: self.mainFrame];
    self.physicsBody.friction = 0.0;
    
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithColor: [SKColor blackColor]
                                                        size: CGSizeMake(self.mainFrame.size.width, kGroundLevelHeight)];
    ground.anchorPoint = CGPointZero;
    ground.position = CGPointZero;
    [self addChild: ground];
    

    self.bird.physicsBody.categoryBitMask = birdCategory;
    self.bird.physicsBody.contactTestBitMask = pillarCategory | sceneCategory;
    [self addChild: self.bird];
    
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.mainFrame), CGRectGetMidY(self.mainFrame));
    self.scoreLabel.zPosition = 1.0f;
    [self addChild: self.scoreLabel];
    
    self.deathCurtain.zPosition = 2.0f;
}



#pragma mark -

- (void)startGame
{
    self.isPlaying = YES;
    self.isEnded = NO;
    self.bird.physicsBody.dynamic = YES;
    [self createAndMovePillars];
}

- (void)resetGame
{
    [self enumerateChildNodesWithName: @"pillars" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    self.bird.position = CGPointMake(kBirdPositionX, CGRectGetMidY(self.mainFrame));
    [self.bird removeAllActions];
    [self.bird runAction: [SKAction rotateToAngle: 0.0f duration: 0]];
    self.bird.physicsBody.dynamic = NO;
    self.isEnded = NO;
    self.score = 0;
    [self.restartButton removeFromParent];
}

- (void)endGame
{
    if (!self.isEnded) {
        [self enumerateChildNodesWithName: @"pillars" usingBlock: ^(SKNode *node, BOOL *stop) {
            [node removeAllActions];
        }];
        self.isEnded = YES;
        self.isPlaying = NO;
        self.deathCurtain.alpha = 0.75f;
        [self addChild: self.deathCurtain];
        [self.deathCurtain runAction: [SKAction fadeOutWithDuration: kDeathCurtainAnimationTime] completion: ^{
            [self.deathCurtain removeFromParent];
            [self addChild: self.restartButton];
            [self.restartButton runAction: self.showUp];
        }];
    }
}

- (void)createAndMovePillars
{
    SKSpriteNode *pair;
    CGFloat distanceFromOffset;
    NSUInteger numOfPair = (NSUInteger)floor(self.mainFrame.size.width / (kPillarWidth + kPillarDistance)) + 1;
    CGFloat xSpeed = self.mainFrame.size.width / kHorizontalPeriod;

    for (int i = 0; i < numOfPair; i++) {
        pair = [[PillarPair alloc] initForFrame: self.mainFrame];
        pair.name = @"pillars";
        // place each pillar with increasing distance from the right edge of the scene
        distanceFromOffset = i * (kPillarWidth + kPillarDistance);
        pair.position = CGPointMake(self.mainFrame.size.width + distanceFromOffset, 0);
        // increase time needed for each pillar to move out of left edge according to their distance
        // so that a constant speed is maintained
        [pair runAction: [SKAction moveToX: -kPillarWidth duration: kHorizontalPeriod + distanceFromOffset / xSpeed]];
        [self addChild: pair];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isPlaying && !self.isEnded) {
        [self startGame];
    }
    if (!self.isEnded) {
        self.bird.physicsBody.velocity = CGVectorMake(0, kBirdThrustY);
        [self.bird removeAllActions];
        [self.bird runAction: self.headTurn];
    } else {
        CGPoint touchLocation = [[touches anyObject] locationInNode: self];
        SKNode *touchedNode = [self nodeAtPoint: touchLocation];
        if ([touchedNode.name isEqualToString: @"restartButton"]) {
            [self resetGame];
        }
    }
}


#pragma mark SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    CGFloat lowestThreshold = self.mainFrame.size.height  -  contact.contactPoint.y;
    if ((contact.bodyA != self.physicsBody && contact.bodyB != self.physicsBody) || ( lowestThreshold > 20)) {
        [self endGame];
    }
}
@end
