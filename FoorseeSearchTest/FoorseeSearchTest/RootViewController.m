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
#import "UIView+Screenshot.h"



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
    NSLayoutConstraint *_constraintMediaProfileLeading;
    MediaProfileNavigationController *_mediaProfileNavigationController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    MediaPlayerViewController *_mediaPlayerViewController;
    UIPanGestureRecognizer *_panGestureRecognizer;
    UIScreenEdgePanGestureRecognizer *_screenEdgePanRecognizer;
    BOOL _isMovingMediaProfile;
    CGFloat _lastTranslation;
    BOOL _blurNeedsUpdateBeforeAnimation;
    FXBlurView *_blurView;
    
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
    _panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_panGestureRecognizer];
    
    _screenEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenEdgePan:)];
    _screenEdgePanRecognizer.edges = UIRectEdgeRight;
    _screenEdgePanRecognizer.delegate = self;
    [self.view addGestureRecognizer:_screenEdgePanRecognizer];
    
    [self addBlurOverlay];
    _blurView.hidden = YES;
    _blurNeedsUpdateBeforeAnimation = YES;
    _isMovingMediaProfile = NO;

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
    [self openMediaProfileNavigationControllerWithItemWithIdNumber:idNumber animationOptions:UIViewAnimationOptionCurveEaseInOut];
}

-(void) openMediaProfileNavigationControllerWithItemWithIdNumber:(NSString *) idNumber animationOptions:(UIViewAnimationOptions) animationOptions
{
    if (_mediaProfileNavigationController == nil) {
        
        _mediaProfileNavigationController = [[MediaProfileNavigationController alloc]init];
        [self addChildViewController:_mediaProfileNavigationController];
        [_mediaProfileNavigationController didMoveToParentViewController:self];
        [self.view addSubview:_mediaProfileNavigationController.view];
        [self setConstraintsForMediaProfileNavigationController];
        [self.view layoutIfNeeded];
    }
    
    _isMovingMediaProfile = YES;
    
    if (_blurNeedsUpdateBeforeAnimation) {
        [_blurView updateAsynchronously:YES completion:nil];
        _blurNeedsUpdateBeforeAnimation = NO;
    }
    _blurView.hidden = NO;

    
    _mediaProfileNavigationController.view.hidden = NO;
    if (_mediaPlayerViewController != nil) {
        [self.view insertSubview:_mediaProfileNavigationController.view belowSubview:_mediaPlayerViewController.view];
    }

    [self.view layoutIfNeeded];
    
    
    [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _constraintMediaProfileLeading.constant = -_mediaProfileNavigationController.view.frame.size.width;
        _blurView.alpha = BLUR_VIEW_ALPHA;
        _activeViewController.view.transform = CGAffineTransformMakeTranslation(-TRANSLATION_BACKGROUND, 0);
        [self.view layoutIfNeeded];
        [self.view addGestureRecognizer:_tapGestureRecognizer];
        
        _panGestureRecognizer.delegate = self;
    } completion:^(BOOL finished) {
        if (finished) {
            if (idNumber != nil) {
                [_mediaProfileNavigationController presentMediaProfileForItemWithFoorseeId:idNumber animated:NO];
            }
        }
    }];

}
-(void) setConstraintsForMediaProfileNavigationController
{
    _mediaProfileNavigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mediaProfileNavigationController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:PROFILE_VIEW_WIDTH_FRACTION constant:0]];
    [self.view layoutIfNeeded];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationController]|" options:0 metrics:nil views:@{@"navigationController": _mediaProfileNavigationController.view}]];
    
    _constraintMediaProfileLeading = [NSLayoutConstraint constraintWithItem:_mediaProfileNavigationController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    [self.view addConstraint:_constraintMediaProfileLeading];
}

-(void) tapHappened:(UITapGestureRecognizer *) sender
{
    CGPoint touchLocation = [sender locationInView:self.view];
    if (!CGRectContainsPoint(_mediaProfileNavigationController.view.frame, touchLocation)) {
        [self closeAndHideMediaProfileNavigationController];
        
    }
}

