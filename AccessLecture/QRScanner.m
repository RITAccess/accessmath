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
    void(^didFinishWithInfo)(NSDictionary *);
}

- (id)init
{
    self = [super init];
    if (self) {
        _session_queue = dispatch_queue_create("edu.rit.session", DISPATCH_QUEUE_SERIAL);
        session = [[AVCaptureSession alloc] init];
    }
    return self;
}

- (AVCaptureSession *)session
{
    return session;
}

- (void)setUpSession
{
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *videoIn = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
	if ([session canAddInput:videoIn]){
		[session addInput:videoIn];
    }
    
    _metaData = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadata_queue = dispatch_queue_create("edu.rit.qrscan", DISPATCH_QUEUE_SERIAL);
    [_metaData setMetadataObjectsDelegate:self queue:metadata_queue];
    
    if ([session canAddOutput:_metaData]){
        [session addOutput:_metaData];
    }
    
}

- (void)tearDown
{
    dispatch_sync(_session_queue, ^{
        [session stopRunning];
    });
}

- (void)startCaptureWithCompletion:(void(^)(NSDictionary *))completion
{
    didFinishWithInfo = completion;
    dispatch_sync(_session_queue, ^{
        [self setUpSession];
        [session startRunning];
        
        if ([[_metaData availableMetadataObjectTypes] containsObject:@"org.iso.QRCode"]) { // This is not optimal but the string const doesn't exist on 6.1
            _metaData.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        } else {
            NSLog(@"QRScanning is not available");
            [self tearDown];
        }
        
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *meta in metadataObjects) {
        if ([meta isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *code = (AVMetadataMachineReadableCodeObject *)meta;
            
            NSError *error;
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[code.stringValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            if (!error && [[data allKeys] containsObject:@"url"] && [[data allKeys] containsObject:@"lecture"]){
                NSLog(@"Connect to %@ in class %@ read from QRCode", data[@"url"], data[@"lecture"]);
                [session removeOutput:_metaData];
                _metaData = nil;
                [self tearDown];
                didFinishWithInfo(data);
            }
        }
    }
}

@end
