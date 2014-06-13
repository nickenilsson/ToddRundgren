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
@property (strong, nonatomic) UIViewController *activeViewController;
@property (strong, nonatomic) NSLayoutConstraint *constraintMediaProfileLeading;
@property (strong, nonatomic) MediaProfileNavigationController *mediaProfileNavigationController;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) MediaPlayerViewController *mediaPlayerViewController;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *screenEdgePanRecognizer;
@property (nonatomic) CGFloat lastTranslation;
@property (nonatomic) FXBlurView *blurView;


@property (nonatomic) BOOL isMovingMediaProfile;
@property (nonatomic) BOOL blurNeedsUpdateBeforeAnimation;

@end

@implementation RootViewController{
    
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
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHappened:)];
    self.tapGestureRecognizer.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoSelected:) name:@"videoSelected" object:nil];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    self.screenEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenEdgePan:)];
    self.screenEdgePanRecognizer.edges = UIRectEdgeRight;
    self.screenEdgePanRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.screenEdgePanRecognizer];
    
    [self addBlurOverlay];
    self.blurView.hidden = YES;
    self.blurNeedsUpdateBeforeAnimation = YES;
    self.isMovingMediaProfile = NO;

}

-(void) videoSelected:(NSNotification *) notification
{
    if (self.mediaPlayerViewController == nil) {
        [self addMediaPlayerViewController];
    }
    
    NSDictionary *userinfo = [notification userInfo];
    NSString *youtubeVideoId = userinfo[@"youtubeVideoId"];
    [self.mediaPlayerViewController playVideoWithId:youtubeVideoId];
    
}
-(void) addMediaPlayerViewController
{
    self.mediaPlayerViewController = [[MediaPlayerViewController alloc] init];
    
    [self addChildViewController:self.mediaPlayerViewController];
    [self.mediaPlayerViewController didMoveToParentViewController:self];
    [self.view addSubview:self.mediaPlayerViewController.view];
    self.mediaPlayerViewController.delegate = self;
    
    self.mediaPlayerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[mediaPlayer(==%d)]", WIDTH_OF_MEDIA_PLAYER] options:0 metrics:nil views:@{@"mediaPlayer": self.mediaPlayerViewController.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[mediaPlayer(==%d)]|", HEIGHT_OF_MEDIA_PLAYER] options:0 metrics:nil views:@{@"mediaPlayer": self.mediaPlayerViewController.view}]];
    [self.view layoutIfNeeded];
}
-(void) closeMediaPlayer
{
    [self.mediaPlayerViewController removeFromParentViewController];
    [self.mediaPlayerViewController.view removeFromSuperview];
    self.mediaPlayerViewController = nil;
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
    self.activeViewController = viewController;
    
}

-(void) itemSelectedWithFoorseeIdNumber:(NSString *) idNumber
{
    [self openMediaProfileNavigationControllerWithItemWithIdNumber:idNumber animationOptions:UIViewAnimationOptionCurveEaseInOut];
}

-(void) openMediaProfileNavigationControllerWithItemWithIdNumber:(NSString *) idNumber animationOptions:(UIViewAnimationOptions) animationOptions
{
    if (self.mediaProfileNavigationController == nil) {
        
        self.mediaProfileNavigationController = [[MediaProfileNavigationController alloc]init];
        [self addChildViewController:self.mediaProfileNavigationController];
        [self.mediaProfileNavigationController didMoveToParentViewController:self];
        [self.view addSubview:self.mediaProfileNavigationController.view];
        [self setConstraintsForMediaProfileNavigationController];
        [self.view layoutIfNeeded];
    }
    
    self.isMovingMediaProfile = YES;
    
    if (self.blurNeedsUpdateBeforeAnimation) {
        [self.blurView updateAsynchronously:YES completion:nil];
        self.blurNeedsUpdateBeforeAnimation = NO;
    }
    self.blurView.hidden = NO;

    
    self.mediaProfileNavigationController.view.hidden = NO;
    if (self.mediaPlayerViewController != nil) {
        [self.view insertSubview:self.mediaProfileNavigationController.view belowSubview:self.mediaPlayerViewController.view];
    }

    [self.view layoutIfNeeded];
    
    
    [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.constraintMediaProfileLeading.constant = -self.mediaProfileNavigationController.view.frame.size.width;
        self.blurView.alpha = BLUR_VIEW_ALPHA;
        self.activeViewController.view.transform = CGAffineTransformMakeTranslation(-TRANSLATION_BACKGROUND, 0);
        [self.view layoutIfNeeded];
        [self.view addGestureRecognizer:self.tapGestureRecognizer];
        
        self.panGestureRecognizer.delegate = self;
    } completion:^(BOOL finished) {
        if (finished) {
            if (idNumber != nil) {
                [self.mediaProfileNavigationController presentMediaProfileForItemWithFoorseeId:idNumber animated:NO];
            }
        }
    }];

}
-(void) setConstraintsForMediaProfileNavigationController
{
    self.mediaProfileNavigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaProfileNavigationController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:PROFILE_VIEW_WIDTH_FRACTION constant:0]];
    [self.view layoutIfNeeded];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationController]|" options:0 metrics:nil views:@{@"navigationController": self.mediaProfileNavigationController.view}]];
    
    self.constraintMediaProfileLeading = [NSLayoutConstraint constraintWithItem:self.mediaProfileNavigationController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    [self.view addConstraint:self.constraintMediaProfileLeading];
}

