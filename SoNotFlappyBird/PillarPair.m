//
//  PillarPair.m
//  SoNotFlappyBird
//
//  Created by Daniel Duan on 3/17/14.
//  Copyright (c) 2014 Daniel Duan. All rights reserved.
//

#import "PillarPair.h"


@interface PillarPair ()

@property (nonatomic) SKSpriteNode *upper;
@property (nonatomic) SKSpriteNode *lower;

@end

@implementation PillarPair

- (instancetype)initForFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointZero;
        self.size = CGSizeMake(kPillarWidth, frame.size.height);
        
        self.upper = [self newPillar];
        [self addChild: self.upper];
        
        self.lower = [self newPillar];
        [self addChild: self.lower];
        
        [self randomize];
    }
    return self;
}

- (void)randomize
{
    CGFloat upperHeight = arc4random_uniform((u_int32_t)floor(self.size.height - kPillarPairGap));
    CGPoint center;
    _upper.size = CGSizeMake(kPillarWidth, upperHeight);
    _upper.position = CGPointMake(0, self.size.height - upperHeight);
    center = CGPointMake(_upper.size.width / 2, _upper.size.height / 2);
    _upper.physicsBody = [self rectangularPhysicsBodyOfSize: _upper.size center:center];
    
    _lower.size = CGSizeMake(kPillarWidth, self.size.height - upperHeight - kPillarPairGap);
    _lower.position = CGPointMake(0, 0);
    center = CGPointMake(_lower.size.width / 2, _lower.size.height / 2);
    _lower.physicsBody = [self rectangularPhysicsBodyOfSize: _lower.size center:center];
}

- (SKSpriteNode *)newPillar
{
    SKSpriteNode *pillar = [SKSpriteNode spriteNodeWithColor: [SKColor blueColor] size:CGSizeZero];
    pillar.anchorPoint = CGPointZero;
    return pillar;
}

- (SKPhysicsBody *)rectangularPhysicsBodyOfSize: (CGSize)size center: (CGPoint)center
{
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize: size center: center];
    body.dynamic = NO;
    body.categoryBitMask = pillarCategory;
    body.contactTestBitMask = birdCategory;
    return body;
}
@end
