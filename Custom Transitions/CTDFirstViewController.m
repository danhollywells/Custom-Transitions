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

@interface CTDFirstViewController () <UIViewControllerTransitioningDelegate>
@property BOOL hide;
- (IBAction)presentSecondViewController:(id)sender;
@end

@implementation CTDFirstViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (IBAction)presentSecondViewController:(id)sender
{
    CTDSecondViewController *second = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Second"];
    second.modalPresentationStyle = UIModalPresentationFullScreen;

    second.transitioningDelegate = self;
    [self presentViewController:second animated:YES completion:NULL];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[CTDCrossfadeTransition alloc] init];
}

@end
