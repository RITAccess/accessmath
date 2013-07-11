//
//  QRScanner.h
//  AccessLecture
//
//  Created by Michael Timbrook on 7/11/13.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface QRScanner : NSObject <AVCaptureMetadataOutputObjectsDelegate>

/**
 * Sets up a new capture session for scanning QR.
 */
- (void)setUpSession;

/**
 * Start the QR capture
 */
- (void)startCapture;

/**
 * @return The current AVCaptureSession
 */
- (AVCaptureSession *)session;


@end
