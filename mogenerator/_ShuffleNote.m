// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ShuffleNote.m instead.

#import "_ShuffleNote.h"

@implementation ShuffleNoteID
@end

@implementation _ShuffleNote

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ShuffleNote" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ShuffleNote";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ShuffleNote" inManagedObjectContext:moc_];
}

- (ShuffleNoteID*)objectID {
	return (ShuffleNoteID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"location_xValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"location_x"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"location_yValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"location_y"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic location_x;

- (float)location_xValue {
	NSNumber *result = [self location_x];
	return [result floatValue];
}

- (void)setLocation_xValue:(float)value_ {
	[self setLocation_x:@(value_)];
}

- (float)primitiveLocation_xValue {
	NSNumber *result = [self primitiveLocation_x];
	return [result floatValue];
}

- (void)setPrimitiveLocation_xValue:(float)value_ {
	[self setPrimitiveLocation_x:@(value_)];
}

@dynamic location_y;

- (float)location_yValue {
	NSNumber *result = [self location_y];
	return [result floatValue];
}

- (void)setLocation_yValue:(float)value_ {
	[self setLocation_y:@(value_)];
}

- (float)primitiveLocation_yValue {
	NSNumber *result = [self primitiveLocation_y];
	return [result floatValue];
}

- (void)setPrimitiveLocation_yValue:(float)value_ {
	[self setPrimitiveLocation_y:@(value_)];
}

@dynamic note;

@end

@implementation ShuffleNoteAttributes 
+ (NSString *)location_x {
	return @"location_x";
}
+ (NSString *)location_y {
	return @"location_y";
}
@end

@implementation ShuffleNoteRelationships 
+ (NSString *)note {
	return @"note";
}
@end

