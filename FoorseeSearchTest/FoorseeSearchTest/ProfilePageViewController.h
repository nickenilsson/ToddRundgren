//
//  ProfilePageViewController.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 20/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>


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

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundConstraintTop;
@property (weak, nonatomic) IBOutlet UIButton *buttonNavigateBack;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
