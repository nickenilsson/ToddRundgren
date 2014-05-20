//
//  ProfilePageViewController.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 20/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewWithGradient.h"

#define HEIGHT_HEADER_MODULE 350
#define HEIGHT_PROVIDERS_MODULE 150
#define HEIGHT_ACTORS_MODULE 320
#define HEIGHT_SIMILAR_CONTENT_MODULE 320
#define HEIGHT_IMAGES_MODULE 320
#define HEIGHT_VIDEOS_MODULE 320
#define SCROLLVIEW_MARGIN_BOTTOM 60
#define SCROLLVIEW_MARGIN_TOP 30
#define PARALLAX_SPEED 0.2
#define PARALLAX_MARGIN 30


@protocol MediaProfileDelegate <NSObject>

@optional

-(void) backButtonTappedInMediaProfileView;

@end

@interface ProfilePageViewController : UIViewController

-(void) setData:(id)data;
-(void) addModuleViewController:(UIViewController *)viewController ToScrollViewWithHeight:(CGFloat) moduleHeight;
- (IBAction)buttonBackTapped:(id)sender;
-(void) updateScrollViewContentSize;

@property (strong, nonatomic) id data;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) id <MediaProfileDelegate> delegate;

@property (weak, nonatomic) IBOutlet ImageViewWithGradient *imageViewBackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundConstraintTop;
@property (weak, nonatomic) IBOutlet UIButton *buttonNavigateBack;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
