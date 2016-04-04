// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NoteTakingNote.m instead.

#import "_NoteTakingNote.h"

const struct NoteTakingNoteAttributes NoteTakingNoteAttributes = {
	.location_x = @"location_x",
	.location_y = @"location_y",
	.noteid = @"noteid",
};

const struct NoteTakingNoteRelationships NoteTakingNoteRelationships = {
	.note = @"note",
};

const struct NoteTakingNoteFetchedProperties NoteTakingNoteFetchedProperties = {
	.parent = @"parent",
};

@implementation NoteTakingNoteID
@end

@implementation _NoteTakingNote

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"NoteTakingNote" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"NoteTakingNote";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"NoteTakingNote" inManagedObjectContext:moc_];
}

- (NoteTakingNoteID*)objectID {
	return (NoteTakingNoteID*)[super objectID];
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
	if ([key isEqualToString:@"noteidValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"noteid"];
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
	[self setLocation_x:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLocation_xValue {
	NSNumber *result = [self primitiveLocation_x];
	return [result floatValue];
}

- (void)setPrimitiveLocation_xValue:(float)value_ {
	[self setPrimitiveLocation_x:[NSNumber numberWithFloat:value_]];
}

@dynamic location_y;

- (float)location_yValue {
	NSNumber *result = [self location_y];
	return [result floatValue];
}

- (void)setLocation_yValue:(float)value_ {
	[self setLocation_y:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLocation_yValue {
	NSNumber *result = [self primitiveLocation_y];
	return [result floatValue];
}

- (void)setPrimitiveLocation_yValue:(float)value_ {
	[self setPrimitiveLocation_y:[NSNumber numberWithFloat:value_]];
}

@dynamic noteid;

- (int32_t)noteidValue {
	NSNumber *result = [self noteid];
	return [result intValue];
}

- (void)setNoteidValue:(int32_t)value_ {
	[self setNoteid:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveNoteidValue {
	NSNumber *result = [self primitiveNoteid];
	return [result intValue];
}

- (void)setPrimitiveNoteidValue:(int32_t)value_ {
	[self setPrimitiveNoteid:[NSNumber numberWithInt:value_]];
}

@dynamic note;

@dynamic parent;

@end

