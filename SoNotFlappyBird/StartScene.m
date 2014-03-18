//
//  StartScene.m
//  SoNotFlappyBird
//
//  Created by Daniel Duan on 3/16/14.
//  Copyright (c) 2014 Daniel Duan. All rights reserved.
//

#import "StartScene.h"
#import "Constants.h"
#import "PillarPair.h"

@interface StartScene ()
@property (nonatomic) BOOL contentCreated;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) SKAction *moveLeftAction;
@end

@implementation StartScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName: @"pair" usingBlock: ^(SKNode *pair, BOOL *stop) {
        if (pair.position.x == -kPillarWidth) {
            pair.position = CGPointMake(CGRectGetMaxX(self.frame) + kPillarWidth, 0);
            [(PillarPair *)pair randomize];
            [pair runAction: self.moveLeftAction];
        }
    }];
}

- (SKAction *)moveLeftAction
{
    if (!_moveLeftAction) {
        _moveLeftAction = [SKAction moveToX: -kPillarWidth duration: kHorizontalPeriod];
    }
    return _moveLeftAction;
}

- (void)createSceneContents
{
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0, kGravityConstantY);
    
    
    SKPhysicsBody *border = [SKPhysicsBody bodyWithEdgeLoopFromRect: self.frame];
    self.physicsBody = border;
    self.physicsBody.friction = 0.0;

    SKSpriteNode *pair = [[PillarPair alloc] initForFrame: self.frame];
    pair.name = @"pair";
    pair.position = CGPointMake(CGRectGetMaxX(self.frame) + kPillarWidth, 0);
    [self addChild: pair];
    
    SKSpriteNode *bird = [self newBird];
    bird.position = CGPointMake(50, CGRectGetMidY(self.frame));
    [self addChild: bird];
}

- (SKSpriteNode *)newBird
{	
    SKSpriteNode *bird = [SKSpriteNode spriteNodeWithImageNamed: @"bird"];
    bird.size = CGSizeMake(kBirdSize, kBirdSize);
    bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: kBirdSize / 2];
    bird.physicsBody.dynamic = NO;
    bird.name = @"bird";
    return bird;
}

- (SKSpriteNode *)newPillar
{
    SKSpriteNode *pillar = [SKSpriteNode spriteNodeWithColor: [SKColor greenColor] size: CGSizeMake(kPillarWidth, 100)];
    pillar.anchorPoint = CGPointMake(0.0, 0.0);
    pillar.name = @"pillar";
    return pillar;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKNode *bird = [self childNodeWithName: @"bird"];
    if (!self.isPlaying) {
        self.isPlaying = YES;
        bird.physicsBody.dynamic = YES;
        SKNode *pair = [self childNodeWithName: @"pair"];
        [pair runAction: self.moveLeftAction];
    }
    bird.physicsBody.velocity = CGVectorMake(0, kBirdVelocityY);


}
@end
