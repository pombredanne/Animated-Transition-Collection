//
//  ATCAnimatedTransitioningSquish.m
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 17/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "ATCAnimatedTransitioningSquish.h"

@implementation ATCAnimatedTransitioningSquish

-(void)animateTransitionWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
                 fromViewController:(UIViewController *)fromViewController
                   toViewController:(UIViewController *)toViewController
                           fromView:(UIView *)fromView
                             toView:(UIView *)toView {
    
    
    if ( self.isDismissal ) {
        [self animateDismissalWithContext:transitionContext fromViewController:fromViewController fromView:fromView toView:toView];
    } else {
        [self animatePresentationWithContext:transitionContext fromViewController:fromViewController fromView:fromView toView:toView];
    }
    
}

-(void)animateDismissalWithContext:(id<UIViewControllerContextTransitioning>)context fromViewController:(UIViewController *)fromViewController fromView:(UIView *)fromView toView:(UIView *)toView {

    UIView *container = [context containerView];
    NSTimeInterval duration = [self transitionDuration:context];
    
    // Set up initial state
    [container addSubview:toView];
    fromView.hidden = YES;
    
    CGRect initialFrame = [context initialFrameForViewController:fromViewController];
    toView.frame = initialFrame;
    toView.alpha = 0.2f;
    
    UIView *snapshot = [fromView resizableSnapshotViewFromRect:fromView.frame  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    [container addSubview:snapshot];

    

    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.6f animations:^{
            toView.alpha = 0.6f;
            CGRect snapshotFrame = snapshot.frame;
            snapshotFrame.origin.x = CGRectGetMidX(initialFrame) - 5.0f;
            snapshotFrame.size.width = 10.0f;
            snapshot.frame = snapshotFrame;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.3f animations:^{
            CGRect snapshotFrame = snapshot.frame;
            snapshotFrame.origin.y = CGRectGetHeight(initialFrame);
            snapshot.frame = snapshotFrame;
            toView.alpha = 1.0f;
        }];
    } completion:^(BOOL finished) {
        [fromView removeFromSuperview];
        [snapshot removeFromSuperview];
        [context completeTransition:![context transitionWasCancelled]];
        
    }];
    
    
    
    

}


-(void)animatePresentationWithContext:(id<UIViewControllerContextTransitioning>)context fromViewController:(UIViewController *)fromViewController fromView:(UIView *)fromView toView:(UIView *)toView {
    
    UIView *container = [context containerView];
    NSTimeInterval duration = [self transitionDuration:context];
    
    [container addSubview:toView];

    CGRect initialFrame = [context initialFrameForViewController:fromViewController];
    UIView *blackView = [[UIView alloc] initWithFrame:initialFrame];
    blackView.backgroundColor = [UIColor blackColor];
    UIView *snapshot = [toView resizableSnapshotViewFromRect:toView.frame  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    [container addSubview:snapshot];
    [container insertSubview:blackView belowSubview:fromView];
    [container sendSubviewToBack:toView];
    
    
    CGRect snapshotFrame = initialFrame;
    snapshotFrame.origin.y = CGRectGetHeight(initialFrame);
    snapshotFrame.origin.x = CGRectGetMidX(initialFrame);
    snapshotFrame.size.width = 10.0f;
    
    snapshot.frame = snapshotFrame;
    
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.6f animations:^{
            fromView.alpha = 0.7f;
            CGRect snapshotFrame = snapshot.frame;
            snapshotFrame.origin.y = 0.0f;
            snapshot.frame = snapshotFrame;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.3f animations:^{
            CGRect snapshotFrame = snapshot.frame;
            snapshotFrame.origin.x = 0.0f;
            snapshotFrame.size.width = CGRectGetWidth(initialFrame);
            snapshot.frame = snapshotFrame;
            fromView.alpha = 0.0f;
            
        }];
    } completion:^(BOOL finished) {
        [fromView removeFromSuperview];
        [snapshot removeFromSuperview];
        [blackView removeFromSuperview];
        toView.alpha = 1.0f;
        [context completeTransition:![context transitionWasCancelled]];
        
    }];
    
    
}


-(void)handlePanGesture:(UIPanGestureRecognizer *)recognizer inViewController:(UIViewController *)controller {
    
}

@end
