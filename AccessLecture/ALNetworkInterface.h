//
//  ALNetworkInterface.h
//  AccessLecture
//
//  Created by Michael Timbrook on 5/30/13.
//
//

#import <Foundation/Foundation.h>
#import "SocketRocket/SRWebSocket.h"
#import "SocketIO.h"

@interface ALNetworkInterface : NSObject <SocketIODelegate>

- (id)initWithURL:(NSString *)url;
- (void)connect;
- (void)onMessageBlock:(void (^) (NSString *response))hande;
- (void)sendData:(id)data;

@end
