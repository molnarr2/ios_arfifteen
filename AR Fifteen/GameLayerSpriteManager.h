//
//  GameLayerSpriteManager.h
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"

#define kSquaresCount 16


@interface GameLayerSpriteManager : NSObject {
    CCSprite *squares[kSquaresCount];
    CCTexture2D *squareTexture;
}

+(GameLayerSpriteManager *)shared;

/** This will attach the sprites to the layer. 
 */
-(void)attachSpritesToLayer:(CCLayer *)layer;

/** Remove sprites from layer.
 */
-(void)removeSpritesFromLayer:(CCLayer *)layer;

-(void) square_updateTextureFromVideoBuffer:(uint8_t *)buf width:(int)width height:(int)height;

-(void) square_setPosition:(int)index newPosition:(CGPoint)newPosition;

-(void) square_runAction:(int) index action:(CCAction *)action;

@end
