//
//  ALNetworkInterface.h
//  AccessLecture
//
//  Created by Michael Timbrook on 5/30/13.
//
//

#import <Foundation/Foundation.h>
#import "SocketRocket/SRWebSocket.h"

@interface ALNetworkInterface : NSObject <SRWebSocketDelegate>

- (void)connect;

@end
