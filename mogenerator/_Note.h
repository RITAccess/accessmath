// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface NoteID : NSManagedObjectID {}
@end

@interface _Note : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) NoteID*objectID;

@property (nonatomic, strong, nullable) NSString* content;

@property (nonatomic, strong, nullable) NSNumber* id;

@property (atomic) int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSString* title;

@end

@interface _Note (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

@end

@interface NoteAttributes: NSObject 
+ (NSString *)content;
+ (NSString *)id;
+ (NSString *)title;
@end

NS_ASSUME_NONNULL_END
