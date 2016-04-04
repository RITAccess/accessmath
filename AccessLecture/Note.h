//
//  Note.h
//  AccessLecture
//
//  Created by Michael Timbrook on 3/17/16.
//
//

#import <CoreData/CoreData.h>

@interface Note : NSManagedObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;

@end
