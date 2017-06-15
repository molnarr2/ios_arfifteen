//
//  GameLayer.h
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "GameLayerSpriteManager.h"
#import "VideoCamera.h"
#import "Puzzle.h"
#import "TouchPoint.h"
#import "HelpLayer.h"

#define kHelpTag 12039

// GameLayer
@interface GameLayer : CCLayer <UIAlertViewDelegate>
{
    VideoCamera *videoCamera;
    Puzzle *puzzle;
    bool touchActive;
    CGPoint ptDown;
    CCMenuItemToggle *itemStreaming;
    CCMenuItemToggle *itemFlipCamera;
    CCMenuItemToggle *itemSound;
    
    TouchPoint *touchPoint;
    HelpLayer *helpLayer;
    bool helpScreenOn;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

-(void) update:(ccTime)delta;

-(void) onMenuItemNewGame: (id) sender;

-(void) onMenuItemStreaming: (id) sender;

-(void) onMenuItemFlipCamera: (id) sender;

-(void) onMenuItemSettings: (id) sender;

-(void) onMenuItemHelp: (id) sender;

-(void) onMenuItemSound: (id) sender;

-(void)_removeHelpLayer;

-(void) onRemoveHelp;

@end
