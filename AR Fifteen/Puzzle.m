//
//  Puzzle.m
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Puzzle.h"


@implementation Puzzle

@synthesize endGameConditionMeet;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {        
        [self resetPuzzle];
	}
	return self;
}

-(void)resetPuzzle
{
    endGameConditionMeet = false;

    // Set puzzle to in order state.
    int i=0;
    for (int x=kPuzzleSize-1; x >= 0; x--) {
        for (int y=kPuzzleSize-1; y >= 0; y--) {
            map[x][y] = i++;
            if (i == 4)  // This is the bottom right tile get rid of it.
                map[x][y] = -1;
        }
    }
    
    
    // Mix them up a good bit.
    for (int rounds=0; rounds < 50; rounds++) { 
        int oldX = arc4random() % kPuzzleSize;
        int oldY = arc4random() % kPuzzleSize;
        int newX = arc4random() % kPuzzleSize;
        int newY = arc4random() % kPuzzleSize;
                
        int oldIndex = map[oldX][oldY];
        map[oldX][oldY] = map[newX][newY];
        map[newX][newY] = oldIndex;
        
    }
    
  //  map[0][0] = -1;
    
    // Set positions of the sprites now.
    GameLayerSpriteManager *manager = [GameLayerSpriteManager shared];
    for (int x=0; x < kPuzzleSize; x++) {
        for (int y=0; y < kPuzzleSize; y++) {
            if (map[x][y] == -1)
                continue;
            
            [manager square_setPosition:map[x][y] newPosition:CGPointMake(x * GAME_VID_SQUARE_SIZE + GAME_VID_SQUARE_HALF, 
                                                                          GAME_PUZZLE_OFFSET_Y + y * GAME_VID_SQUARE_SIZE + GAME_VID_SQUARE_HALF)];
        }
    }    
}

-(void)onTouchDown:(CGPoint)ptTouch
{
    if (blockSelected)
        return;
    
    // Current hole position.
    Pos hole = [self _currentBlank];
    
    // Determine if current square is valid to move.    
    int xPos = ptTouch.x / 80.0;
    int yPos = (ptTouch.y - GAME_PUZZLE_OFFSET_Y) / GAME_VID_SQUARE_SIZE;
    
    // Position is outside of game.
    if (xPos < 0 || xPos >= kPuzzleSize || yPos < 0 || yPos >= kPuzzleSize)
        return;
    
    // Make sure not on top of the hole.
    if (xPos == hole.x && yPos == hole.y)
        return;
    
    
    // Reset the flag to play a sound.
    soundPlayed = false;
    
    // Now we know for sure blocks have been selected.

    ptDown.x = ptTouch.x;
    ptDown.y = ptTouch.y;
    
    // Clear out the selection blocks.
    for (int i=0; i < kPuzzleSelectedMax; i++)
        memset((void *)&selectedBlockes[i], 0, sizeof (SelectedBlock));
    
    if (hole.y == yPos) {
        blockSelected = true; 

        // Determine the lower of the two numbers to start from. If hole is start then start+1 and end+1.
        int xStart, xEnd;
        if (hole.x < xPos) {
            xStart = hole.x + 1;
            xEnd = xPos + 1;
            movement = kPuzzleMovementLeft;
        } else {
            xStart = xPos;
            xEnd = hole.x;
            movement = kPuzzleMovementRight;
        }
        
        // Each one is now selected.
        for (int x=xStart, i=0; x<xEnd; x++, i++) {
            selectedBlockes[i].used = true;
            selectedBlockes[i].x = x;
            selectedBlockes[i].y = yPos;
            selectedBlockes[i].spriteIndex = map[x][yPos];
        }
        
    } else if (hole.x == xPos) {
        blockSelected = true; 

        // Determine the lower of the two numbers to start from. If hole is start then start+1 and end+1.
        int yStart, yEnd;
        if (hole.y < yPos) {
            yStart = hole.y + 1;
            yEnd = yPos + 1;
            movement = kPuzzleMovementDown;
        } else {
            yStart = yPos;
            yEnd = hole.y;
            movement = kPuzzleMovementUp;
        }
        
        // Each one is now selected.
        for (int y=yStart, i=0; y<yEnd; y++, i++) {
            selectedBlockes[i].used = true;
            selectedBlockes[i].x = xPos;
            selectedBlockes[i].y = y;
            selectedBlockes[i].spriteIndex = map[xPos][y];
        }        
    }    
}


-(void)onTouchMove:(CGPoint)ptTouch
{
    // Nothing selected.
    if (!blockSelected)
        return;

    // Get movement offset.
    CGPoint movementOffset = [self _movementOffset:ptTouch];

    // For all the selected blocks move their sprites from map[x][y] to added xOffset, yOffset.
    GameLayerSpriteManager *manager = [GameLayerSpriteManager shared];
    for (int i=0; i < kPuzzleSelectedMax; i++) {
        if (selectedBlockes[i].used) {
            float xPos = (float)selectedBlockes[i].x * GAME_VID_SQUARE_SIZE + GAME_VID_SQUARE_HALF + movementOffset.x;
            float yPos = (float)selectedBlockes[i].y * GAME_VID_SQUARE_SIZE + GAME_VID_SQUARE_HALF + GAME_PUZZLE_OFFSET_Y + movementOffset.y;
            [manager square_setPosition:selectedBlockes[i].spriteIndex newPosition:ccp(xPos, yPos)];                        
        }
    }    
}

