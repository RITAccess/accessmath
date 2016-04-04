// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ShuffleNote.h instead.

#import <CoreData/CoreData.h>

extern const struct ShuffleNoteAttributes {
	 NSString *location_x;
	 NSString *location_y;
} ShuffleNoteAttributes;

extern const struct ShuffleNoteRelationships {
	 NSString *note;
} ShuffleNoteRelationships;

@class Note;

@interface ShuffleNoteID : NSManagedObjectID {}
@end

@interface _ShuffleNote : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ShuffleNoteID* objectID;

@property (nonatomic, retain) NSNumber* location_x;

@property (atomic) float location_xValue;
- (float)location_xValue;
- (void)setLocation_xValue:(float)value_;

//- (BOOL)validateLocation_x:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSNumber* location_y;

@property (atomic) float location_yValue;
- (float)location_yValue;
- (void)setLocation_yValue:(float)value_;

//- (BOOL)validateLocation_y:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Note *note;

//- (BOOL)validateNote:(id*)value_ error:(NSError**)error_;

@end

@interface _ShuffleNote (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveLocation_x;
- (void)setPrimitiveLocation_x:(NSNumber*)value;

- (float)primitiveLocation_xValue;
- (void)setPrimitiveLocation_xValue:(float)value_;

- (NSNumber*)primitiveLocation_y;
- (void)setPrimitiveLocation_y:(NSNumber*)value;

- (float)primitiveLocation_yValue;
- (void)setPrimitiveLocation_yValue:(float)value_;

- (Note*)primitiveNote;
- (void)setPrimitiveNote:(Note*)value;

@end
