//
//  ShuffleNote.h
//  AccessLecture
//
//  Created by Michael Timbrook on 3/15/16.
//
//

#import <CoreData/CoreData.h>

@interface ShuffleNote : NSManagedObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (nonatomic) CGPoint location;

@end
