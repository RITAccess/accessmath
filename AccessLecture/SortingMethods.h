//
//  SortingMethods.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 7/21/16.
//
//

#import <Foundation/Foundation.h>

@interface SortingMethods : NSObject

@property NSMutableArray *savedArray;

+(NSMutableArray*) mergeSort:(NSMutableArray*)list;
+(void)alphabetSort;
+(void)reverseAlphabetSort;
+(void)fiveDayWarning;

@end
