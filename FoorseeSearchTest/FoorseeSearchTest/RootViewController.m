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
#import <XCDYouTubeVideoPlayerViewController.h>



#define WIDTH_OF_MEDIA_PLAYER 300
#define HEIGHT_OF_MEDIA_PLAYER 220
#define PROFILE_VIEW_WIDTH_FRACTION 0.9f
#define BLUR_VIEW_ALPHA 1.0f
#define TRANSLATION_BACKGROUND 30

@interface RootViewController () <ContentViewControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentViewPlaceholder;
@property (strong, nonatomic) UIViewController *activeViewController;
@property (strong, nonatomic) NSLayoutConstraint *constraintMediaProfileLeading;
@property (strong, nonatomic) MediaProfileNavigationController *mediaProfileNavigationController;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) MediaPlayerViewController *mediaPlayerViewController;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *screenEdgePanRecognizer;
@property (nonatomic) CGFloat constraintConstantProfilePageOpened;
@property (nonatomic) CGFloat constraintConstantProfilePageClosed;
@property (nonatomic) CGFloat lastTranslation;
@property (nonatomic) FXBlurView *blurView;
@property (strong, nonatomic) UIView *placeholderForMoviePlayer;

@property (strong, nonatomic) UIButton *arrowButton;


@property (nonatomic) BOOL isMovingMediaProfile;
@property (nonatomic) BOOL isProfilePageOpen;
@property (nonatomic) BOOL blurNeedsUpdateBeforeAnimation;

@property (nonatomic) BOOL videoIsActive;

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

    self.view.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE alpha:1.0];
    
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

    NSDictionary *userinfo = [notification userInfo];
    
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier: userinfo[@"youtubeVideoId"]];
    
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
    self.videoIsActive = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    self.videoIsActive = NO;
    NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
	if (error)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
		[alertView show];
	}

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
    [self openMediaProfileNavigationControllerWithItemWithIdNumber:idNumber];
}

-(void) openMediaProfileNavigationControllerWithItemWithIdNumber:(NSString *) idNumber
{
    if (self.mediaProfileNavigationController == nil) {
        
        self.mediaProfileNavigationController = [[MediaProfileNavigationController alloc]init];
        [self addChildViewController:self.mediaProfileNavigationController];
        [self.mediaProfileNavigationController didMoveToParentViewController:self];
        [self.view addSubview:self.mediaProfileNavigationController.view];
        [self setConstraintsForMediaProfileNavigationController];
        [self.view layoutIfNeeded];
        [self addArrowButton];
        [self.arrowButton setImage:[UIImage imageNamed:@"arrow_profile_close.png"] forState:UIControlStateNormal ];
    }

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
    
    [self.arrowButton setImage:[UIImage imageNamed:@"arrow_profile_close.png"] forState:UIControlStateNormal ];
    [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.constraintMediaProfileLeading.constant = self.constraintConstantProfilePageOpened;
        self.blurView.alpha = BLUR_VIEW_ALPHA;
        self.activeViewController.view.transform = CGAffineTransformMakeTranslation(-TRANSLATION_BACKGROUND, 0);
        [self.view layoutIfNeeded];
        [self.view addGestureRecognizer:self.tapGestureRecognizer];
        if (idNumber != nil) {
            [self.mediaProfileNavigationController presentMediaProfileForItemWithFoorseeId:idNumber animated:NO];
        }
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.isProfilePageOpen = YES;
        }
    }];
    
}
-(void) addArrowButton
{
    self.arrowButton = [[UIButton alloc] init];
    [self.arrowButton addTarget:self action:@selector(arrowButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.arrowButton addTarget:self action:@selector(arrowButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.arrowButton setImage:[UIImage imageNamed:@"arrow_profile_open (1).png"] forState:UIControlStateNormal];
    [self.view addSubview:self.arrowButton];
    self.arrowButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(90)-[button(%d)]",ARROW_BUTTON_HEIGHT] options:0 metrics:nil views:@{@"button": self.arrowButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[button(%d)]-(-2)-[mediaProfileView]",ARROW_BUTTON_WIDTH] options:0 metrics:nil views:@{@"button": self.arrowButton, @"mediaProfileView":self.mediaProfileNavigationController.view}]];
    [self.view layoutIfNeeded];
    
}
-(void) arrowButtonTouchDown:(UIButton *) sender
{
    self.mediaProfileNavigationController.view.hidden = NO;
    self.blurView.hidden = NO;
    self.isMovingMediaProfile = YES;
}
 
-(void) arrowButtonTouchUpInside:(UIButton *) sender
{
    if (self.isProfilePageOpen) {
        
        [self closeAndHideMediaProfileNavigationController];
    }else{
        
        [self openMediaProfileNavigationControllerWithItemWithIdNumber:nil];
    }
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

-(void) closeAndHideMediaProfileNavigationController
{
    [self.arrowButton setImage:[UIImage imageNamed:@"arrow_profile_open (1).png"] forState:UIControlStateNormal ];
    [UIView animateWithDuration:DURATION_PROFILE_PAGE_OPEN_CLOSE delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
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
        self.isProfilePageOpen = NO;
        
    }];
}

