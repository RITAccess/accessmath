// Copyright 2011 Access Lecture. All rights reserved.

#import <Foundation/NSObject.h>

/**
 * Abstraction for handling the zooming in and out.
 */
@interface ZoomHandler : NSObject {
	
    // Initial zoom level
	@private float zoomLevel;
}

-(ZoomHandler*) initWithZoomLevel: (float) z;
-(void) setZoomLevel: (float) z;
-(float) getZoomLevel;
-(CGPoint) getNewOriginFromViewLocation: (CGPoint) oldOrigin viewSize: (CGPoint) v andZoomType:(BOOL) isZoomIn;

@end
