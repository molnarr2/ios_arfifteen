//
//  VideoCamera.m
//  AR Fifteen
//
//  Created by Robert Molnar 2 on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoCamera.h"


@implementation VideoCamera

@synthesize cameraRunning;
@synthesize useFrontCamera;

-(void) startCameraCapture
{
    // start capturing frames
	// Create the AVCapture Session
	session = [[AVCaptureSession alloc] init];
	
	// Get the default camera device
	AVCaptureDevice* camera = nil;
    
    if (useFrontCamera)
        camera = [self frontFacingCameraIfAvailable];
    else
        camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
	// Create a AVCaptureInput with the camera device
	NSError *error=nil;
	AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
	if (cameraInput == nil) {
		NSLog(@"Error to create camera capture:%@",error);
	}
	
	// Set the output
	AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
	// create a queue to run the capture on
	dispatch_queue_t captureQueue=dispatch_queue_create("catpureQueue", NULL);
	
	// setup our delegate
	[videoOutput setSampleBufferDelegate:self queue:captureQueue];
    
	// configure the pixel format
	videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey,
                                 nil];
    
	// and the size of the frames we want
	[session setSessionPreset:AVCaptureSessionPresetMedium];
    
	// Add the input and output
	[session addInput:cameraInput];
	[session addOutput:videoOutput];
	
	// Start the session
	[session startRunning];		
    
    cameraRunning = true;
    
//    AVCaptureConnection *vidConnection = [[videoOutput connections] objectAtIndex:1];
//    [vidConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
}

-(void) stopCameraCapture
{
    cameraRunning = false;
    [session stopRunning];
	[session release];
	session=nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // this is the image buffer
    CVImageBufferRef cvimgRef = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the image buffer
    CVPixelBufferLockBaseAddress(cvimgRef,0);
    // access the data
    int width=CVPixelBufferGetWidth(cvimgRef);
    int height=CVPixelBufferGetHeight(cvimgRef);
    // get the raw image bytes
    uint8_t *buf=(uint8_t *) CVPixelBufferGetBaseAddress(cvimgRef);
    // size_t bprow=CVPixelBufferGetBytesPerRow(cvimgRef);
    
    // Copy the raw image bytes.
    int bufferSize = sizeof(uint8_t) * width * height * 4;
    if (vidBuffer == nil) {
        vidBuffer = malloc(bufferSize); // The 4 is RGBA channels, the size of each one is the uint_8 size.
    }
    
    @synchronized(self) {
        memcpy(vidBuffer, buf, bufferSize);
        vidWidth = width;
        vidHeight = height;
        [self _convertBGRA8_to_RGBA8:vidBuffer width:vidWidth height:vidHeight];
    }
}

-(void) update:(ccTime)delta
{
    if (!cameraRunning)
        return;
    
    @synchronized(self) {
        [[GameLayerSpriteManager shared] square_updateTextureFromVideoBuffer:vidBuffer width:vidWidth height:vidHeight];
    }
}

-(void) _convertBGRA8_to_RGBA8:(uint8_t *)buf width:(int)width height:(int)height
{
    // The B and R need to be swapped.
    int pixels = width * height;
    for (int i=0; i < pixels;i++) {
        int pos = i * 4;
        int blue = buf[pos];
        int red = buf[pos+2];
        buf[pos] = red;
        buf[pos+2] = blue;
    }
}

-(AVCaptureDevice *)frontFacingCameraIfAvailable
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionFront)
        {
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if ( ! captureDevice)
    {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

-(bool) isFrontCameraAvailable
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionFront)
        {
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if ( ! captureDevice)
    {
        return false;
    }

    return true;   
}


@end
