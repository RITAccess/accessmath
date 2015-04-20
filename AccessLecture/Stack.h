//
//  Stack.h
//  AccessLecture
//
//  Created by Michael Timbrook on 4/20/15.
//
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject

- (void)push:(id)obj;
- (id)pop;

// Only with printable objs

- (NSString *)print;

@end
