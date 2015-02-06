//
//  PreviewAnimationCordinator.m
//  AccessLecture
//
//  Created by Michael Timbrook on 2/6/15.
//
//

#import "PreviewAnimationCordinator.h"

@implementation PreviewAnimationCordinator

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0f;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
}

// This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
- (void)animationEnded:(BOOL) transitionCompleted
{
    
}

@end