-(void)onTouchEnd:(CGPoint)ptTouch
{
    // Nothing selected.
    if (!blockSelected)
        return;
    
    GameLayerSpriteManager *manager = [GameLayerSpriteManager shared];

    // Get movement offset.
    CGPoint movementOffset = [self _movementOffset:ptTouch];
    int xOffset = 0;
    int yOffset = 0;
    
    // Determine if blocks moved to new position.
    if (movementOffset.x > GAME_VID_SQUARE_HALF) {
        xOffset = 1;
    } else if (movementOffset.x < -GAME_VID_SQUARE_HALF)
        xOffset = -1;
    else if (movementOffset.y > GAME_VID_SQUARE_HALF)
        yOffset = 1;
    else if (movementOffset.y < -GAME_VID_SQUARE_HALF)
        yOffset = -1;        


    // Update the map positions and move the sprite blockes to their new locations.
    bool firstBlock = true;
    for (int i=0; i < kPuzzleSelectedMax; i++) {
        if (selectedBlockes[i].used) {
            // Update map.
            int xNewMapPos = selectedBlockes[i].x + xOffset;
            int yNewMapPos = selectedBlockes[i].y + yOffset;
            map[xNewMapPos][yNewMapPos] = selectedBlockes[i].spriteIndex;
            
            // Move those blockes.
            CGPoint ptMoveTo = CGPointMake(xNewMapPos * GAME_VID_SQUARE_SIZE + GAME_VID_SQUARE_HALF, 
                                           GAME_PUZZLE_OFFSET_Y + yNewMapPos * GAME_VID_SQUARE_SIZE + GAME_VID_SQUARE_HALF);
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.2 position:ptMoveTo];
            // If sound has already been played then don't play it again.
            if (soundPlayed || firstBlock == false)            
                [manager square_runAction:selectedBlockes[i].spriteIndex action:moveTo];
            else {
                // Play the sound once it hits the block.
                CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(onCallPlaySound)];
                CCSequence *seq = [CCSequence actions:moveTo, func, nil];
                [manager square_runAction:selectedBlockes[i].spriteIndex action:seq];  
                soundPlayed = true;
            }

            firstBlock = false;
        }
    }

    // Now update the map position where finger first came down to empty.
    if (xOffset != 0 || yOffset != 0) {
        int xPos = ptDown.x / 80.0;
        int yPos = (ptDown.y - GAME_PUZZLE_OFFSET_Y) / GAME_VID_SQUARE_SIZE;
        map[xPos][yPos] = -1;
    }
    
    [self calculateEndGameCondition];
    
    // No more selected blockes.
    blockSelected = false;

}


-(Pos)_currentBlank
{    
    for (int x=0; x < kPuzzleSize; x++) {
        for (int y=0; y < kPuzzleSize; y++) {
            if (map[x][y]  == -1) {
                Pos pt;
                pt.x = x;
                pt.y = y;
                return pt;
            }
        }
    }
    
    Pos p;
    p.x = -1;
    p.y = -1;
    return p;
}


-(CGPoint)_movementOffset:(CGPoint)ptTouch;
{
    bool maxHit = false;
    
    // The most a movement can go in one direction is GAME_VID_SQUARE_SIZE.
    float xOffset = 0.0;
    float yOffset = 0.0;
    if (movement == kPuzzleMovementLeft) {
        xOffset = ptTouch.x - ptDown.x;
        if (xOffset < -GAME_VID_SQUARE_SIZE) {
            xOffset = -GAME_VID_SQUARE_SIZE;
            maxHit = true;
        }
        if (xOffset > 0){
            xOffset = 0;
            maxHit = true;
        }
    } else if (movement == kPuzzleMovementRight) {
        xOffset = ptTouch.x - ptDown.x;
        if (xOffset > GAME_VID_SQUARE_SIZE) {
            xOffset = GAME_VID_SQUARE_SIZE;  
            maxHit = true;
        }
        if (xOffset < 0) {
            xOffset = 0;
            maxHit = true;
        }
    } else if (movement == kPuzzleMovementDown) {
        yOffset = ptTouch.y - ptDown.y;
        if (yOffset < -GAME_VID_SQUARE_SIZE) {
            yOffset = -GAME_VID_SQUARE_SIZE;
            maxHit = true;
        }
        if (yOffset > 0) {
            yOffset = 0;
            maxHit = true;
        }
    } else if (movement == kPuzzleMovementUp) {
        yOffset = ptTouch.y - ptDown.y;
        if (yOffset > GAME_VID_SQUARE_SIZE) {
            yOffset = GAME_VID_SQUARE_SIZE;  
            maxHit = true;
        }
        if (yOffset < 0) {
            yOffset = 0;
            maxHit = true;
        }
    }
    
    // Determine if sound should be played.
    if (maxHit) {
        if (!soundPlayed) {
            [self onCallPlaySound];
        }
        
        soundPlayed = true;
    } else
        soundPlayed = false;

    return ccp(xOffset, yOffset);
}

-(void)onCallPlaySound
{
    if (soundEnabled)
        [[SimpleAudioEngine sharedEngine] playEffect:@"game_piece_movement_06.wav"];
}

-(void)calculateEndGameCondition
{
    // Don't calculate it again until new game.
    if (endGameConditionMeet)
        return;
    
    int counting = -1;
    for (int x=kPuzzleSize-1; x >= 0; x--) {
        for (int y=kPuzzleSize-1; y >= 0; y--) {
            int index = map[x][y];
            if (index == -1)
                index = 3;
            // counting out of sequence.
            if (index < counting)
                return;
            counting = index;
        }
    }
    
    endGameConditionMeet = true;
    
    if (soundEnabled) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"success_playful_16.wav"];
    }
    
    UIView *view = [[CCDirector sharedDirector] openGLView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle: @"AR Fifteen" message: @"Congratulations! You solved the puzzle!" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [view addSubview: myAlertView];    
    [myAlertView show];
    [myAlertView release];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // Do nothing.
}

@end
