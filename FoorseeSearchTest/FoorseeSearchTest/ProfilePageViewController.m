//
//  ProfilePageViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 20/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "ProfilePageViewController.h"

@interface ProfilePageViewController () <UIScrollViewDelegate>

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
    [self.activityIndicator startAnimating];
    _referenceViewForWidth = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    _referenceViewForWidth.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.scrollView addSubview:_referenceViewForWidth];
}

-(void) setData:(id)data
{
    _data = data;
    [self setUpView];
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
    viewController.view.frame = CGRectMake(0, _scrollableContentHeight, self.view.frame.size.width, moduleHeight);
    _scrollableContentHeight += moduleHeight;
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self updateScrollViewContentSize];
}

-(void) updateScrollViewContentSize
{
    [self.scrollView setContentSize:CGSizeMake(_referenceViewForWidth.frame.size.width, _scrollableContentHeight + SCROLLVIEW_MARGIN_BOTTOM)];
}
- (IBAction)buttonBackTapped:(id)sender{
    [self.delegate backButtonTappedInMediaProfileView];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat verticalScrollDistance = scrollView.bounds.origin.y;
    self.backgroundConstraintTop.constant = -PARALLAX_MARGIN -(PARALLAX_SPEED * verticalScrollDistance);
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