-(void) tapHappened:(UITapGestureRecognizer *) sender
{
    CGPoint touchLocation = [sender locationInView:self.view];
    if (!CGRectContainsPoint(self.mediaProfileNavigationController.view.frame, touchLocation)) {
        [self closeAndHideMediaProfileNavigationController];
        
    }
}

-(void) closeAndHideMediaProfileNavigationController
{
    [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        self.constraintMediaProfileLeading.constant = 0;
        self.blurView.alpha = 0.0;
        self.activeViewController.view.transform = CGAffineTransformIdentity;
        [self.view layoutIfNeeded];
        [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    } completion:^(BOOL finished) {
        self.mediaProfileNavigationController.view.hidden = YES;
        self.blurView.hidden = YES;
        self.blurNeedsUpdateBeforeAnimation = YES;
        self.isMovingMediaProfile = NO;
    }];
    
}

-(void) addBlurOverlay
{
    if (!self.blurView) {
        self.blurView = [[FXBlurView alloc] init];
        [self.blurView setDynamic:NO];
        
        self.blurView.tintColor = [UIColor colorFromHexString:COLOR_HEX_RESULT_SECTION];
        self.blurView.alpha = 0;
        self.blurView.frame = self.activeViewController.view.frame;
        self.blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.activeViewController.view addSubview:self.blurView];

    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchLocation = [gestureRecognizer locationInView:self.view];
    if ( [gestureRecognizer isEqual:self.tapGestureRecognizer] && CGRectContainsPoint(self.mediaProfileNavigationController.view.frame, touchLocation)) {
        return NO;
    }
    else{
        return YES;
    }
}

-(void) handlePan:(UIPanGestureRecognizer *) panGestureRecognizer
{
    if (self.mediaProfileNavigationController.view.hidden) {
        return;
    }
    
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];

    if (!CGRectContainsPoint(self.mediaProfileNavigationController.view.frame, touchLocation) && self.isMovingMediaProfile == NO) {
        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
        return;
    }else if (self.isMovingMediaProfile == NO){
        self.isMovingMediaProfile = YES;
    }

    CGFloat horizontalTranslation = [panGestureRecognizer translationInView:self.view].x;
    self.constraintMediaProfileLeading.constant += horizontalTranslation;
    CGFloat translationConstant = TRANSLATION_BACKGROUND/self.mediaProfileNavigationController.view.frame.size.width;
    CGFloat translation = translationConstant * horizontalTranslation;
    CGFloat alphaConstant = BLUR_VIEW_ALPHA / self.mediaProfileNavigationController.view.frame.size.width;
    
    CGFloat alpha = ABS(self.constraintMediaProfileLeading.constant * alphaConstant);
    
    if (self.constraintMediaProfileLeading.constant > 0)
    {
        self.constraintMediaProfileLeading.constant = 0;
        translation = 0;
        alpha = 0;
    }else if (self.constraintMediaProfileLeading.constant < -self.mediaProfileNavigationController.view.frame.size.width){
        self.constraintMediaProfileLeading.constant = -self.mediaProfileNavigationController.view.frame.size.width;
        translation = 0;
        alpha = BLUR_VIEW_ALPHA;
        self.isMovingMediaProfile = NO;
    }
    
    self.blurView.alpha = alpha;
    self.activeViewController.view.transform = CGAffineTransformTranslate(self.activeViewController.view.transform, translation, 0);
    
    if ([panGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        if (self.lastTranslation > 0) {
            [self closeAndHideMediaProfileNavigationController];
        }else{
            [self openMediaProfileNavigationControllerWithItemWithIdNumber:nil animationOptions:UIViewAnimationOptionCurveLinear];
        }
        self.isMovingMediaProfile = NO;
        
    }
    self.lastTranslation = horizontalTranslation;
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
}

-(void) handleScreenEdgePan:(UIScreenEdgePanGestureRecognizer *) sender
{
    if (self.mediaProfileNavigationController != nil && !self.isMovingMediaProfile) {
        
        self.mediaProfileNavigationController.view.hidden = NO;

        if (self.blurView.hidden) {
            self.blurView.hidden = NO;
        }
        self.isMovingMediaProfile = YES;
        
        if (self.blurNeedsUpdateBeforeAnimation) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.blurView updateAsynchronously:YES completion:^{
                    self.blurNeedsUpdateBeforeAnimation = NO;
                }];
            });
            
        }
    
    }


}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (([gestureRecognizer isEqual:self.screenEdgePanRecognizer] && [otherGestureRecognizer isEqual:self.panGestureRecognizer]) || ([gestureRecognizer isEqual:self.panGestureRecognizer] && [otherGestureRecognizer isEqual:self.screenEdgePanRecognizer])) {
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
    
    if (self.mediaProfileNavigationController != nil && self.mediaProfileNavigationController.view.hidden == NO) {
        self.constraintMediaProfileLeading.constant = -self.mediaProfileNavigationController.view.frame.size.width;
        
    }
    if (self.blurView) {
        [self.blurView updateAsynchronously:YES completion:nil];
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}


@end
