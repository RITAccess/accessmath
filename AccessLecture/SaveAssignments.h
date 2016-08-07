//
//  SaveAssignments.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/7/16.
//
//

#import <Foundation/Foundation.h>

@interface SaveAssignments : NSObject <NSCoding>

/* Saves the sort the user wants */
@property NSInteger segment;
@property BOOL segmentSelected;

/* Saves the number of days to remind student by prior to due date */
@property NSString *reminder;
@property NSInteger reminderInDays;
@property BOOL reminderChosen;

+(instancetype)sharedData;
-(void)save;

@end
