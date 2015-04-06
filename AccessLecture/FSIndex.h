//
//  FSIndex.h
//  AccessLecture
//
//  Created by Michael Timbrook on 3/30/15.
//
//

#import <Foundation/Foundation.h>

@interface FSIndex : NSObject

+ (instancetype)sharedIndex;
- (instancetype)initWithIndex:(NSURL *)pathToIndex;

- (void)invalidate;

@property (readonly) NSUInteger count;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end
