//
//  CTDSecondViewController.m
//  Custom Transitions
//
//  Created by Devon on 12/26/2013.
//  Copyright (c) 2013 Devon. All rights reserved.
//

#import "CTDDragToDismissTransition.h"
#import "CTDSecondViewController.h"

@interface CTDSecondViewController () <CTDDragToDismissTransitionDelegate>
@property (strong) CTDDragToDismissTransition *dragToDismiss;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation CTDSecondViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Color code from https://gist.github.com/kylefox/1689973
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.view.backgroundColor = color;
    
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 100, self.scrollView.contentSize.height);
    gradientLayer.colors = @[(id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor, (id)[UIColor colorWithWhite:0.0f alpha:1.0f].CGColor];
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    [self.scrollView.layer addSublayer:gradientLayer];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.presentingViewController && !self.dragToDismiss) {
        self.dragToDismiss = [[CTDDragToDismissTransition alloc] initWithSourceView:self.view];
        self.dragToDismiss.delegate = self;
        
        CGRect gestureActivationZoneFrame = self.view.frame;
        gestureActivationZoneFrame.size.height = 70;
        [self.dragToDismiss setGestureActivationFrame:gestureActivationZoneFrame];
        
        [self setNeedsStatusBarAppearanceUpdate];
    }

}

- (void)dragDownToDismissTransitionDidBeginDragging:(CTDDragToDismissTransition *)transition
{
    [self dismissViewController:self];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
{
    self.dragToDismiss.isPresenting = YES;
    return self.dragToDismiss;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (dismissed == self) {
        self.dragToDismiss.isPresenting = NO;
    }
    return self.dragToDismiss;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if ([self.dragToDismiss isInteractive]) {
        return self.dragToDismiss;
    }
    return nil;
}

- (IBAction)modalPresentViewController:(id)sender
{
    CTDSecondViewController *second = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Second"];
    second.modalPresentationStyle = UIModalPresentationFullScreen;
    second.transitioningDelegate = self;
    [self presentViewController:second animated:YES completion:NULL];
}

- (IBAction)pushViewController:(id)sender
{
    CTDSecondViewController *second = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Second"];
    if (self.navigationController) {
        second.transitioningDelegate = self;
        [self.navigationController pushViewController:second animated:YES];
    }
    else if (self.presentingViewController) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can't push without a navigation controller" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)dismissViewController:(id)sender
{
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.transitioningDelegate = self;
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

@end
