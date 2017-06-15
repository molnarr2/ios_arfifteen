//
//  GameConfig.h
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/7/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationNone

// The size of a video square:
#define GAME_VID_SQUARE_SIZE 80.0
#define GAME_VID_SQUARE_HALF 40.0

// The offset of y to the start of the puzzle
#define GAME_PUZZLE_OFFSET_Y 60.0

bool soundEnabled;

#endif // __GAME_CONFIG_H