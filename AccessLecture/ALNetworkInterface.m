//
//  ALNetworkInterface.m
//  AccessLecture
//
//  Created by Michael Timbrook on 5/30/13.
//
//

#import "ALNetworkInterface.h"

@implementation ALNetworkInterface {
    
    SRWebSocket *socket;
    NSURL *connectionURL;
    
    // For testing
    void (^onMessage)(NSString *);
}

/**
 * Init - set up socket
 */
- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        connectionURL = url;
    }
    return self;
}

#pragma mark Using Interface

- (void)connect {
    
    socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:connectionURL]];
    [socket setDelegate:self];
    
    NSLog(@"Connecting...");
    [socket open];
}

- (void)onMessageBlock:(void (^) (NSString *response))hande {
    onMessage = hande;
}

- (void)sendData:(id)data {
    [socket send:data];
}

#pragma mark Socket Methods

/**
 * Receive Message from server
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Message: %@", message);
    onMessage(message);
}

/**
 * Did open connection
 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Connection open");
    [socket send:@"Hey whats up!"];
}

/**
 * Error Handle
 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Could not connect");
}

/**
 * Socket Close
 */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"The connection closed%@", wasClean ? @"." : [NSString stringWithFormat:@", reason %@", reason]);
}

@end
