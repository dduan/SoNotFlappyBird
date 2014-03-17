//
//  StartScene.m
//  SoNotFlappyBird
//
//  Created by Daniel Duan on 3/16/14.
//  Copyright (c) 2014 Daniel Duan. All rights reserved.
//

#import "StartScene.h"

@interface StartScene ()
@property BOOL contentCreated;
@property BOOL isPlaying;
@end


#define kGravityConstantY -11.0f
#define kBirdSize 44.0f
#define kBirdVelocityY 530.0f


@implementation StartScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0, kGravityConstantY);
    
    SKPhysicsBody *border = [SKPhysicsBody bodyWithEdgeLoopFromRect: self.frame];
    self.physicsBody = border;
    self.physicsBody.friction = 0.0;
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKNode *bird = [self childNodeWithName: @"bird"];
    if (!self.isPlaying) {
        self.isPlaying = YES;
        bird.physicsBody.dynamic = YES;
    }
    bird.physicsBody.velocity = CGVectorMake(0, kBirdVelocityY);

}
@end
