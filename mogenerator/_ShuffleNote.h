// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ShuffleNote.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Note;

@interface ShuffleNoteID : NSManagedObjectID {}
@end

@interface _ShuffleNote : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ShuffleNoteID*objectID;

@property (nonatomic, strong, nullable) NSNumber* location_x;

@property (atomic) float location_xValue;
- (float)location_xValue;
- (void)setLocation_xValue:(float)value_;

@property (nonatomic, strong, nullable) NSNumber* location_y;

@property (atomic) float location_yValue;
- (float)location_yValue;
- (void)setLocation_yValue:(float)value_;

@property (nonatomic, strong, nullable) Note *note;

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

@interface ShuffleNoteAttributes: NSObject 
+ (NSString *)location_x;
+ (NSString *)location_y;
@end

@interface ShuffleNoteRelationships: NSObject
+ (NSString *)note;
@end

NS_ASSUME_NONNULL_END
