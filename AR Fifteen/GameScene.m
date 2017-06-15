//
//  GameScene.m
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

// GameScene implementation
@implementation GameScene

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {		
        gameLayer = [GameLayer node];
        [self addChild:gameLayer];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
