/*
 * ACEDrawingView: https://github.com/acerbetti/ACEDrawingView
 *
 * Copyright (c) 2013 Stefano Acerbetti
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <Foundation/Foundation.h>

#define ACE_HAS_ARC 1
#define ACE_RETAIN(exp) (exp)
#define ACE_RELEASE(exp)
#define ACE_AUTORELEASE(exp) (exp)

/**
 * ACEDrawing Tool Protcol. Includes line color, alpha
 * and width. Also includes the method declarations: setInitialPoint,
 * moveFromPoint, and draw.
 */
@protocol ACEDrawingTool <NSObject>

@property (nonatomic) UIColor *lineColor;
@property (nonatomic) CGFloat lineAlpha;
@property (nonatomic) CGFloat lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;
- (void)draw;

@end

#pragma mark - Pen

@interface ACEDrawingPenTool : UIBezierPath<ACEDrawingTool> {
    CGMutablePathRef path;
}

- (CGRect)addPathPreviousPreviousPoint:(CGPoint)p2Point withPreviousPoint:(CGPoint)p1Point withCurrentPoint:(CGPoint)cpoint;

@end

#pragma mark - Eraser

@interface ACEDrawingEraserTool : ACEDrawingPenTool

@end

#pragma mark - Line

@interface ACEDrawingLineTool : NSObject<ACEDrawingTool>

@end

#pragma mark - Rectangle

@interface ACEDrawingRectangleTool : NSObject<ACEDrawingTool>

@property (nonatomic, assign) BOOL fill;

@end

#pragma mark - Ellipse

@interface ACEDrawingEllipseTool : NSObject<ACEDrawingTool>

@property (nonatomic, assign) BOOL fill;

@end