-(void) addBlurOverlay
{
    if (!self.blurView) {
        self.blurView = [[FXBlurView alloc] init];
        [self.blurView setDynamic:NO];
        
        self.blurView.tintColor = [UIColor colorFromHexString:COLOR_HEX_RESULT_SECTION alpha:1.0];
        self.blurView.alpha = 0;
        self.blurView.frame = self.activeViewController.view.frame;
        self.blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.activeViewController.view addSubview:self.blurView];

    }
}



-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchLocation = [gestureRecognizer locationInView:self.view];
    if ([gestureRecognizer isEqual:self.tapGestureRecognizer] && CGRectContainsPoint(self.mediaProfileNavigationController.view.frame, touchLocation)) {
        return NO;
    }
    else{
        return YES;
    }
}
-(void) tapHappened:(UITapGestureRecognizer *) sender
{
    [self closeAndHideMediaProfileNavigationController];
}
-(void) handlePan:(UIPanGestureRecognizer *) panGestureRecognizer
{
    if (self.mediaProfileNavigationController.view.hidden || self.mediaProfileNavigationController == nil) {
        return;
    }
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    
    if ([panGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if (CGRectContainsPoint(self.mediaProfileNavigationController.view.frame, touchLocation)) {
            self.isMovingMediaProfile = YES;
        }
    }
    if ([panGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        if (!CGRectContainsPoint(self.mediaProfileNavigationController.view.frame, touchLocation) && self.isMovingMediaProfile == NO) {
            [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
            return;
        }else if (self.isMovingMediaProfile == NO){
            self.isMovingMediaProfile = YES;
        }
        CGFloat horizontalTranslation = [panGestureRecognizer translationInView:self.view].x;
        
        CGFloat translationConstant = TRANSLATION_BACKGROUND/(self.mediaProfileNavigationController.view.frame.size.width);
        CGFloat translation = translationConstant * horizontalTranslation;
        CGFloat alphaConstant = BLUR_VIEW_ALPHA / (self.mediaProfileNavigationController.view.frame.size.width-MARGIN_TO_COLLECTION_VIEWS_RIGHT);
        
        CGFloat alpha = ABS(self.constraintMediaProfileLeading.constant * alphaConstant);
        
        if (self.constraintMediaProfileLeading.constant > 0)
        {
            horizontalTranslation = 0;
            translation = 0;
            alpha = 0;
        }else if (self.constraintMediaProfileLeading.constant + horizontalTranslation < self.constraintConstantProfilePageOpened){
            if (horizontalTranslation < 0) {
                horizontalTranslation /= 5;
            }else{
                self.isMovingMediaProfile = NO;
            }
            if (ABS(self.constraintMediaProfileLeading.constant-self.constraintConstantProfilePageOpened + horizontalTranslation) > MARGIN_TO_COLLECTION_VIEWS_RIGHT) {
                horizontalTranslation = 0;
            }
            translation = 0;
            alpha = BLUR_VIEW_ALPHA;
        }
        
        self.constraintMediaProfileLeading.constant += horizontalTranslation;
        self.blurView.alpha = alpha;
        self.activeViewController.view.transform = CGAffineTransformTranslate(self.activeViewController.view.transform, translation, 0);
        self.lastTranslation = horizontalTranslation;
    }
    else if ([panGestureRecognizer state] == UIGestureRecognizerStateEnded || [panGestureRecognizer state] == UIGestureRecognizerStateFailed) {
        CGFloat velocityX =[panGestureRecognizer velocityInView:self.view].x;
        if (velocityX > 600) {
            [self closeAndHideMediaProfileNavigationController];
        }else if (velocityX < -200){
            [self openMediaProfileNavigationControllerWithItemWithIdNumber:nil];
        }
        else if (self.mediaProfileNavigationController.view.frame.origin.x > CGRectGetMaxX(self.view.frame)/2) {
            [self closeAndHideMediaProfileNavigationController];
        }
        else{
            [self openMediaProfileNavigationControllerWithItemWithIdNumber:nil];
        }
        
        self.isMovingMediaProfile = NO;
        
    }
    
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
}

-(void) handleScreenEdgePan:(UIScreenEdgePanGestureRecognizer *) sender
{
    if ([sender state] == UIGestureRecognizerStateBegan) {
        if (self.mediaProfileNavigationController != nil) {
            
            self.mediaProfileNavigationController.view.hidden = NO;
            self.blurView.hidden = NO;
            
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
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isEqual:self.panGestureRecognizer] && [otherGestureRecognizer isEqual:self.screenEdgePanRecognizer]) {
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
        self.constraintMediaProfileLeading.constant = self.constraintConstantProfilePageOpened;
        
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
-(BOOL)shouldAutorotate
{
    if (self.videoIsActive) {
        return NO;
    }else{
        return YES;
    }
}

-(CGFloat)constraintConstantProfilePageOpened
{
    return -self.mediaProfileNavigationController.view.frame.size.width + MARGIN_TO_COLLECTION_VIEWS_RIGHT;
}

@end
