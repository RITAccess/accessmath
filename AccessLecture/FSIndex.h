//
//  FSIndex.h
//  AccessLecture
//
//  Created by Michael Timbrook on 3/30/15.
//
//

#import <Foundation/Foundation.h>

@interface FSIndex : NSObject

- (instancetype)initWithIndex:(NSURL *)pathToIndex;

@property (nonatomic, readonly) NSArray *files;

@end
