//
//  PrimWrapper.m
//  AccessLecture
//
//  Created by Michael Timbrook on 7/1/13.
//
//

#import "PrimWrapper.h"

@implementation PrimWrapper

+ (instancetype)wrapperWithTransform:(CGAffineTransform)trans
{
    PrimWrapper *prim = [[PrimWrapper alloc] init];
    [prim setTransform:trans];
    return prim;
}

@end
