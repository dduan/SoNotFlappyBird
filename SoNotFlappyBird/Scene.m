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
@property (nonatomic) SKAction *headTurn;
@end

@implementation Scene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)didSimulatePhysics
{
    __block SKNode *disappeared = nil;
    __block CGFloat maxX = 0;
    [self enumerateChildNodesWithName: @"pillars" usingBlock: ^(SKNode *pair, BOOL *stop) {
        if (maxX < pair.position.x) {
            maxX = pair.position.x;
        }
        if (pair.position.x == -kPillarWidth) {
            disappeared = pair;
        }
    }];
    if (disappeared) {
        CGFloat xSpeed = self.frame.size.width / kHorizontalPeriod;
        disappeared.position = CGPointMake(maxX + kPillarDistance + kPillarWidth, 0);
        [(PillarPair *)disappeared randomize];
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
    
    
    SKPhysicsBody *border = [SKPhysicsBody bodyWithEdgeLoopFromRect: self.frame];
    self.physicsBody = border;
    self.physicsBody.friction = 0.0;

    SKSpriteNode *bird = [self newBird];
    bird.position = CGPointMake(50, CGRectGetMidY(self.frame));
    bird.physicsBody.categoryBitMask = birdCategory;
    bird.physicsBody.contactTestBitMask = pillarCategory | sceneCategory;
    [self addChild: bird];
}

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

- (void)createAndMovePillars
{
    SKSpriteNode *pair;
    CGFloat distanceFromOffset;
    NSUInteger numOfPair = (NSUInteger)floor(self.frame.size.width / (kPillarWidth + kPillarDistance)) + 1;
    CGFloat xSpeed = self.frame.size.width / kHorizontalPeriod;

    for (int i = 0; i < numOfPair; i++) {
        pair = [[PillarPair alloc] initForFrame: self.frame];
        pair.name = @"pillars";
        // place each pillar with increasing distance from the right edge of the scene
        distanceFromOffset = i * (kPillarWidth + kPillarDistance);
        pair.position = CGPointMake(self.frame.size.width + distanceFromOffset, 0);
        // increase time needed for each pillar to move out of left edge according to their distance
        // so that a constant speed is maintained
        [pair runAction: [SKAction moveToX: -kPillarWidth duration: kHorizontalPeriod + distanceFromOffset / xSpeed]];
        [self addChild: pair];
    }
}

- (SKSpriteNode *)newBird
{	
    SKSpriteNode *bird = [SKSpriteNode spriteNodeWithImageNamed: @"Bird"];
    bird.size = CGSizeMake(kBirdSize, kBirdSize);
    bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: kBirdSize / 2];
    bird.physicsBody.dynamic = NO;
    bird.name = @"bird";
    return bird;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKNode *bird = [self childNodeWithName: @"bird"];
    if (!self.isPlaying) {
        self.isPlaying = YES;
        bird.physicsBody.dynamic = YES;
        [self createAndMovePillars];
    }
    bird.physicsBody.velocity = CGVectorMake(0, kBirdThrustY);
    [bird removeAllActions];
    [bird runAction: self.headTurn];
}

#pragma mark SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"%@ %@", contact.bodyA, contact.bodyB);
}
@end
