//
//  NoteInterface.h
//  AccessLecture
//
//  Created by Michael Timbrook on 1/28/16.
//
//

@import UIKit;

#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import <Foundation/Foundation.h>

@interface NoteInterface : NSObject

/**
 * Posision Tracked Items
 */
@property (atomic, readwrite) CGPoint location;
@property (atomic, readwrite) NSInteger zIndex;

- (void)setID:(NSString *)state inDB:(FMDatabaseQueue *)pdb new:(BOOL)create id:(NSInteger) idx;

@end
