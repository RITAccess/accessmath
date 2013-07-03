//
//  PrimWrapper.h
//  AccessLecture
//
//  Created by Michael Timbrook on 7/1/13.
//
//

#import <Foundation/Foundation.h>

@interface PrimWrapper : NSObject

+ (instancetype)wrapperWithTransform:(CGAffineTransform)trans;
@property CGAffineTransform transform;

@end
