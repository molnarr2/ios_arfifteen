//
//  GameLayer.m
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"


// GameLayer implementation
@implementation GameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	    
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        videoCamera = [[VideoCamera alloc] init];
        videoCamera.useFrontCamera = false;
        [videoCamera startCameraCapture];
        
        // Attach sprit es to layer.
        [[GameLayerSpriteManager shared] attachSpritesToLayer:self];        
        
        self.isTouchEnabled = YES;
        
        puzzle = [[Puzzle alloc] init];
        
        touchActive = false;
        
        CCSprite *background = [CCSprite spriteWithFile:@"Game_screen.png"];
        [background setAnchorPoint:ccp(0,0)];
        [self addChild:background z:-1];
        
        // New Game Menu Item
        CCSprite *newGameNormal = [CCSprite spriteWithFile:@"New-game.png"];
        newGameNormal.color = ccWHITE;
        CCSprite *newGameSelected = [CCSprite spriteWithFile:@"New-game.png"];
        newGameSelected.color = ccGRAY;        
        CCMenuItemSprite *itemNewGame = [CCMenuItemSprite itemFromNormalSprite:newGameNormal selectedSprite:newGameSelected target:self selector:@selector(onMenuItemNewGame:)];
        
        // Streaming / Still
        CCMenuItemImage *streaming = [CCMenuItemImage itemFromNormalImage:@"streaming.png" selectedImage:@"streaming.png" target:self selector:@selector(onMenuItemFlipCamera:)];
        CCMenuItemImage *streamingOff = [CCMenuItemImage itemFromNormalImage:@"streaming-off.png" selectedImage:@"streaming-off.png" target:self selector:@selector(onMenuItemFlipCamera:)];
        itemStreaming = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onMenuItemStreaming:) items:streaming, streamingOff, nil] retain];
        
        // Flip Camera
        if ([videoCamera isFrontCameraAvailable]) {
        CCMenuItemImage *flipCameraBack = [CCMenuItemImage itemFromNormalImage:@"flip-cam.png" selectedImage:@"flip-cam.png" target:self selector:@selector(onMenuItemFlipCamera:)];
        CCMenuItemImage *flipCameraFront = [CCMenuItemImage itemFromNormalImage:@"flip-cam-front.png" selectedImage:@"flip-cam-front.png" target:self selector:@selector(onMenuItemFlipCamera:)];
         itemFlipCamera = [CCMenuItemToggle itemWithTarget:self selector:@selector(onMenuItemFlipCamera:) items:flipCameraBack, flipCameraFront, nil];
        }
        
        // Sound on/off
        CCMenuItemImage *soundOn = [CCMenuItemImage itemFromNormalImage:@"sound-on.png" selectedImage:@"sound-on.png" target:self selector:@selector(onMenuItemFlipCamera:)];
        CCMenuItemImage *soundOff = [CCMenuItemImage itemFromNormalImage:@"sound.png" selectedImage:@"sound.png" target:self selector:@selector(onMenuItemFlipCamera:)];
        itemSound = [CCMenuItemToggle itemWithTarget:self selector:@selector(onMenuItemSound:) items:soundOn, soundOff, nil];
        
        // Help
        CCSprite *helpNormal = [CCSprite spriteWithFile:@"Help.png"];
        helpNormal.color = ccWHITE;
        CCSprite *helpSelected = [CCSprite spriteWithFile:@"Help.png"];
        helpSelected.color = ccGRAY;        
        CCMenuItemSprite *itemHelp = [CCMenuItemSprite itemFromNormalSprite:helpNormal selectedSprite:helpSelected target:self selector:@selector(onMenuItemHelp:)];
        
        // Settings
  /*      CCSprite *settingsNormal = [CCSprite spriteWithFile:@"setting.png"];
        settingsNormal.color = ccWHITE;
        CCSprite *settingsSelected = [CCSprite spriteWithFile:@"setting.png"];
        settingsSelected.color = ccGRAY;        
        CCMenuItemSprite *itemSettings = [CCMenuItemSprite itemFromNormalSprite:settingsNormal selectedSprite:settingsSelected target:self selector:@selector(onMenuItemSettings:)];
    */
        
        CCMenu *menu;
        if ([videoCamera isFrontCameraAvailable])
            menu = [CCMenu menuWithItems:itemNewGame, itemStreaming, itemFlipCamera, itemSound, nil];
        else
            menu = [CCMenu menuWithItems:itemNewGame, itemStreaming, itemSound, nil];
            
        [menu setPosition:ccp(320 * 0.5, 480 - 40)];
