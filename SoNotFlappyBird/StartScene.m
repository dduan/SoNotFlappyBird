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
    self.physicsWorld.gravity = CGVectorMake(0, -11.0);
    
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
    bird.size = CGSizeMake(44.0, 44.0);
    bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: 22.0];
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
    bird.physicsBody.velocity = CGVectorMake(0, 530);

}
@end
