//
//  RootViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 29/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "RootViewController.h"
#import "ContentViewControllerDelegate.h"
#import "MediaProfileNavigationController.h"
#import "MediaPlayerViewController.h"
#import "MainViewController.h"
#import "UIColor+ColorFromHex.h"


#define WIDTH_OF_MEDIA_PLAYER 300
#define HEIGHT_OF_MEDIA_PLAYER 220
#define PROFILE_VIEW_WIDTH_FRACTION 0.9f
#define BLUR_VIEW_ALPHA 1.0f

@interface RootViewController () <ContentViewControllerDelegate, UIGestureRecognizerDelegate, MediaPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentViewPlaceholder;

@end

@implementation RootViewController{
    UIViewController *_activeViewController;
    NSLayoutConstraint *_MediaProfileLeadingConstraint;
    MediaProfileNavigationController *_mediaProfileNavigationController;
    UITapGestureRecognizer *_tapToCloseGestureRecognizer;
    MediaPlayerViewController *_mediaPlayerViewController;
    FXBlurView *_blurView;
    CGAffineTransform _transformBackground;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE];
    
    MainViewController *searchViewController = [[MainViewController alloc]init];
    [self addContentViewController:searchViewController];
    searchViewController.delegate = self;
    
    _tapToCloseGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHappenedToCloseNavigationController:)];
    _tapToCloseGestureRecognizer.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoSelected:) name:@"videoSelected" object:nil];
    
    CGAffineTransform transformScale = CGAffineTransformMakeScale(0.90, 0.90);
    CGAffineTransform transformTranslation = CGAffineTransformMakeTranslation(-60, 0);
    _transformBackground =  CGAffineTransformConcat(transformScale, transformTranslation);
    
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

-(void) addContentViewController:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    [self.contentViewPlaceholder addSubview:viewController.view];
    viewController.view.frame = self.view.bounds;
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _activeViewController = viewController;
    
}

-(void) itemSelectedWithFoorseeIdNumber:(NSString *) idNumber
{
    if (_mediaProfileNavigationController == nil) {
        [self addMediaProfileNavigationControllerWithItemWithIdNumber:idNumber];
    }
    
}

-(void) addMediaProfileNavigationControllerWithItemWithIdNumber:(NSString *) idNumber
{
    [self addBlurOverlay];
    
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
    
    [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _MediaProfileLeadingConstraint.constant = 0;
        [self.view layoutIfNeeded];
        [self.view addGestureRecognizer:_tapToCloseGestureRecognizer];
    } completion:^(BOOL finished) {
        if (finished) {
            [_mediaProfileNavigationController presentMediaProfileForItemWithFoorseeId:idNumber];
        }
    }];
    
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
        [self removeBlurOverlay];
        [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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

-(void) addBlurOverlay
{
    _blurView = [[FXBlurView alloc] initWithFrame:self.view.bounds];
    _blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [_blurView setDynamic:NO];
    _blurView.tintColor = [UIColor blackColor];
    _blurView.alpha = 0;
    [self.view addSubview:_blurView];
    [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE animations:^{
        _blurView.alpha = BLUR_VIEW_ALPHA;
        
        _activeViewController.view.transform = _transformBackground;
    }];

}
-(void) removeBlurOverlay
{
    if (_blurView != nil) {
        [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE animations:^{
            _blurView.alpha = 0.0;
            _activeViewController.view.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            if (finished) {
                [_blurView removeFromSuperview];
                _blurView = nil;
            }
        }];
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

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    _activeViewController.view.transform = CGAffineTransformIdentity;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    if (_blurView) {
        
        _activeViewController.view.transform = _transformBackground;
    }
}

@end
