//
//  SortingMethods.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 7/21/16.
//
//

#import "SortingMethods.h"
#import "SaveAssignments.h"
#import "AssignmentItem.h"

@implementation SortingMethods

#pragma mark - Sort closest due to the top

+(void)fiveDayWarning {
    
    NSMutableArray *copyArray = [[NSMutableArray alloc] init];
    for (AssignmentItem *item in [AssignmentItem loadAssignments]) {
        [copyArray addObject:item];
    }
    NSMutableArray *closestDue = [self mergeSort:copyArray];
 
    NSMutableArray *sortedClosestDue = [[NSMutableArray alloc] init];
    for (AssignmentItem *item in closestDue) {
        NSDate *today = [NSDate date];
        NSDate *fiveDayWarning;
        if ([SaveAssignments sharedData].reminder != nil) {
            int integer = [[SaveAssignments sharedData].reminder intValue];
            fiveDayWarning = [item.creationDate dateByAddingTimeInterval:-integer*24*60*60];
        } else {
            fiveDayWarning = [item.creationDate dateByAddingTimeInterval:-5*24*60*60];
        }
        if (([today compare:fiveDayWarning] == NSOrderedDescending) && ([today compare:item.creationDate] == NSOrderedAscending)) {
            AssignmentItem *temp = item;
            [sortedClosestDue addObject:temp];
        }
    }
 
    for (AssignmentItem *item in sortedClosestDue.reverseObjectEnumerator) {
        [[AssignmentItem loadAssignments] removeObject:item];
        [[AssignmentItem loadAssignments] insertObject:item atIndex:0];
    }
}
 
 #pragma mark - Merge Sort Algorithm for Date
 
 +(NSMutableArray*) mergeSort:(NSMutableArray*)list {
     //Base case, only 1 element
    if (list.count <= 1) {
        return list;
    }
 
     NSUInteger mid = [list count]/2;
     NSMutableArray *left = [[NSMutableArray alloc] init];
     NSMutableArray *right = [[NSMutableArray alloc] init];
 
     //Recursive case: divide list into equal-sized sublists
     for (NSUInteger i = 0; i < mid; i++) {
         [left addObject:[list objectAtIndex:i]];
     }
 
     for (NSUInteger i = mid; i < [list count]; i++) {
         [right addObject:[list objectAtIndex:i]];
     }
 
     return [self merge:[self mergeSort:left] with:[self mergeSort:right]];
 }
 
 +(NSMutableArray*) merge: (NSMutableArray*)left with: (NSMutableArray*)right {
     NSMutableArray *result = [[NSMutableArray alloc] init];
 
     int leftIndex = 0;
     int rightIndex = 0;
     while ((leftIndex < [left count]) && (rightIndex < [right count])) {
         AssignmentItem *leftItem = [left objectAtIndex:leftIndex];
         AssignmentItem *rightItem = [right objectAtIndex:rightIndex];
         if ([leftItem.creationDate compare:rightItem.creationDate] == NSOrderedAscending) {
             [result addObject:leftItem];
             leftIndex++;
         }
         else {
             [result addObject:rightItem];
             rightIndex++;
         }
     }
 
     while(leftIndex < [left count]) {
         [result addObject:[left objectAtIndex:leftIndex]];
         leftIndex++;
     }
 
     while(rightIndex < [right count]) {
         [result addObject:[right objectAtIndex:rightIndex]];
         rightIndex++;
     }
 
     return result;
 }
 
 #pragma mark - Alphabetical & Reverse Alphabetical Sort
 
+ (void) alphabetSort {
    NSMutableArray *assignmentNames = [[NSMutableArray alloc] init];
    for (AssignmentItem *item in [AssignmentItem loadAssignments]) {
        [assignmentNames addObject:item.itemName];
    }
     NSArray *sortedArray =  [assignmentNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableArray *sortedAssignments = [[NSMutableArray alloc] init];
    for (NSString *str in sortedArray) {
        for (AssignmentItem *item in [AssignmentItem loadAssignments]) {
            if ([str isEqualToString:item.itemName]) {
                [sortedAssignments addObject:item];
            }
        }
    }
     [AssignmentItem replaceArrayOfAssignmentsWith:sortedAssignments];
}
 
 + (void) reverseAlphabetSort {
     [self alphabetSort];
     NSUInteger start = 0;
     NSUInteger end = [[AssignmentItem loadAssignments] count]-1;
     while (start < end) {
         [[AssignmentItem loadAssignments] exchangeObjectAtIndex:start withObjectAtIndex:end];
         start++;
         end--;
     }
 }

@end