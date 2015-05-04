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

// Stored Data (slow)
@property (nonatomic, strong) Lecture *lecture;

// Quick Access Data (fast)
@property (nonatomic, strong) ALMetaData *metadata;

/**
 * Save the document
 */
- (void)save;
- (void)saveWithCompletetion:(void(^)(BOOL success))completion;

- (NSArray*)getNotes;

@end
