// Copyright 2011 Access Lecture. All rights reserved.

#import "ZoomHandler.h"


@implementation ZoomHandler

/**
 Initialize the zoom handler
 */
-(ZoomHandler*) init {
	self = [super init];
	if(self){
		// Setting zoomLevel to 1 does not zoom, just a failsafe value
		[self setZoomLevel: 1];
	}
	return self;
}

/**
 Initialize with a specific zoom level
 */
-(ZoomHandler*) initWithZoomLevel: (float) z {
	self = [super init];
	if(self){
		[self setZoomLevel:z];
	}
	return self;
}	

/**
 Set the zoom level
 */
-(void) setZoomLevel: (float) z {
	zoomLevel = z;
}

/**
 Get the zoom level
 */
-(float) getZoomLevel {
    return zoomLevel;
}

/**
 Determine the origin
 */
-(CGPoint) getNewOriginFromViewLocation: (CGPoint) oldOrigin viewSize: (CGPoint) viewSize andZoomType:(BOOL) isZoomIn {
	// Calculate original center (add the half of the width/height of the screen)
	float oldCenterX = oldOrigin.x + (viewSize.x / 2);
	float oldCenterY = oldOrigin.y + (viewSize.y / 2);
	
	// Xalculate the new center
	CGPoint newCenter;
	if(isZoomIn) {
		newCenter = CGPointMake(oldCenterX * zoomLevel, oldCenterY * zoomLevel);
	} else {
		newCenter = CGPointMake(oldCenterX / zoomLevel, oldCenterY / zoomLevel);
	}
	
	// Calculate the new origin (deduct the half of the width/height of the screen)
	float newOriginX = newCenter.x - (viewSize.x / 2);
	float newOriginY = newCenter.y - (viewSize.y / 2);
	
	return CGPointMake(newOriginX, newOriginY);
}

@end
