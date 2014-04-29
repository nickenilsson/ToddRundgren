//
//  RootViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 29/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "RootViewController.h"
#import "SearchViewController.h"
#import "ContentViewControllerDelegate.h"
#import "MediaProfileNavigationController.h"

#define PROFILE_VIEW_WIDTH_FRACTION 0.75f
#define DURATION_NAVIGATION_CONTROLLER_SLIDE_IN 0.3f

@interface RootViewController () <ContentViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentViewPlaceholder;

- (IBAction)tappedButtonToGoToSearchView:(id)sender;
- (IBAction)tappedButtonToGoToDiscoverView:(id)sender;
- (IBAction)tappedButtonToGoToProfileView:(id)sender;

@end

@implementation RootViewController{
    UIViewController *_activeViewController;
    NSLayoutConstraint *_MediaProfileLeadingConstraint;
    MediaProfileNavigationController *_mediaProfileNavigationController;
    UITapGestureRecognizer *_tapToCloseGestureRecognizer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _activeViewController = [[SearchViewController alloc]init];
    [self addChildViewController:_activeViewController];
    [self.contentViewPlaceholder addSubview:_activeViewController.view];
    _activeViewController.view.frame = self.contentViewPlaceholder.bounds;
    _activeViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    SearchViewController *activeViewController = (SearchViewController *) _activeViewController;
    activeViewController.delegate = self;
    
    _tapToCloseGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHappenedToCloseNavigationController:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedButtonToGoToSearchView:(id)sender {
    
}

- (IBAction)tappedButtonToGoToDiscoverView:(id)sender {
    
}

- (IBAction)tappedButtonToGoToProfileView:(id)sender {
    
}

-(void) itemSelectedWithFoorseeIdNumber:(NSString *) idNumber
{
    [self addMediaProfileNavigationController];
    [_mediaProfileNavigationController presentMediaProfileForItemWithFoorseeId:idNumber];
}

-(void) addMediaProfileNavigationController
{
    _mediaProfileNavigationController = [[MediaProfileNavigationController alloc]init];
    [self addChildViewController:_mediaProfileNavigationController];
    [self.view addSubview:_mediaProfileNavigationController.view];
    
    _mediaProfileNavigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mediaProfileNavigationController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:PROFILE_VIEW_WIDTH_FRACTION constant:0]];
    
    _MediaProfileLeadingConstraint = [NSLayoutConstraint constraintWithItem:_mediaProfileNavigationController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:_mediaProfileNavigationController.view.frame.size.width];
    
    [self.view addConstraint:_MediaProfileLeadingConstraint];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationController]|" options:0 metrics:nil views:@{@"navigationController": _mediaProfileNavigationController.view}]];
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:DURATION_NAVIGATION_CONTROLLER_SLIDE_IN delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _MediaProfileLeadingConstraint.constant = 0;
        [self.view layoutIfNeeded];
        [self.view addGestureRecognizer:_tapToCloseGestureRecognizer];
    } completion:nil];
    
}
-(void) tapHappenedToCloseNavigationController:(UITapGestureRecognizer *) sender
{
    CGPoint touchLocation = [sender locationInView:self.view];
    if (!CGRectContainsPoint(_mediaProfileNavigationController.view.frame, touchLocation)) {
        
        [self.view removeGestureRecognizer:_tapToCloseGestureRecognizer];
        
        [UIView animateWithDuration:DURATION_NAVIGATION_CONTROLLER_SLIDE_IN delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _MediaProfileLeadingConstraint.constant = _mediaProfileNavigationController.view.frame.size.width;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_mediaProfileNavigationController removeFromParentViewController];
            [_mediaProfileNavigationController.view removeFromSuperview];
            _mediaProfileNavigationController = nil;
        }];
        
    }}
@end
