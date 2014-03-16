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
    SKSpriteNode *bird = [self newBird];
    bird.position = CGPointMake(50, CGRectGetMidY(self.frame));
    bird.size = CGSizeMake(44.0, 44.0);
    [self addChild: bird];
}

- (SKSpriteNode *)newBird
{	
    SKSpriteNode *bird = [SKSpriteNode spriteNodeWithImageNamed: @"bird"];
    return bird;
}
@end
