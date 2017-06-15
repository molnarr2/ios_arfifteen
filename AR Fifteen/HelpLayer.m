//
//  HelpLayer.m
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpLayer.h"


@implementation HelpLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if((self=[super initWithColor:ccc4(2, 43, 118, 255)])) {
        CGSize size = [[CCDirector sharedDirector] winSize];

        // Help Label
        CCLabelTTF *labelHelp = [CCLabelTTF labelWithString:@"Help" fontName:@"Helvetica-BoldOblique" fontSize:30];
        [labelHelp setPosition:ccp(160, 410)];
        [self addChild:labelHelp];
                                 
        // Description
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"The game of fifteen consist of a 4x4 grid with one tile out and 15 playable tiles. The tiles start as 1 to 15 and they are mixed up. The goal of the game is to then rearrange the tiles back into the original 1 to 15 order. In this version of fifteen instead of tiles of 1 to 15 they are replaced with live feed from the camera and your objective is to get the video tiles rearranged so that the video feed looks normal." dimensions:CGSizeMake(300.0, 250.0) alignment:UITextAlignmentLeft fontName:@"Helvetica-BoldOblique" fontSize:12];
        [label setAnchorPoint:ccp(0,0)];
        [label setPosition:ccp(10, 140)];
        [self addChild:label];
        
        // New Game
        CCSprite *spNewGame = [CCSprite spriteWithFile:@"New-game.png"];
        [spNewGame setPosition:ccp(30, 230)];
        [self addChild:spNewGame];        
        CCLabelTTF *labelNewGame = [CCLabelTTF labelWithString:@"- Push this button to start a new game." fontName:@"Helvetica-BoldOblique" fontSize:12];
        [labelNewGame setAnchorPoint:ccp(0, 0)];
        [labelNewGame setPosition:ccp(60, 230-6)];
        [self addChild:labelNewGame];        
        
        // Streaming
        CCSprite *spStreaming = [CCSprite spriteWithFile:@"streaming.png"];
        [spStreaming setPosition:ccp(30, 170)];
        [self addChild:spStreaming];        
        CCLabelTTF *labelStreaming = [CCLabelTTF labelWithString:@"- Turn live feed on or off." fontName:@"Helvetica-BoldOblique" fontSize:12];
        [labelStreaming setAnchorPoint:ccp(0, 0)];
        [labelStreaming setPosition:ccp(60, 170-6)];
        [self addChild:labelStreaming];        
        
        // Flip Camera
        CCSprite *spFlipCamera = [CCSprite spriteWithFile:@"flip-cam.png"];
        [spFlipCamera setPosition:ccp(30, 110)];
        [self addChild:spFlipCamera];        
        CCLabelTTF *labelFlipCamera = [CCLabelTTF labelWithString:@"- Switch from back camera to front if device has front camera." dimensions:CGSizeMake(320-60-5, 36) alignment:UITextAlignmentLeft fontName:@"Helvetica-BoldOblique" fontSize:12];
        [labelFlipCamera setAnchorPoint:ccp(0, 0)];
        [labelFlipCamera setPosition:ccp(60, 110-25)];
        [self addChild:labelFlipCamera];        
        
        // Turn Sound on and off.
        CCSprite *spSound = [CCSprite spriteWithFile:@"sound.png"];
        [spSound setPosition:ccp(30, 50)];
        [self addChild:spSound];        
        CCLabelTTF *labelSound = [CCLabelTTF labelWithString:@"- Turn sound on or off." fontName:@"Helvetica-BoldOblique" fontSize:12];
        [labelSound setAnchorPoint:ccp(0, 0)];
        [labelSound setPosition:ccp(60, 50-6)];
        [self addChild:labelSound];        
                        
        // Begin a Transisition.
        [self setPosition:ccp(0, size.height)];
        CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.3 position:ccp(0,480-438)];
        [self runAction:moveTo];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
