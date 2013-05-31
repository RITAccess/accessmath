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
    NSLog(@"Message: %@", packet.name);
    
}

/**
 * Did open connection
 */
- (void) socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connection open");
    [socketConnection sendEvent:@"lecture-request" withData:nil];
}

@end
