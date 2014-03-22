//
//  Constants.h
//  SoNotFlappyBird
//
//  Created by Daniel Duan on 3/17/14.
//  Copyright (c) 2014 Daniel Duan. All rights reserved.
//

#ifndef SoNotFlappyBird_Constants_h
#define SoNotFlappyBird_Constants_h


#define kGravityConstantY -11.0f
#define kBirdSize 36.0f
#define kBirdPositionX 50.0f
#define kBirdThrustY 500.0f
#define kGroundLevelHeight 125.0f
#define kPillarWidth 53.0f
#define kPillarPairGap 160.0f
#define kPillarDistance 150.0f
#define kHorizontalPeriod 2.6f
#define kBirdThrustTurnUpTime 0.49f
#define kBirdFallTurnDownTime 0.4f


static const uint32_t birdCategory      =  0x1 << 0;
static const uint32_t pillarCategory    =  0x1 << 1;
static const uint32_t sceneCategory     =  0x1 << 2;

#endif