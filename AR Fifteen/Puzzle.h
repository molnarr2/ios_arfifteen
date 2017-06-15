//
//  Puzzle.h
//  AR Fifteen
 //
//  Created by Robert Molnar 2 on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLayerSpriteManager.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"


#define kPuzzleSize 4
#define kMapNotUsed -1
#define kPuzzleSelectedMax 3

#define kPuzzleMovementLeft 1
#define kPuzzleMovementRight 2
#define kPuzzleMovementUp 3
#define kPuzzleMovementDown 4

struct Pos {
    int x;
    int y;
};
typedef struct Pos   Pos;

struct SelectedBlock {
    bool used; // True if the block is used.
    int x; // The map reference.
    int y; // The map reference.
    int spriteIndex; // The current spirit this block represents.
};
typedef struct SelectedBlock SelectedBlock;

@interface Puzzle : NSObject <UIAlertViewDelegate> {
    // Each position represents the index of the sprite it currently represents. 0-14. -1 means empty.
    int map[kPuzzleSize][kPuzzleSize];
    
    // True if blocks have been selected to move.
    bool blockSelected;
    SelectedBlock selectedBlockes[kPuzzleSelectedMax];
    CGPoint ptDown; // Initial place the touch came down at.
    int movement; // Which movement from initial point can the blocks go.
    bool soundPlayed;
    bool endGameConditionMeet;
    bool gameover;
}

@property(readonly) bool endGameConditionMeet;

-(void)resetPuzzle;

-(void)onTouchDown:(CGPoint)ptTouch;

-(void)onTouchMove:(CGPoint)ptTouch;

-(void)onTouchEnd:(CGPoint)ptTouch;

/** @return the current blank position. */
-(Pos)_currentBlank;

/** @return the offset movement for the selected blockes. */
-(CGPoint)_movementOffset:(CGPoint)ptTouch;

-(void)onCallPlaySound;

-(void)calculateEndGameCondition;

@end
