//
//  SortingMethods.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 7/21/16.
//
//

#import "SortingMethods.h"
#import "SaveAssignments.h"

@implementation SortingMethods

#pragma mark - Sort closest due to the top

+(void)fiveDayWarning {
    NSMutableArray *copyArray = [[NSMutableArray alloc] init];
    for (NSString *str in [SaveAssignments sharedData].savedArray) {
        [copyArray addObject:str];
    }
    NSMutableArray *closestDue = [self mergeSort:copyArray];
    
    NSMutableArray *sortedClosestDue = [[NSMutableArray alloc] init];
    for (NSString *name in closestDue) {
        NSDate *today = [NSDate date];
        NSDate *fiveDayWarning;
        if ([SaveAssignments sharedData].reminder != nil) {
            int integer = [[SaveAssignments sharedData].reminder intValue];
            fiveDayWarning = [[[SaveAssignments sharedData].savedAssignments objectForKey:name] dateByAddingTimeInterval:-integer*24*60*60];
        } else {
            fiveDayWarning = [[[SaveAssignments sharedData].savedAssignments objectForKey:name] dateByAddingTimeInterval:-5*24*60*60];
        }
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"EEE yyyy-MM-dd"];
        //NSString *theDate = [dateFormat stringFromDate:fiveDayWarning];
        if (([today compare:fiveDayWarning] == NSOrderedDescending) && ([today compare:[[SaveAssignments sharedData].savedAssignments objectForKey:name]] == NSOrderedAscending)) {
            NSString *temp = name;
            [sortedClosestDue addObject:temp];
        }
    };
    
    for (NSString *str in sortedClosestDue.reverseObjectEnumerator) {
        [[SaveAssignments sharedData].savedArray removeObject:str];
        [[SaveAssignments sharedData].savedArray insertObject:str atIndex:0];
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
        if ([[[SaveAssignments sharedData].savedAssignments objectForKey:[left objectAtIndex:leftIndex]] compare:[[SaveAssignments sharedData].savedAssignments objectForKey:[right objectAtIndex:rightIndex]]] == NSOrderedAscending) {
            [result addObject:[left objectAtIndex:leftIndex]];
            leftIndex++;
        }
        else {
            [result addObject:[right objectAtIndex:rightIndex]];
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
    NSArray *sortedArray =  [[SaveAssignments sharedData].savedArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [[SaveAssignments sharedData].savedArray removeAllObjects];
    [[SaveAssignments sharedData].savedArray setArray:sortedArray];
}

+ (void) reverseAlphabetSort {
    [self alphabetSort];
    NSUInteger start = 0;
    NSUInteger end = [[SaveAssignments sharedData].savedArray count]-1;
    while (start < end) {
        [[SaveAssignments sharedData].savedArray exchangeObjectAtIndex:start withObjectAtIndex:end];
        start++;
        end--;
    }
}

@end