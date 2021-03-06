//
//  ProfilePageViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 20/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "ProfilePageViewController.h"
#import "UIImage+ImageWithColor.h"
#import "UIColor+ColorFromHex.h"
#import <RTSpinKitView.h>

@interface ProfilePageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageRight;
@property (strong, nonatomic) RTSpinKitView *activityIndicator;

@end

@implementation ProfilePageViewController{

    CGFloat _scrollableContentHeight;
    UIView *_referenceViewForWidth;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ProfilePageViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollableContentHeight = SCROLLVIEW_MARGIN_TOP_PROFILE_PAGE;
    
    [self setUpActivityIndicator];
    [self.activityIndicator startAnimating];

    self.imageViewBackground.backgroundColor = [UIColor clearColor];
    self.constraintImageRight.constant = MARGIN_TO_COLLECTION_VIEWS_RIGHT;
    
    _referenceViewForWidth = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    _referenceViewForWidth.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.scrollView addSubview:_referenceViewForWidth];
    self.scrollView.scrollEnabled = NO;
    
    
    UIImageView *border = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor blackColor]]];
    border.frame = CGRectMake(0, 0, 2, self.view.frame.size.height);
    border.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:border];
    
    self.backgroundConstraintTop.constant = - PARALLAX_MARGIN_PROFILE_PAGE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillRotate) name:@"viewWillRotate" object:nil];

}
-(void) setUpActivityIndicator
{
    self.activityIndicator = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave color:[UIColor colorFromHexString:COLOR_ACTIVITY_INDICATOR alpha:ALPHA_ACTIVITY_INDICATOR]];
    [self.view addSubview:self.activityIndicator];
    
    self.activityIndicator.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self.activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:-MARGIN_TO_COLLECTION_VIEWS_RIGHT/2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view layoutIfNeeded];


}

-(void)viewWillAppear:(BOOL)animated
{
    UINavigationController *parentNavigationController = (UINavigationController *)self.navigationController;
    if (parentNavigationController.viewControllers.count == 1) {
        self.buttonNavigateBack.hidden = YES;
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [self updateScrollViewContentSize];
}
-(void) viewWillRotate
{
    [self updateScrollViewContentSize];
}
-(void) setData:(id)data
{
    _data = data;
    [self setUpView];
    self.scrollView.scrollEnabled = YES;

    [self.activityIndicator stopAnimating];
}

-(void) setUpView
{

}

-(void) addModuleViewController:(UIViewController *)viewController ToScrollViewWithHeight:(CGFloat) moduleHeight
{
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    [self.scrollView addSubview:viewController.view];
    viewController.view.frame = CGRectMake(0, _scrollableContentHeight, self.view.frame.size.width-MARGIN_TO_COLLECTION_VIEWS_RIGHT, moduleHeight);
    _scrollableContentHeight += moduleHeight;
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self updateScrollViewContentSize];
}

-(void) updateScrollViewContentSize
{
    [self.scrollView setContentSize:CGSizeMake(_referenceViewForWidth.frame.size.width, _scrollableContentHeight + SCROLLVIEW_MARGIN_BOTTOM_PROFILE_PAGE)];
}

- (IBAction)buttonBackTapped:(id)sender{
    [self.delegate backButtonTappedInMediaProfileView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat verticalScrollDistance = scrollView.bounds.origin.y;
    self.backgroundConstraintTop.constant = -PARALLAX_MARGIN_PROFILE_PAGE -(PARALLAX_SPEED_PROFILE_PAGE * verticalScrollDistance);
    CGFloat newAlpha = 1 - (0.002 * verticalScrollDistance);
    if (newAlpha < 0) {
        newAlpha = 0;
    }
    self.imageViewBackground.alpha = newAlpha;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
