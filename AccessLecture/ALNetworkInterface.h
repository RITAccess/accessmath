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
#import "Lecture.h"


/* Lecture Steaming Protocol */
@protocol LectureStreaming <NSObject>

- (void)didRecieveUpdate:(id)data;

@end

@interface ALNetworkInterface : NSObject <SocketIODelegate>

- (id)initWithURL:(NSString *)url;
- (void)connect;
- (void)connectCompletion:(void (^)(BOOL success))handle;
- (void)onMessageBlock:(void (^) (NSString *response))hande;
- (void)sendData:(id)data;
- (void)disconnect;

/* Recieve full lecture from server */
- (void)getFullLecture:(NSString *)lectureName completion:(void (^)(Lecture *lecture, BOOL found))handle;

/* Set up stream */
- (void)requestAccessToLectureSteam:(NSString *)name;
@property (nonatomic, strong) NSString *connectionURL;

/* Keeping a persitaint connection */
@property(nonatomic) BOOL wasConnected;

/* Delegate */
@property (nonatomic, strong) id<LectureStreaming> delegate;

/* Information */
@property (readonly, getter = connected) BOOL connected;
@property (readonly, getter = isConnecting) BOOL connecting;
@end
