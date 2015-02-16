//
//  AMLecture.h
//  AccessLecture
//
//  Created by Michael Timbrook on 9/19/13.
//
//

#import <UIKit/UIKit.h>
#import "ALMetaData.h"
#import "Lecture.h"

static NSString *const AMLectutueFileExtention = @"lec";

@interface AMLecture : UIDocument

@property ALMetaData *metadata;
@property Lecture *lecture;

/**
 * Save the document
 */
- (void)save;
- (void)saveWithCompletetion:(void(^)(BOOL success))completion;

- (NSArray*)getNotes;

@end
