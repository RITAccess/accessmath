//
//  SaveAssignments.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/7/16.
//
//

#import <Foundation/Foundation.h>

@interface SaveAssignments : NSObject <NSCoding>

@property NSString *savedItem;
@property NSMutableDictionary *savedAssignments;

+(instancetype)sharedData;
-(void)save;

@end
