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
        self.upper = [SKSpriteNode  spriteNodeWithColor: [SKColor greenColor] size: CGSizeZero];
        self.upper.anchorPoint = CGPointZero;
        [self addChild: self.upper];
        self.lower = [SKSpriteNode spriteNodeWithColor: [SKColor blueColor] size:CGSizeZero];
        self.lower.anchorPoint = CGPointZero;
        [self addChild: self.lower];
        [self randomize];
    }
    return self;
}

- (void)randomize
{
    CGFloat upperHeight = arc4random_uniform((u_int32_t)floor(self.size.height - kPillarPairGap));
    self.upper.size = CGSizeMake(kPillarWidth, upperHeight);
    self.upper.position = CGPointMake(0, self.size.height - upperHeight);
    self.lower.size = CGSizeMake(kPillarWidth, self.size.height - upperHeight - kPillarPairGap);
    self.lower.position = CGPointMake(0, 0);
}
@end
