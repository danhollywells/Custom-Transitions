//
//  CTDFirstViewController.m
//  Custom Transitions
//
//  Created by Devon on 12/26/2013.
//  Copyright (c) 2013 Devon. All rights reserved.
//

#import "CTDCrossfadeTransition.h"
#import "CTDFirstViewController.h"
#import "CTDSecondViewController.h"

@interface CTDFirstViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
@property BOOL hide;
@property (strong) CTDCrossfadeTransition *fadeTransition;
- (IBAction)presentSecondViewController:(id)sender;
@end

@implementation CTDFirstViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.fadeTransition = [[CTDCrossfadeTransition alloc] init];
    return self;
}

- (IBAction)presentSecondViewController:(id)sender
{
    CTDSecondViewController *second = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Second"];
    second.modalPresentationStyle = UIModalPresentationFullScreen;
    second.transitioningDelegate = self;
    [self presentViewController:second animated:YES completion:^{
        second.transitioningDelegate = second;
    }];
}

- (IBAction)pushSecondViewController:(id)sender
{
    if (self.navigationController) {
        CTDSecondViewController *second = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Second"];
        [self.navigationController pushViewController:second animated:YES];
    }
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
{
    return self.fadeTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.fadeTransition;
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

@end
