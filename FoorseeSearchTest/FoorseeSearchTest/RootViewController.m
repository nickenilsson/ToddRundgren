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
#import "DiscoverViewController.h"
#import "MediaPlayerViewController.h"

#define WIDTH_OF_MEDIA_PLAYER 300
#define HEIGHT_OF_MEDIA_PLAYER 220
#define PROFILE_VIEW_WIDTH_FRACTION 0.8f
#define DURATION_NAVIGATION_CONTROLLER_SLIDE_IN 0.25f

@interface RootViewController () <ContentViewControllerDelegate, UIGestureRecognizerDelegate, MediaPlayerDelegate>

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
    MediaPlayerViewController *_mediaPlayerViewController;
    
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
    [_activeViewController didMoveToParentViewController:self];
    [self.contentViewPlaceholder addSubview:_activeViewController.view];
    _activeViewController.view.frame = self.contentViewPlaceholder.bounds;
    _activeViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    SearchViewController *activeViewController = (SearchViewController *) _activeViewController;
    activeViewController.delegate = self;
    
    _tapToCloseGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHappenedToCloseNavigationController:)];
    _tapToCloseGestureRecognizer.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoSelected:) name:@"videoSelected" object:nil];
    
}
-(void) videoSelected:(NSNotification *) notification
{
    if (_mediaPlayerViewController == nil) {
        [self addMediaPlayerViewController];
    }
    
    NSDictionary *userinfo = [notification userInfo];
    NSString *youtubeVideoId = userinfo[@"youtubeVideoId"];
    [_mediaPlayerViewController playVideoWithId:youtubeVideoId];
    
}
-(void) addMediaPlayerViewController
{
    _mediaPlayerViewController = [[MediaPlayerViewController alloc] init];
    
    [self addChildViewController:_mediaPlayerViewController];
    [_mediaPlayerViewController didMoveToParentViewController:self];
    [self.view addSubview:_mediaPlayerViewController.view];
    _mediaPlayerViewController.delegate = self;
    
    _mediaPlayerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[mediaPlayer(==%d)]|", WIDTH_OF_MEDIA_PLAYER] options:0 metrics:nil views:@{@"mediaPlayer": _mediaPlayerViewController.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[mediaPlayer(==%d)]|", HEIGHT_OF_MEDIA_PLAYER] options:0 metrics:nil views:@{@"mediaPlayer": _mediaPlayerViewController.view}]];
    [self.view layoutIfNeeded];
}
-(void) closeMediaPlayer
{
    [_mediaPlayerViewController removeFromParentViewController];
    [_mediaPlayerViewController.view removeFromSuperview];
    _mediaPlayerViewController = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedButtonToGoToSearchView:(id)sender {
    if (![_activeViewController isKindOfClass:[SearchViewController class]]) {
        
        if (_mediaProfileNavigationController != nil) {
            [self closeProfileViewNavigationControllerAnimated:NO];
        }
        [_activeViewController removeFromParentViewController];
        [_activeViewController.view removeFromSuperview];
        [self addContentViewController:[[SearchViewController alloc]init]];
        SearchViewController *activeViewController = (SearchViewController *) _activeViewController;
        activeViewController.delegate = self;
        
    }
}

- (IBAction)tappedButtonToGoToDiscoverView:(id)sender
{
    if (![_activeViewController isKindOfClass:[DiscoverViewController class]]) {
        
        if (_mediaProfileNavigationController != nil) {
            [self closeProfileViewNavigationControllerAnimated:NO];
        }
        
        [_activeViewController removeFromParentViewController];
        [_activeViewController.view removeFromSuperview];
        [self addContentViewController:[[DiscoverViewController alloc]init]];
        
        DiscoverViewController *activeViewController = (DiscoverViewController *)_activeViewController;
        activeViewController.delegate = self;
        
        
    }
}

- (IBAction)tappedButtonToGoToProfileView:(id)sender
{
    
}


-(void) addContentViewController:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    [self.contentViewPlaceholder addSubview:viewController.view];
    viewController.view.frame = self.contentViewPlaceholder.bounds;
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _activeViewController = viewController;
    
}

-(void) itemSelectedWithFoorseeIdNumber:(NSString *) idNumber
{
    if (_mediaProfileNavigationController == nil) {
        [self addMediaProfileNavigationController];
        [_mediaProfileNavigationController presentMediaProfileForItemWithFoorseeId:idNumber];
    }
    
}

-(void) addMediaProfileNavigationController
{
    _mediaProfileNavigationController = [[MediaProfileNavigationController alloc]init];
    [self addChildViewController:_mediaProfileNavigationController];
    [_mediaProfileNavigationController didMoveToParentViewController:self];
    [self.view addSubview:_mediaProfileNavigationController.view];
    [self.view bringSubviewToFront:_mediaProfileNavigationController.view];
    if (_mediaPlayerViewController != nil) {
        [self.view insertSubview:_mediaProfileNavigationController.view belowSubview:_mediaPlayerViewController.view];
    }
    
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
        [self closeProfileViewNavigationControllerAnimated:YES];
        
    }
}
-(void) closeProfileViewNavigationControllerAnimated:(BOOL) shouldAnimate
{
    if (shouldAnimate) {
        [UIView animateWithDuration:DURATION_NAVIGATION_CONTROLLER_SLIDE_IN delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _MediaProfileLeadingConstraint.constant = _mediaProfileNavigationController.view.frame.size.width;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_mediaProfileNavigationController removeFromParentViewController];
            [_mediaProfileNavigationController.view removeFromSuperview];
            _mediaProfileNavigationController = nil;
        }];
    }else{
        [_mediaProfileNavigationController removeFromParentViewController];
        [_mediaProfileNavigationController.view removeFromSuperview];
        _mediaProfileNavigationController = nil;
    }
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchLocation = [gestureRecognizer locationInView:self.view];
    if ( [gestureRecognizer isEqual:_tapToCloseGestureRecognizer] && CGRectContainsPoint(_mediaProfileNavigationController.view.frame, touchLocation)) {
        return NO;
    }
    else{
        return YES;
    }
}

@end
