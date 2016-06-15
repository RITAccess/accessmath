//
//  SaveAssignments.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/7/16.
//
//

#import <Foundation/Foundation.h>

@interface SaveAssignments : NSObject <NSCoding>

/* Saves a single assignment */
@property NSString *savedItem;

/* Saves the initial name for assignment */
@property NSString *initialName;

/* Saves the name that student chooses for assignment */
@property NSString *changedName;

/* Saves assignments in an array */
@property NSMutableArray *savedArray;

/* Saves assignments and corresponding date */
@property NSMutableDictionary *savedAssignments;

/* Saves the sort the user wants */
@property NSInteger segment;
@property BOOL segmentSelected;

+(instancetype)sharedData;
-(void)save;

@end
