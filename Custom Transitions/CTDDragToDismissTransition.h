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
- (id)initWithSourceView:(UIView *)view;
@end

@protocol CTDDragToDismissTransitionDelegate <NSObject>
- (void)dragDownToDismissTransitionDidBeginDragging:(CTDDragToDismissTransition *)transition;
@end