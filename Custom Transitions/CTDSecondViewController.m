//
//  CTDSecondViewController.m
//  Custom Transitions
//
//  Created by Devon on 12/26/2013.
//  Copyright (c) 2013 Devon. All rights reserved.
//

#import "CTDDragToDismissTransition.h"
#import "CTDSecondViewController.h"

@interface CTDSecondViewController () <UIViewControllerTransitioningDelegate>
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

- (IBAction)modalPresentViewController:(id)sender
{
    if (!self.presentingViewController) {
        CTDSecondViewController *second = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Second"];
        second.modalPresentationStyle = UIModalPresentationFullScreen;
        second.transitioningDelegate = self;
        [self presentViewController:second animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can't modally present something when you are already modally presented" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)pushViewController:(id)sender
{
    CTDSecondViewController *second = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Second"];
    if (self.navigationController) {
        second.transitioningDelegate = self;
        [self.navigationController pushViewController:second animated:YES];
    }
    else if (self.presentingViewController) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can't modally present something when you are already modally presented" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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


@end
