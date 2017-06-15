//
//  VideoCamera.h
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLayerSpriteManager.h"

@interface VideoCamera : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *session;
    uint8_t *vidBuffer;
    int vidWidth;
    int vidHeight;
    bool cameraRunning;
    bool useFrontCamera;
}

@property(readonly) bool cameraRunning;

@property(readwrite) bool useFrontCamera;

// From the AVCaptureVideoDataOutputSampleBufferDelegate
-(void) startCameraCapture;
-(void) stopCameraCapture;

-(void) _convertBGRA8_to_RGBA8:(uint8_t *)buf width:(int)width height:(int)height;

-(void) update:(ccTime)delta;

// http://stackoverflow.com/questions/5886719/what-is-the-front-cameras-deviceuniqueid

-(AVCaptureDevice *)frontFacingCameraIfAvailable;

-(bool) isFrontCameraAvailable;

@end
