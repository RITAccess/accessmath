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
    
}

/**
 * Init - set up socket
 */
- (id)init {
    self = [super init];
    if (self) {
        // init
    }
    return self;
}

- (void)connect {
    
    socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://echo.websocket.org"]]];
    [socket setDelegate:self];
    
    NSLog(@"Connecting...");
    [socket open];
}

#pragma mark Socket Methods

/**
 * Receive Message from server
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Message: %@", message);
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
    NSLog(@"The connection closed%@", wasClean ? @"." : @" with an error.");
}

@end
