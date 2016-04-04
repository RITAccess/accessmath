// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NoteTakingNote.h instead.

#import <CoreData/CoreData.h>

extern const struct NoteTakingNoteAttributes {
	 NSString *location_x;
	 NSString *location_y;
	 NSString *noteid;
} NoteTakingNoteAttributes;

extern const struct NoteTakingNoteRelationships {
	 NSString *note;
} NoteTakingNoteRelationships;

extern const struct NoteTakingNoteFetchedProperties {
	 NSString *parent;
} NoteTakingNoteFetchedProperties;

@class Note;

@interface NoteTakingNoteID : NSManagedObjectID {}
@end

@interface _NoteTakingNote : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) NoteTakingNoteID* objectID;

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

@property (nonatomic, retain) NSNumber* noteid;

@property (atomic) int32_t noteidValue;
- (int32_t)noteidValue;
- (void)setNoteidValue:(int32_t)value_;

//- (BOOL)validateNoteid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Note *note;

//- (BOOL)validateNote:(id*)value_ error:(NSError**)error_;

@property (nonatomic, readonly) NSArray *parent;

@end

@interface _NoteTakingNote (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveLocation_x;
- (void)setPrimitiveLocation_x:(NSNumber*)value;

- (float)primitiveLocation_xValue;
- (void)setPrimitiveLocation_xValue:(float)value_;

- (NSNumber*)primitiveLocation_y;
- (void)setPrimitiveLocation_y:(NSNumber*)value;

- (float)primitiveLocation_yValue;
- (void)setPrimitiveLocation_yValue:(float)value_;

- (NSNumber*)primitiveNoteid;
- (void)setPrimitiveNoteid:(NSNumber*)value;

- (int32_t)primitiveNoteidValue;
- (void)setPrimitiveNoteidValue:(int32_t)value_;

- (Note*)primitiveNote;
- (void)setPrimitiveNote:(Note*)value;

@end
