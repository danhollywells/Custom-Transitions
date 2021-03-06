//
//  CTDNavigationViewController.m
//  Custom Transitions
//
//  Created by Daniel Holly Wells on 8/1/14.
//  Copyright (c) 2014 Devon. All rights reserved.
//

#import "CTDNavigationViewController.h"
#import "CTDDragToDismissTransition.h"
#import "CTDSecondViewController.h"

@interface CTDNavigationViewController () <CTDDragToDismissTransitionDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (strong) CTDDragToDismissTransition *dragToDismiss;
@end

@implementation CTDNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.dragToDismiss = [[CTDDragToDismissTransition alloc] initWithSourceView:self.view];
    self.dragToDismiss.delegate = self;
    
    CGRect gestureActivationZoneFrame = self.view.frame;
    gestureActivationZoneFrame.size.height = 70;
    [self.dragToDismiss setGestureActivationFrame:gestureActivationZoneFrame];

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // You can't dismiss the first view controller
    [self.dragToDismiss.panGesture setEnabled:([self.viewControllers firstObject] != viewController)];
    
}


#pragma mark - CTDDragToDismissTransitionDelegate

- (void)dragDownToDismissTransitionDidBeginDragging:(CTDDragToDismissTransition *)transition
{
    if ([self.viewControllers count] > 1) {
        [self popViewControllerAnimated:YES];
    } else {
        NSLog(@"Can't Pop root view controller");
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([self.dragToDismiss isInteractive]) {
        return self.dragToDismiss;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.dragToDismiss.isPresenting = (operation == UINavigationControllerOperationPush);
    return self.dragToDismiss;
}

@end
