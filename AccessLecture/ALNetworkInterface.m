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
    
    // For testing
    void (^onMessage)(NSString *);
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
- (void)getFullLecture:(NSString *)lectureName completion:(void (^)(Lecture *lecture, BOOL found))handle{
    lectureRequest = handle;
    NSLog(@"Requesting %@", lectureName);
    [socketConnection sendEvent:@"lecture-request" withData:lectureName];
}

/**
 * Request to get streaming updates sent to the delegate
 */
- (void)requestAccessToLectureSteam:(NSString *)name {
    [socketConnection sendEvent:@"steaming-request" withData:name];
}

#pragma mark Using Interface

/**
 * Connect to the LectureConnect server
 */
- (void)connect {
    
    if ([socketConnection isConnected])
        return;
    
    socketConnection = [[SocketIO alloc] initWithDelegate:self];
    NSLog(@"Connecting to %@", connectionURL.description);
    [socketConnection connectToHost:connectionURL.description onPort:9000];
    _wasConnected = YES;
    
}

- (void)connectCompletion:(void (^)(BOOL success))handle {
    
    [self connect];
    handle(true);
    
}

- (void)disconnect {
    [socketConnection disconnect];
}

- (void)onMessageBlock:(void (^) (NSString *response))hande {
    onMessage = hande;
}

- (void)sendData:(id)data {
    [socketConnection sendEvent:@"" withData:data];
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
        NSLog(@"Update");
        NSString *data = [[packet.dataAsJSON valueForKeyPath:@"args"] valueForKeyPath:@"message"][0]; // Testing use
        if ([_delegate respondsToSelector:@selector(didRecieveUpdate)]) {
            [_delegate didRecieveUpdate:data];
        }
    }
    
}

/**
 * Did open connection
 */
- (void)socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connection open");
}

/**
 * Did close a connection
 */
- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    _wasConnected = NO;
}

@end
