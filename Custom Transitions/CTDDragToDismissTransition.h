//
//  CTDDragToDismissTransition.h
//  Custom Transitions
//
//  Created by Devon on 12/26/2013.
//  Copyright (c) 2013 Devon. All rights reserved.
//

@import Foundation;

@protocol CTDDragToDismissTransitionDelegate;

@interface CTDDragToDismissTransition : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic, weak) id<CTDDragToDismissTransitionDelegate> delegate;
@property (nonatomic, readonly) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGRect gestureActivationFrame; // Defaults to source view frame
@property (nonatomic, assign) BOOL isPresenting;

- (instancetype)initWithSourceView:(UIView *)view NS_DESIGNATED_INITIALIZER;
- (BOOL)isInteractive;

@end

@protocol CTDDragToDismissTransitionDelegate <NSObject>
- (void)dragDownToDismissTransitionDidBeginDragging:(CTDDragToDismissTransition *)transition;
@end