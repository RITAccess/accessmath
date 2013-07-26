//
//  ZoomBounds.c
//  AccessLecture
//
//  Created by Michael Timbrook on 7/25/13.
//  Library for clamping zooming and panning on views
//

#include <stdio.h>
#include "ZoomBounds.h"

// Find limits
static float find_leftmost_point_for_center(CGSize size, CGSize screen) {
    return screen.width - (size.width / 2.0);
}

static float find_rightmost_point_for_center(CGSize size) {
    return size.width / 2.0;
}

static float find_lowermost_point_for_center(CGSize size, CGSize screen) {
    return screen.height - (size.height / 2);
}

static float find_uppermost_point_for_center(CGSize size, CGSize screen) {
    return size.height / 2;
}

// Calculate bounce

static float c = 0.95; // Scroll bounce, higher is less pull, must be 0 < c <= 1.0

static float find_stretch_rightbottom_bound(float limit, float location, CGSize screen) {
    float x = fabsf(limit - location);
    float d = screen.width;
    float b = (1.0 - (1.0 / ((x * c / d) + 1.0))) * d;
    return location + b;
}

static float find_stretch_lefttop_bound(float limit, float location, CGSize screen) {
    float x = fabsf(limit - location);
    float d = screen.width;
    float b = (1.0 - (1.0 / ((x * c / d) + 1.0))) * d;
    return location - b;
}

void apply_bounds_with_bounce(CGPoint center, CGSize size, CGSize screen, CGPoint *newCenter, CGPoint *centerLimit) {
    
    *centerLimit = center;
    *newCenter = center;
    
    // Catch right edge
    if (center.x < find_leftmost_point_for_center(size, screen)) {
        centerLimit->x = find_leftmost_point_for_center(size, screen);
        newCenter->x = find_stretch_rightbottom_bound(centerLimit->x, center.x, screen);
    }
    
    // Catch left edge
    if (center.x > find_rightmost_point_for_center(size)) {
        centerLimit->x = find_rightmost_point_for_center(size);
        newCenter->x = find_stretch_lefttop_bound(centerLimit->x, center.x, screen);
    }
    
    // Catch top edge
    if (center.y > find_lowermost_point_for_center(size, screen)) {
        centerLimit->y = find_lowermost_point_for_center(size, screen);
        newCenter->y = find_stretch_lefttop_bound(centerLimit->y, center.y, screen);
    }
    
    // Catch bottom edge
    if (center.y < find_uppermost_point_for_center(size, screen)) {
        centerLimit->y = find_uppermost_point_for_center(size, screen);
        newCenter->y = find_stretch_rightbottom_bound(centerLimit->y, center.y, screen);
    }
    
}

static float find_stretch_interzoom(float limit, float location) {
    float x = fabsf(limit - location);
    float d = 1000;
    float b = (1.0 - (1.0 / ((x * c / d) + 1.0))) * d;
    return location + b;
}

static float find_stretch_outerzoom(float limit, float location) {
    float x = fabsf(limit - location);
    float d = 1000;
    float b = (1.0 - (1.0 / ((x * c / d) + 1.0))) * d;
    return location - b;
}

void apply_zoom_limit_with_bounce(CGAffineTransform interlimit, CGAffineTransform outerlimit, CGAffineTransform zoom, CGAffineTransform *newZoom, CGAffineTransform *zoomLimit) {
    
    *newZoom = zoom;
    *zoomLimit = zoom;
    
    // Catch interzoom
    if (zoom.a < interlimit.a || zoom.d < interlimit.d) {
        zoomLimit->a = interlimit.a;
        zoomLimit->d = interlimit.d;
        newZoom->a = find_stretch_interzoom(zoomLimit->a, zoom.a);
        newZoom->d = find_stretch_interzoom(zoomLimit->d, zoom.d);
    }
    
    // Catch outerzoom
    if (zoom.a > outerlimit.a || zoom.d > outerlimit.d) {
        zoomLimit->a = outerlimit.a;
        zoomLimit->d = outerlimit.d;
        newZoom->a = find_stretch_outerzoom(zoomLimit->a, zoom.a);
        newZoom->d = find_stretch_outerzoom(zoomLimit->d, zoom.d);
    }
    
}

