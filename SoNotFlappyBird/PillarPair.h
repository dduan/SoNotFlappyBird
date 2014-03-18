//
//  PillarPair.h
//  SoNotFlappyBird
//
//  Created by Daniel Duan on 3/17/14.
//  Copyright (c) 2014 Daniel Duan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Constants.h"

@interface PillarPair : SKSpriteNode
- (instancetype)initForFrame: (CGRect)frame;
- (void)randomize;
@end
