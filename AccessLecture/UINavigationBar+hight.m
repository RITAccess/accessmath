//
//  UINavigationBar+hight.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/23/15.
//
//

#import "UINavigationBar+hight.h"

@import ObjectiveC;

@implementation UINavigationBar (height)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        
        SEL originalSelector = @selector(sizeThatFits:);
        SEL swizzledSelector = @selector(al_sizeThatFits:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}

- (CGSize)al_sizeThatFits:(CGSize)size
{
    CGSize nsize = [self al_sizeThatFits:size];
    nsize.height = 100;
    return nsize;
}

@end
