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
#import "ShuffleNote.h"

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

/**
 *  Create new note for note taking, this also creates a default note in the
 *  shuffle note context.
 *
 *  @return new managed object
 */
- (id)createNoteOfType:(Class)type;

/**
 *  Create new note for note taking, this also creates a default note in the
 *  shuffle note context.
 *
 *  @param point location to place the note in notetaking scene
 *
 *  @return new managed object
 */
- (id)createNoteAtPosition:(CGPoint)point ofType:(Class)type;

@property (readonly) NSArray *notes;

@end
