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

typedef enum ALPointType : NSUInteger ALPointType;
enum ALPointType : NSUInteger {
    ALPointTypeMoveTo,
    ALPointTypeLineTo
};

/* Lecture Steaming Protocol */
@protocol LectureStreaming <NSObject>

- (void)didRecieveUpdate:(CGPoint)point type:(ALPointType)type;
- (void)didFinishRecievingUpdate:(NSArray *)data;
- (void)didFinishDownloadingLecture:(Lecture *)lecture;
- (void)didFinishRecievingBulkUpdate:(NSArray *)data;
- (void)didFailToConnectTo:(NSString *)lecture;

@optional

- (void)currentStreamUpdatePercentage:(float)percent;

@end

@interface ALNetworkInterface : NSObject <SocketIODelegate>

/* Delegate */
@property (nonatomic, strong) id<LectureStreaming> delegate;

/* Create interface */
@property (nonatomic, strong) NSString *connectionURL;
- (id)initWithURL:(NSString *)url;
- (void)connect;
- (void)connectCompletion:(void (^)(BOOL success))handle;
- (void)disconnect;

/* Recieve full lecture from server */
- (void)getFullLecture:(NSString *)lectureName completion:(void (^)(Lecture *lecture, BOOL found))handle;
- (void)getFullLecture:(NSString *)lectureName;

/* Set up stream */
- (void)requestAccessToLectureSteam:(NSString *)name;

/* Information */
@property (readonly, getter = connected) BOOL connected;
@property (readonly, getter = isConnecting) BOOL connecting;
@property(nonatomic) BOOL wasConnected;

@end
