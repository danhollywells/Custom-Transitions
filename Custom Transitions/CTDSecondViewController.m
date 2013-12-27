//
//  CTDSecondViewController.m
//  Custom Transitions
//
//  Created by Devon on 12/26/2013.
//  Copyright (c) 2013 Devon. All rights reserved.
//

#import "CTDDragToDismissTransition.h"
#import "CTDSecondViewController.h"

@interface CTDSecondViewController () <CTDDragToDismissTransitionDelegate, UIViewControllerTransitioningDelegate>
@property (strong) CTDDragToDismissTransition *dragToDismiss;
@end

@implementation CTDSecondViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad
{
    self.dragToDismiss = [[CTDDragToDismissTransition alloc] initWithSourceView:self.view];
    self.dragToDismiss.delegate = self;
}

- (void)dragDownToDismissTransitionDidBeginDragging:(CTDDragToDismissTransition *)transition
{
    self.transitioningDelegate = self;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dragToDismiss;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.dragToDismiss;
}

@end
