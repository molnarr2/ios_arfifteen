//
//  TouchPoint.h
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TouchPoint;
@class TouchSystem;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
// This is class handles TouchPoints.
@interface TouchSystem : NSObject
{
	// Practically 4 fingers can exist on the screen. 
	TouchPoint *touches[4];
	// Number of active touches.
	int activeCount;
}

// Create the class.
-(id) initTouchSystem;

// Add the touch to the system. Should only be called by the class that directly handles the touches.
// @param touch is the UITouch that will be added. Can only handle 4 touches at a time. Others are discarded.
-(void) addTouch: (UITouch *)touch;
// This will flag the TouchPoint associated with the touch as 
-(void) flagTouchForRemove: (UITouch *)touch;
// This will remove the touch from the system.
// @param touch is the UITouch that will be rmoeved.
-(void) removeTouch: (UITouch *)touch;


@end
*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// This class is used to handle the individual touches.
@interface TouchPoint : NSObject {
	UITouch *touch;
	CGPoint ptDown;
	float timeDown;
	// This is true if the touch is the first time created when on finger down is called.
	bool firstTouch;
}

-(id) initTouch: (UITouch *) _touch;

// @return the touch first position down.
-(CGPoint) getTouchDownPosition;

// @return the touch current position down.
-(CGPoint) getTouchPosition;

// @return true if the touch is self's touch.
-(bool) isTouch: (UITouch *)_touch;

@end
