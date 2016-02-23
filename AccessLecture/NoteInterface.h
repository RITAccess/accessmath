//
//  NoteInterface.h
//  AccessLecture
//
//  Created by Michael Timbrook on 1/28/16.
//
//

@import UIKit;

@class FMDatabaseQueue;

#import <Foundation/Foundation.h>

@interface NoteInterface : NSObject

/**
 * Global Tracked Items
 */
@property (atomic, readwrite) NSString *title;
@property (atomic, readwrite) NSString *content;

/**
 * Posision Tracked Items dependant on state initilized with.
 */
@property (atomic, readwrite) CGPoint location;
@property (atomic, readwrite) NSInteger zIndex;

- (void)setID:(NSString *)state inDB:(FMDatabaseQueue *)pdb new:(BOOL)create id:(NSInteger) idx __deprecated_msg("Not the clean interface we want");

- (id)initWithOutsaveToDB:(FMDatabaseQueue *)pdb
                withState:(NSString *)state
                      xid:(int)xid;

@end
