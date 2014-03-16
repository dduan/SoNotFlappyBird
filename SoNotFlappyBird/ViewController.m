//
//  ViewController.m
//  SoNotFlappyBird
//
//  Created by Daniel Duan on 3/16/14.
//  Copyright (c) 2014 Daniel Duan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"
#import "StartScene.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SKView *spriteView = (SKView *)self.view;
    spriteView.showsFPS = YES;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    StartScene *start = [[StartScene alloc] initWithSize: self.view.frame.size];
    SKView *spriteView = (SKView *)self.view;
    [spriteView presentScene: start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
