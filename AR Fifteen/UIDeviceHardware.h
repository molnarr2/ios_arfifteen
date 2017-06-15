//
//  UIDeviceHardware.h
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//  UIDeviceHardware.h
//
//  Used to determine EXACT version of device software is running on.

#import <Foundation/Foundation.h>

@interface UIDeviceHardware : NSObject 

- (NSString *) platform;
- (NSString *) platformString;

@end

