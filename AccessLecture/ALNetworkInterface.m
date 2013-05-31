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
    NSString *connectionURL;
    
    // Completion Handles
    void (^lectureRequest)(id lecture);
    
    // For testing
    void (^onMessage)(NSString *);
}

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

#pragma mark Accessing Lecture Requests

- (void)getFullLecture:(NSString *)lectureName completion:(void (^)(id lecture))handle{
    lectureRequest = handle;
    [socketConnection sendEvent:@"lecture-request" withData:lectureName];
}


#pragma mark Using Interface

- (void)connect {
    
    socketConnection = [[SocketIO alloc] initWithDelegate:self];
    NSLog(@"Connecting to %@", connectionURL.description);
    [socketConnection connectToHost:connectionURL.description onPort:9000];

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
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    if ([packet.name isEqualToString:@"lecture-response"]) {
        lectureRequest(packet.data);
    }
    
}

/**
 * Did open connection
 */
- (void) socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connection open");
}

@end
