//
//  TouchPoint.m
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TouchPoint.h"


@implementation TouchPoint

-(id) initTouch: (UITouch *) _touch {
    if( (self=[super init])) {   
        touch = _touch;
        ptDown = [self getTouchPosition];	
    }
    
	return self;	
}

-(CGPoint) getTouchDownPosition {
	return ptDown;
}

-(CGPoint) getTouchPosition {
    return [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
}

-(bool) isTouch: (UITouch *)_touch {
	if (touch == _touch)
		return true;
	return false;
}

@end
