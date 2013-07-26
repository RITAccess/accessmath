//
//  ZoomBounds.h
//  AccessLecture
//
//  Created by Michael Timbrook on 7/25/13.
//
//

#include <CoreGraphics/CoreGraphics.h>
#include <CoreFoundation/CoreFoundation.h>

/**
 * Keeps a view from panning out of view with a nice bounce
 *
 * @param center The center point of the view to keep in bounds
 * @param size The size of the view to keep in bounds
 * @param screen The size of the bounding view
 * @param *newCenter A pointer to calculated center with bounce, this should be set as the center while the panning is in progress
 * @param *centerLimit A pointer to the bound limit, this is the point that the view center should return to when the gesture ends
 */
extern void apply_bounds_with_bounce(CGPoint center, CGSize size, CGSize screen, CGPoint *newCenter, CGPoint *centerLimit);

/**
 * Keeps a view from zooming outside it's limits with a nice bounce
 * Assumes scalling is the same for both a and d
 * 
 * @param interlimit the transform of the furthest you can zoom out
 * @param outerlimit the transform of the furthest you can zoom in
 * @param zoom the current zoom transform
 * @param zoom transform to apply while zooming is active
 * @param zoom transform to apply when the zooming ends
 */
extern void apply_zoom_limit_with_bounce(CGAffineTransform interlimit, CGAffineTransform outerlimit, CGAffineTransform zoom, CGAffineTransform *newZoom, CGAffineTransform *zoomLimit);