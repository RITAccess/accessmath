//
//  AMNote.h
//  AccessLecture
//
//  Created by Michael Timbrook on 2/23/16.
//
//

#import <CoreData/CoreData.h>

@interface AMNote : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *posotion;

@end
