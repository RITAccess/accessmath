//
//  QRScanner.m
//  AccessLecture
//
//  Created by Michael Timbrook on 7/11/13.
//
//

#import "QRScanner.h"

@interface QRScanner ()

@property (nonatomic, retain) AVCaptureMetadataOutput *metaData;

@end

@implementation QRScanner
{
    AVCaptureSession *session;
    dispatch_queue_t _session_queue;
}

- (id)init
{
    self = [super init];
    if (self) {
        // init
        _session_queue = dispatch_queue_create("edu.rit.session", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (AVCaptureSession *)session
{
    return session;
}

- (void)setUpSession
{
    session = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *videoIn = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
	if ([session canAddInput:videoIn])
		[session addInput:videoIn];
    
    _metaData = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadata_queue = dispatch_queue_create("edu.rit.qrscan", DISPATCH_QUEUE_SERIAL);
    [_metaData setMetadataObjectsDelegate:self queue:metadata_queue];
    
    if ([session canAddOutput:_metaData])
        [session addOutput:_metaData];
    
    if ([[_metaData availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
        _metaData.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    } else {
        // TODO tear down
        NSLog(@"Failed");
    }
    
    [[_metaData connectionWithMediaType:AVMediaTypeMetadata] setEnabled:YES];
    
}

- (void)startCapture
{
    dispatch_sync(_session_queue, ^{
        [self setUpSession];
        [session startRunning];
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *meta in metadataObjects) {
        if ([meta isKindOfClass:[AVMetadataObjectTypeFace class]]) {
            NSLog(@"Face!");
        }
    }
}

@end