-(void) closeAndHideMediaProfileNavigationController
{
    [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        _constraintMediaProfileLeading.constant = 0;
        _blurView.alpha = 0.0;
        _activeViewController.view.transform = CGAffineTransformIdentity;
        [self.view layoutIfNeeded];
        [self.view removeGestureRecognizer:_tapGestureRecognizer];
    } completion:^(BOOL finished) {
        _mediaProfileNavigationController.view.hidden = YES;
        _blurView.hidden = YES;
        _blurNeedsUpdateBeforeAnimation = YES;
    }];
    
}

-(void) addBlurOverlay
{
    if (!_blurView) {
        _blurView = [[FXBlurView alloc] init];
        [_blurView setDynamic:NO];
        
        _blurView.tintColor = [UIColor colorFromHexString:COLOR_HEX_RESULT_SECTION];
        _blurView.alpha = 0;
        _blurView.frame = _activeViewController.view.frame;
        _blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_activeViewController.view addSubview:_blurView];

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
    if (_mediaProfileNavigationController.view.hidden) {
        return;
    }
    
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];

    if (!CGRectContainsPoint(_mediaProfileNavigationController.view.frame, touchLocation) && _isMovingMediaProfile == NO) {
        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
        return;
    }else if (_isMovingMediaProfile == NO){
        _isMovingMediaProfile = YES;
    }

    CGFloat horizontalTranslation = [panGestureRecognizer translationInView:self.view].x;
    _constraintMediaProfileLeading.constant += horizontalTranslation;
    CGFloat translationConstant = TRANSLATION_BACKGROUND/_mediaProfileNavigationController.view.frame.size.width;
    CGFloat translation = translationConstant * horizontalTranslation;
    CGFloat alphaConstant = BLUR_VIEW_ALPHA / _mediaProfileNavigationController.view.frame.size.width;
    
    CGFloat alpha = ABS(_constraintMediaProfileLeading.constant * alphaConstant);
    
    if (_constraintMediaProfileLeading.constant > 0)
    {
        _constraintMediaProfileLeading.constant = 0;
        translation = 0;
        alpha = 0;
    }else if (_constraintMediaProfileLeading.constant < -_mediaProfileNavigationController.view.frame.size.width){
        _constraintMediaProfileLeading.constant = -_mediaProfileNavigationController.view.frame.size.width;
        translation = 0;
        alpha = BLUR_VIEW_ALPHA;
        _isMovingMediaProfile = NO;
    }
    
    _blurView.alpha = alpha;
    _activeViewController.view.transform = CGAffineTransformTranslate(_activeViewController.view.transform, translation, 0);
    
    if ([panGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        if (_lastTranslation > 0) {
            [self closeAndHideMediaProfileNavigationController];
        }else{
            [self openMediaProfileNavigationControllerWithItemWithIdNumber:nil animationOptions:UIViewAnimationOptionCurveLinear];
        }
        _isMovingMediaProfile = NO;
        
    }
    _lastTranslation = horizontalTranslation;
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
}

-(void) handleScreenEdgePan:(UIScreenEdgePanGestureRecognizer *) sender
{
    if (_mediaProfileNavigationController != nil && !_isMovingMediaProfile) {
        
        _mediaProfileNavigationController.view.hidden = NO;

        if (_blurView.hidden) {
            _blurView.hidden = NO;
        }
        _isMovingMediaProfile = YES;
        
        if (_blurNeedsUpdateBeforeAnimation) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [_blurView updateAsynchronously:YES completion:^{
                    _blurNeedsUpdateBeforeAnimation = NO;
                }];
            });
            
        }
    
    }


}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (([gestureRecognizer isEqual:_screenEdgePanRecognizer] && [otherGestureRecognizer isEqual:_panGestureRecognizer]) || ([gestureRecognizer isEqual:_panGestureRecognizer] && [otherGestureRecognizer isEqual:_screenEdgePanRecognizer])) {
        return YES;
    }
    return NO;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"viewWillRotate"
                                      object:nil
                                    userInfo:nil];
    
    if (_mediaProfileNavigationController != nil && _mediaProfileNavigationController.view.hidden == NO) {
        _constraintMediaProfileLeading.constant = -_mediaProfileNavigationController.view.frame.size.width;
        
    }
    if (_blurView) {
        [_blurView updateAsynchronously:YES completion:nil];
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}


@end
