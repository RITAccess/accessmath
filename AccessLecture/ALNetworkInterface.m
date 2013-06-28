//
//  ALNetworkInterface.m
//  AccessLecture
//
//  Created by Michael Timbrook on 5/30/13.
//
//

#import "ALNetworkInterface.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"


@implementation ALNetworkInterface {
    
    SocketIO *socketConnection;
    
    // Completion Handles
    void (^lectureRequest)(Lecture *lecture, BOOL found);
    
    // For connection
    void (^connected)(BOOL);
}

@synthesize connectionURL = connectionURL;

/**
 * Init - set up socket
 */
- (id)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        connectionURL = url;
    }
    return self;
}

#pragma mark Accessing Lecture

/**
 * Download an intire lecture from server
 */
- (void)getFullLecture:(NSString *)lectureName completion:(void (^)(Lecture *lecture, BOOL found))handle
{
    lectureRequest = handle;
    NSLog(@"Requesting %@", lectureName);
    [socketConnection sendEvent:@"lecture-request" withData:lectureName];
}

- (void)getFullLecture:(NSString *)lectureName
{
    [self getFullLecture:lectureName completion:^(Lecture *lecture, BOOL found) {
        if([_delegate respondsToSelector:@selector(didFinishDownloadingLecture:)]) {
            [_delegate didFinishDownloadingLecture:lecture]; 
        }
    }];
}

/**
 * Request to get streaming updates sent to the delegate
 */
- (void)requestAccessToLectureSteam:(NSString *)name
{
    [socketConnection sendEvent:@"steaming-request" withData:name];
}

#pragma mark Using Interface

/**
 * Connect to the LectureConnect server
 */
- (void)connect
{    
    if ([socketConnection isConnected])
        return;
    socketConnection = [[SocketIO alloc] initWithDelegate:self];
//    [socketConnection setUseSecure:YES];
    [socketConnection connectToHost:connectionURL onPort:9000];
    
}

- (void)connectCompletion:(void (^)(BOOL success))handle
{    
    [self connect];
    connected = handle;
}

- (void)disconnect
{
    [socketConnection disconnect];
}

#pragma mark Status

- (BOOL)connected
{
    return socketConnection.isConnected;
}

- (BOOL)isConnecting
{
    return socketConnection.isConnecting;
}

#pragma mark Socket Methods

/**
 * Receive Message from server
 */
- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    
    // Lecture Response
    if ([packet.name isEqualToString:@"lecture-response"]) {
        lectureRequest([[Lecture alloc] initWithPacket:packet], true);
    }
    // Failure Response on lecture request
    if ([packet.name isEqualToString:@"lecture-response-failed"]) {
        lectureRequest(nil, false);
    }
    // Recive update
    if ([packet.name isEqualToString:@"update"]) {
        NSString *data = [packet.dataAsJSON valueForKeyPath:@"args"][0];
        if ([_delegate respondsToSelector:@selector(didRecieveUpdate:)]) {
            [_delegate didRecieveUpdate:data];
        }
    }
    // On Termination
    if ([packet.name isEqualToString:@"termination"]) {
        NSString *message = [[packet.dataAsJSON valueForKeyPath:@"args"] valueForKeyPath:@"message"][0];
        NSString *status = [[packet.dataAsJSON valueForKeyPath:@"args"] valueForKeyPath:@"status"][0];
        NSLog(@"Stream ended with status %@ with message %@", status, message);
    }
    // Name request
    if ([packet.name isEqualToString:@"get-name"]) {
        [socketConnection sendEvent:@"set-name" withData:[[UIDevice currentDevice] name]];;
    }
    
}

/**
 * Did open connection
 */
- (void)socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connection open");
    connected(TRUE);
}

/**
 * Did close a connection
 */
- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    _wasConnected = NO;
}

/**
 * Failed connection
 */
- (void)socketIO:(SocketIO *)socket onError:(NSError *)error
{
    connected(FALSE);
}

@end
