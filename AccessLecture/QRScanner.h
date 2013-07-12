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
 * Start the QR capture with a scan completion handler
 * @param completion Scan did finish block
 */
- (void)startCaptureWithCompletion:(void(^)(NSDictionary *))completion;

/**
 * @return The current AVCaptureSession
 */
- (AVCaptureSession *)session;


@end