//        [menu alignItemsHorizontallyWithPadding:17];
        [menu alignItemsHorizontallyWithPadding:22];
        [self addChild:menu];        
        
        CCMenu *menuHelp = [CCMenu menuWithItems:itemHelp, nil];
        [menuHelp setPosition:ccp(296, 480 - 464)];
        [self addChild:menuHelp];
        
        // Scedules itself to be called every frame.
        [self scheduleUpdate];
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
    [[GameLayerSpriteManager shared] removeSpritesFromLayer:self];
    
    [puzzle release];
    puzzle = nil;
    
    [videoCamera stopCameraCapture];
    [videoCamera release];
    videoCamera = nil;
    
    [itemStreaming release];
    itemStreaming = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (helpScreenOn) {
        [self _removeHelpLayer];
        return;
    }
    
    NSEnumerator *enumerator = [touches objectEnumerator];
	UITouch *touch;
	
	// Find a touch that isn't being used.
	while ((touch = [enumerator nextObject])) {
        // Begin a touch.
        if (touchPoint == nil) {
            touchPoint = [[TouchPoint alloc] initTouch:touch];
            [puzzle onTouchDown:[touchPoint getTouchPosition]];
            break;
        }
    }
}


- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSEnumerator *enumerator = [touches objectEnumerator];
	UITouch *touch;
	
	// See if the touch is ours.
	while ((touch = [enumerator nextObject])) {
        if ([touchPoint isTouch:touch]) {
            [puzzle onTouchMove:[touchPoint getTouchPosition]];
            break;
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSEnumerator *enumerator = [touches objectEnumerator];
	UITouch *touch;
	
	// See if the touch is ours.
	while ((touch = [enumerator nextObject])) {
        if ([touchPoint isTouch:touch]) {
            [puzzle onTouchEnd:[touchPoint getTouchPosition]];
            [touchPoint release];
            touchPoint = nil;
            break;
        }
    }
}


- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self ccTouchesEnded:touches withEvent:event];
}

-(void) update:(ccTime)delta
{
    [videoCamera update:delta];
}

-(void) onMenuItemNewGame: (id) sender
{
    if (helpScreenOn) {
        [self _removeHelpLayer];
        return;
    }
    
    UIView *view = [[CCDirector sharedDirector] openGLView];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Game" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [view addSubview: alert];
    
    [alert show];
    [alert release];
}

-(void) onMenuItemStreaming: (id) sender
{
    if (helpScreenOn) {
        int selected = [itemStreaming selectedIndex] == 1 ? 0 : 1;             
        [itemStreaming setSelectedIndex:selected];
        [self _removeHelpLayer];
        return;
    }
    
    if (videoCamera.cameraRunning)
        [videoCamera stopCameraCapture];
    else
        [videoCamera startCameraCapture];
}

-(void) onMenuItemFlipCamera: (id) sender
{
    if (helpScreenOn) {
        int selected = [itemFlipCamera selectedIndex] == 1 ? 0 : 1;             
        [itemFlipCamera setSelectedIndex:selected];
        [self _removeHelpLayer];
        return;
    }
    
    if (videoCamera.useFrontCamera)
        videoCamera.useFrontCamera = false;
    else
        videoCamera.useFrontCamera = true;
    
    [videoCamera stopCameraCapture];
    [videoCamera startCameraCapture];    
    [itemStreaming setSelectedIndex:0];
}

-(void) onMenuItemSound: (id) sender
{
    if (helpScreenOn) {
        int selected = [itemSound selectedIndex] == 1 ? 0 : 1;             
        [itemSound setSelectedIndex:selected];
        [self _removeHelpLayer];
        return;
    }
    
    if (soundEnabled)
        soundEnabled = false;
    else
        soundEnabled = true;
}

-(void) onMenuItemSettings: (id) sender
{
    
}

-(void) onMenuItemHelp: (id) sender
{  
    if (helpScreenOn) {
        [self _removeHelpLayer];
        return;
    }
    
    if (helpLayer != nil)
        return;
    
    helpLayer = [[HelpLayer node] retain];
    [self addChild:helpLayer z:1 tag:kHelpTag];
    helpScreenOn = true;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // OK button on the ask user for new game?
    if (buttonIndex == 1) {
        [puzzle resetPuzzle];
    }
}

-(void)_removeHelpLayer
{
    helpScreenOn = false;
    
    // Begin a Transisition Out.
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.1 position:ccp(0,480)];
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(onRemoveHelp)];
    CCSequence *seq = [CCSequence actions:moveTo, func, nil];
    [helpLayer runAction:seq];
}

-(void) onRemoveHelp
{
    [self removeChild:helpLayer cleanup:TRUE];
    [helpLayer release];
    helpLayer = nil;
}

@end

