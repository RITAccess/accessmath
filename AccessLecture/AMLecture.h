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
#import "NoteTakingNote.h"

static NSString *const AMLectutueFileExtention = @"lec";

@interface AMLecture : UIDocument

// Each propery is lazy loaded, try to only start a load if you have to
@property (nonatomic, strong) Lecture *lecture;
@property (nonatomic, strong) ALMetaData *metadata;
@property (nonatomic, strong) UIImage *thumb;

/**
 * Save the document
 */
- (void)save;
- (void)saveWithCompletetion:(void(^)(BOOL success))completion;


- (NoteTakingNote *)createNote;
- (NoteTakingNote *)createNoteAtPosition:(CGPoint)point;

- (NSArray*)getNotes;

@end
