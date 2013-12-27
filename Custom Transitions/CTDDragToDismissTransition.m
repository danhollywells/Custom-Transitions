//
//  CTDDragToDismissTransition.m
//  Custom Transitions
//
//  Created by Devon on 12/26/2013.
//  Copyright (c) 2013 Devon. All rights reserved.
//

#import "CTDDragToDismissTransition.h"

@interface CTDDragToDismissTransition ()
@property (strong) id<UIViewControllerContextTransitioning> context;
@property (strong) UIPanGestureRecognizer *panGesture;
@property UIOffset touchOffsetFromCenter;

@property (strong) UIView *transitionContainer;
@property (strong) UIView *viewBeingDismissed;
@end

@implementation CTDDragToDismissTransition

- (instancetype)initWithSourceView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [view addGestureRecognizer:self.panGesture];
    }
    return self;
}

- (void)dealloc
{
    [self.panGesture.view removeGestureRecognizer:self.panGesture];
}

#pragma mark - Animated Transitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{

}

#pragma mark - Interactive Transitioning

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    self.transitionContainer = transitionContext.containerView;

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    fromVC.view.frame = [transitionContext initialFrameForViewController:fromVC];

    [self.transitionContainer addSubview:toVC.view];
    [self.transitionContainer addSubview:fromVC.view];

    self.viewBeingDismissed = fromVC.view;

    CGPoint fingerPoint = [self.panGesture locationInView:self.viewBeingDismissed];
    CGPoint viewCenter = self.viewBeingDismissed.center;
    self.touchOffsetFromCenter = UIOffsetMake(fingerPoint.x - viewCenter.x, fingerPoint.y - viewCenter.y);
}

#pragma mark - Helpers

- (CGFloat)percentageBasedOnLocationOfFromView
{
    UIView *container = self.context.containerView;
    return CGRectGetMinY(self.viewBeingDismissed.frame) / CGRectGetHeight(container.frame);
}

- (void)panned:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.delegate dragDownToDismissTransitionDidBeginDragging:self];
            break;

        case UIGestureRecognizerStateChanged: {
            CGPoint touchLocation = [self.panGesture locationInView:self.transitionContainer];

            CGPoint center = self.viewBeingDismissed.center;
            center.y = touchLocation.y - self.touchOffsetFromCenter.vertical;
            self.viewBeingDismissed.center = center;

            [self.context updateInteractiveTransition:self.percentageBasedOnLocationOfFromView];
            break;
        }

        case UIGestureRecognizerStateEnded:
            if (self.percentageBasedOnLocationOfFromView >= 0.33) {
                [self finishInteraction];
            } else {
                [self cancelInteraction];
            }
            break;

        default:
            [self cancelInteraction];
            break;
    }
}

- (void)finishInteraction
{
    // cause the view to keep disappearing off the bottom
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.context.containerView];
    UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[fromVC.view]];
    gravity.gravityDirection = CGVectorMake(0, 4.0);

    __weak typeof(self) weakSelf = self;
    gravity.action = ^{
        typeof(self) strongSelf = weakSelf;

        if (strongSelf.percentageBasedOnLocationOfFromView > 1.0) {
            [animator removeAllBehaviors];

            [strongSelf completeTransition];
        }
    };

    [animator addBehavior:gravity];

    [self.context finishInteractiveTransition];
}

- (void)cancelInteraction
{
    // cause the view to snap back in to place
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.context.containerView];

    UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect initialFrame = [self.context initialFrameForViewController:fromVC];

    CGPoint snapPoint = CGPointMake(CGRectGetMidX(initialFrame), CGRectGetMidY(initialFrame));

    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.viewBeingDismissed]];
    itemBehavior.allowsRotation = NO;
    [animator addBehavior:itemBehavior];

    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.viewBeingDismissed snapToPoint:snapPoint];
    snap.damping = 0.1;

    __weak typeof(self) weakSelf = self;
    snap.action = ^{
        typeof(self) strongSelf = weakSelf;
        UIView *view = strongSelf.viewBeingDismissed;

        if (ABS(view.frame.origin.y) < 1 && [itemBehavior linearVelocityForItem:view].y < 0.01) {
            view.frame = initialFrame;
            [animator removeAllBehaviors];
            [strongSelf completeTransition];
        }
    };

    [animator addBehavior:snap];

    [self.context cancelInteractiveTransition];
}

- (void)completeTransition
{
    BOOL finished = !self.context.transitionWasCancelled;
    [self.context completeTransition:finished];

    self.context = nil;
    self.touchOffsetFromCenter = UIOffsetZero;
    self.transitionContainer = nil;
    self.viewBeingDismissed = nil;
}

@end
