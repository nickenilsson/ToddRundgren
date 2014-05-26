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
#define TRANSLATION_BACKGROUND 60

@interface RootViewController () <ContentViewControllerDelegate, UIGestureRecognizerDelegate, MediaPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentViewPlaceholder;

@end

@implementation RootViewController{
    UIViewController *_activeViewController;
    NSLayoutConstraint *_constraintMediaProfileTrailing;
    MediaProfileNavigationController *_mediaProfileNavigationController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    MediaPlayerViewController *_mediaPlayerViewController;
    FXBlurView *_blurView;
    UIImageView *_viewSnapshot;
    UIPanGestureRecognizer *_panGestureRecognizer;
    BOOL _isMovingMediaProfile;
    
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
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHappened:)];
    _tapGestureRecognizer.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoSelected:) name:@"videoSelected" object:nil];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[mediaPlayer(==%d)]", WIDTH_OF_MEDIA_PLAYER] options:0 metrics:nil views:@{@"mediaPlayer": _mediaPlayerViewController.view}]];
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
    [self.view layoutIfNeeded];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationController]|" options:0 metrics:nil views:@{@"navigationController": _mediaProfileNavigationController.view}]];
    
    _constraintMediaProfileTrailing = [NSLayoutConstraint constraintWithItem:_mediaProfileNavigationController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:_mediaProfileNavigationController.view.frame.size.width];
    
    [self.view addConstraint:_constraintMediaProfileTrailing];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _constraintMediaProfileTrailing.constant = 0;
        [self.view layoutIfNeeded];
        [self.view addGestureRecognizer:_tapGestureRecognizer];
    } completion:^(BOOL finished) {
        if (finished) {
            [_mediaProfileNavigationController presentMediaProfileForItemWithFoorseeId:idNumber];
            [self.view addGestureRecognizer:_panGestureRecognizer];
        }
    }];
    
}

-(void) tapHappened:(UITapGestureRecognizer *) sender
{
    CGPoint touchLocation = [sender locationInView:self.view];
    if (!CGRectContainsPoint(_mediaProfileNavigationController.view.frame, touchLocation)) {
        [self.view removeGestureRecognizer:_tapGestureRecognizer];
        [self closeProfileViewNavigationControllerAnimated:YES];
        
    }
}

-(void) closeProfileViewNavigationControllerAnimated:(BOOL) shouldAnimate
{
    
    if (shouldAnimate) {
        [self removeBlurOverlay];
        
        [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
            _constraintMediaProfileTrailing.constant = _mediaProfileNavigationController.view.frame.size.width;
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
    
    [self.view removeGestureRecognizer:_tapGestureRecognizer];
    [_mediaProfileNavigationController.view removeGestureRecognizer:_panGestureRecognizer];
}

-(void) addBlurOverlay
{
    if (!_blurView) {
        _blurView = [[FXBlurView alloc] init];
        [_activeViewController.view addSubview:_blurView];
        
        _blurView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|" options:0 metrics:nil views:@{@"blurView": _blurView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|" options:0 metrics:nil views:@{@"blurView": _blurView}]];
        
        [_blurView setDynamic:NO];
        _blurView.tintColor = [UIColor blackColor];
        _blurView.alpha = 0;
        
        [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE animations:^{
            _blurView.alpha = BLUR_VIEW_ALPHA;
            _activeViewController.view.transform = CGAffineTransformMakeTranslation(-TRANSLATION_BACKGROUND, 0);
        }];
    }
}

-(void) removeBlurOverlay
{
    if (_blurView) {
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
    if ( [gestureRecognizer isEqual:_tapGestureRecognizer] && CGRectContainsPoint(_mediaProfileNavigationController.view.frame, touchLocation)) {
        return NO;
    }
    else{
        return YES;
    }
}

-(void) handlePan:(UIPanGestureRecognizer *) panGestureRecognizer
{
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
     if (!CGRectContainsPoint(_mediaProfileNavigationController.view.frame, touchLocation) && _isMovingMediaProfile == NO) {
        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
        return;
    }else if (_isMovingMediaProfile == NO){
        _isMovingMediaProfile = YES;
    }
    
    
    CGFloat horizontalTranslation = [panGestureRecognizer translationInView:self.view].x;
    _constraintMediaProfileTrailing.constant += horizontalTranslation;
    CGFloat translationConstant = TRANSLATION_BACKGROUND/_mediaProfileNavigationController.view.frame.size.width;
    CGFloat translation = translationConstant * horizontalTranslation;
    CGFloat alphaConstant = BLUR_VIEW_ALPHA / _mediaProfileNavigationController.view.frame.size.width;
    
    CGFloat alpha = 1 -(_constraintMediaProfileTrailing.constant * alphaConstant);
    
    if (_constraintMediaProfileTrailing.constant > _mediaProfileNavigationController.view.frame.size.width)
    {
        _constraintMediaProfileTrailing.constant = _mediaProfileNavigationController.view.frame.size.width;
        translation = 0;
        alpha = 0;
    }else if (_constraintMediaProfileTrailing.constant < 0){
        _constraintMediaProfileTrailing.constant = 0;
        translation = 0;
        alpha = BLUR_VIEW_ALPHA;
        _isMovingMediaProfile = NO;

    }
    _blurView.alpha = alpha;
    _activeViewController.view.transform = CGAffineTransformTranslate(_activeViewController.view.transform, translation, 0);
    
    if ([panGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        if (_constraintMediaProfileTrailing.constant > _mediaProfileNavigationController.view.frame.size.width/5) {
            [self closeProfileViewNavigationControllerAnimated:YES];
            [_mediaProfileNavigationController.view removeGestureRecognizer:_panGestureRecognizer];
        }else{
            [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE animations:^{
                _constraintMediaProfileTrailing.constant = 0;
                _blurView.alpha = BLUR_VIEW_ALPHA;
                _activeViewController.view.transform = CGAffineTransformMakeTranslation(-TRANSLATION_BACKGROUND, 0);
                [self.view layoutIfNeeded];
            }];
        }
        _isMovingMediaProfile = NO;
        
    }
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (_blurView) {
        
    }
}

@end
