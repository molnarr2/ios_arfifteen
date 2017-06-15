//
//  GameLayerSpriteManager.m
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayerSpriteManager.h"


@implementation GameLayerSpriteManager


static GameLayerSpriteManager* _sharedGameLayerManager = nil;

-(id) init
{
    if ((self = [super init])) {
        // Create the texture the squares come from this is used to set the video frame to. The video frame size will be 
        uint8_t *buffer = malloc(sizeof(uint8_t) * 480 * 360 * 4); // Create a RGBA buffer.        
        squareTexture = [[CCTexture2D alloc] initWithData:buffer pixelFormat:kCCTexture2DPixelFormat_RGBA8888 pixelsWide:480 pixelsHigh:360 contentSize:CGSizeMake(480, 360)];
        
        // Create the square sprites from the empty texture.
        int index = 0;
        for (int y=0; y < 4; y++) {
            for (int x=0; x < 4; x++) {
                squares[index] = [[CCSprite spriteWithTexture:squareTexture rect:CGRectMake(x * GAME_VID_SQUARE_SIZE, y * GAME_VID_SQUARE_SIZE, GAME_VID_SQUARE_SIZE, GAME_VID_SQUARE_SIZE)] retain];
                [squares[index] setPosition:ccp(-100, -100)];
                
                //[squares[index] setPosition:ccp(x * GAME_VID_SQUARE_SIZE + GAME_VID_SQUARE_HALF, GAME_PUZZLE_OFFSET_Y + 
                //                                (3 - y) * GAME_VID_SQUARE_SIZE + GAME_VID_SQUARE_HALF)];
                index++;
                if (index == kSquaresCount)
                    break;
            }
        }
        
        [squareTexture release];
        squareTexture = nil;        
    }
    
    return self;
}

+(id)alloc
{
    @synchronized([GameLayerSpriteManager class]) {
        NSAssert(_sharedGameLayerManager == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedGameLayerManager = [super alloc];
        return _sharedGameLayerManager;
    }
    
    return nil;
}

+(GameLayerSpriteManager *)shared
{
    @synchronized([GameLayerSpriteManager class]) {
        if (!_sharedGameLayerManager)
            [[self alloc] init];
        return _sharedGameLayerManager;
    }
    
    return nil;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    // This is never called.
    
	// don't forget to call "super dealloc"
	[super dealloc];
}


-(void)attachSpritesToLayer:(CCLayer *)layer
{
    // Attach the squares to the layer.
    for (int i=0; i < kSquaresCount; i++)
        [layer addChild:squares[i]];
}

-(void)removeSpritesFromLayer:(CCLayer *)layer
{
    for (int i=0; i < kSquaresCount; i++)
        [layer removeChild:squares[i] cleanup:false];
}

-(void) square_updateTextureFromVideoBuffer:(uint8_t *)buf width:(int)width height:(int)height
{    
    squareTexture = [[CCTexture2D alloc] initWithData:buf pixelFormat:kCCTexture2DPixelFormat_RGBA8888 pixelsWide:width pixelsHigh:height contentSize:CGSizeMake(width, height)];   
    
    for (int i=0; i < kSquaresCount; i++) {
        [squares[i] setTexture:squareTexture];
        [squares[i] setRotation:90];
    }
    
    // Release the texture.
    [squareTexture release];
    squareTexture = nil;
}

-(void) square_setPosition:(int)index newPosition:(CGPoint)newPosition
{
    [squares[index] setPosition:newPosition];
}

-(void) square_runAction:(int) index action:(CCAction *)action
{
    [squares[index] runAction:action];
}

@end
