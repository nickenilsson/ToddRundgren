//
//  MediaProfileViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 24/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//



#import "MediaProfileViewController.h"
#import "HeaderModuleViewController.h"
#import "ProvidersModuleViewController.h"
#import "ActorsModuleViewController.h"
#import "SimilarContentModuleViewController.h"
#import "ImagesModuleViewController.h"
#import "VideoModuleViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"
#import "MediaProfileNavigationController.h"
#import "UIColor+ColorFromHex.h"
#import "ImageViewWithGradient.h"

#define HEIGHT_HEADER_MODULE 350
#define HEIGHT_PROVIDERS_MODULE 150
#define HEIGHT_ACTORS_MODULE 300
#define HEIGHT_SIMILAR_CONTENT_MODULE 300
#define HEIGHT_IMAGES_MODULE 300
#define HEIGHT_VIDEOS_MODULE 300
#define SCROLLVIEW_MARGIN_BOTTOM 150
#define SCROLLVIEW_MARGIN_TOP 30
#define PARALLAX_SPEED 0.2
#define PARALLAX_MARGIN 30

@interface MediaProfileViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) id data;
@property (weak, nonatomic) IBOutlet ImageViewWithGradient *imageViewBackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundConstraintTop;
@property (weak, nonatomic) IBOutlet UIButton *buttonNavigateBack;

@end

@implementation MediaProfileViewController{

    HeaderModuleViewController *_headerModuleViewController;
    ProvidersModuleViewController *_providersModuleViewController;
    ActorsModuleViewController *_actorsModuleViewController;
    SimilarContentModuleViewController *_similarContentModuleViewController;
    ImagesModuleViewController *_imagesModuleViewController;
    VideoModuleViewController *_videosModuleViewController;
    
    CAGradientLayer *_backgroundGradient;
    UIView *_contentView;
    UIView *_previousViewInContentView;
    CGFloat _scrollableContentHeight;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didMoveToParentViewController:(UIViewController *)parent
{
    self.view.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE];
    self.imageViewBackground.backgroundColor = [UIColor clearColor];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    _scrollableContentHeight = SCROLLVIEW_MARGIN_TOP;
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [[UIColor blackColor]CGColor];
    
    self.view.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.view.layer.shadowOffset = CGSizeMake(-2, 0);
    self.view.layer.shadowRadius = 10;
    self.view.layer.shadowOpacity = 1.0f;
    self.view.layer.masksToBounds = NO;

    [[UIColor blackColor] setFill];
    self.backgroundConstraintTop.constant = - PARALLAX_MARGIN;
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    UINavigationController *parentNavigationController = (UINavigationController *)self.navigationController;
    if (parentNavigationController.viewControllers.count == 1) {
        self.buttonNavigateBack.hidden = YES;
    }
}
-(void) setData:(id)data
{
    _data = data;
    [self setUpView];
}

-(void) setUpView
{
    NSURL *backdropUrl = [NSURL URLWithString:self.data[@"meta"][@"backdrops"][@"originals"][0][@"url"]];
    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE]];
    [self.imageViewBackground setImageWithURL:backdropUrl placeholderImage:placeholderImage];
    self.imageViewBackground.gradientColor = [UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE];
    
    if (self.data[@"title"]) {
        _headerModuleViewController = [[HeaderModuleViewController alloc] init];
        [self addModuleViewController:_headerModuleViewController ToScrollViewWithHeight:HEIGHT_HEADER_MODULE];
        _headerModuleViewController.titleText = self.data[@"title"];
        _headerModuleViewController.descriptionText = self.data[@"plot"];
        
        NSURL *posterUrl = [NSURL URLWithString:self.data[@"meta"][@"posters"][@"thumbnails"][0][@"url"]];
        _headerModuleViewController.urlPoster = posterUrl;
        
    }
    if (self.data[@"products"]) {
        _providersModuleViewController = [[ProvidersModuleViewController alloc] init];
        [self addModuleViewController:_providersModuleViewController ToScrollViewWithHeight:HEIGHT_PROVIDERS_MODULE];
        _providersModuleViewController.data = self.data[@"products"];
    }
    
    //TODO: make sure it doesn't crash when cast is empty
    if (self.data[@"meta"][@"credits"][@"cast"]) {
        _actorsModuleViewController = [[ActorsModuleViewController alloc] init];
        [self addModuleViewController:_actorsModuleViewController ToScrollViewWithHeight:HEIGHT_ACTORS_MODULE];
        _actorsModuleViewController.data = self.data[@"meta"][@"credits"][@"cast"];
    }
    if (self.data[@"related"][@"movies"][@"isAvailable"] == [NSNumber numberWithBool:YES]) {
        _similarContentModuleViewController = [[SimilarContentModuleViewController alloc]init];
        [self addModuleViewController:_similarContentModuleViewController ToScrollViewWithHeight:HEIGHT_SIMILAR_CONTENT_MODULE];
        _similarContentModuleViewController.data = self.data[@"related"][@"movies"][@"items"];
    }
    if (self.data[@"related"][@"webVideos"][@"youtube"][@"isAvailable"] == [NSNumber numberWithBool:YES]) {
        _videosModuleViewController = [[VideoModuleViewController alloc]init];
        [self addModuleViewController:_videosModuleViewController ToScrollViewWithHeight:HEIGHT_VIDEOS_MODULE];
        _videosModuleViewController.data = self.data[@"related"][@"webVideos"][@"youtube"][@"items"];
        
    }
    if (self.data[@"meta"][@"backdrops"][@"thumbnails"]) {
        _imagesModuleViewController = [[ImagesModuleViewController alloc]init];
        [self addModuleViewController:_imagesModuleViewController ToScrollViewWithHeight:HEIGHT_IMAGES_MODULE];
        _imagesModuleViewController.dataThumbnails = self.data[@"meta"][@"backdrops"][@"thumbnails"];
        _imagesModuleViewController.dataOriginals = self.data[@"meta"][@"backdrops"][@"originals"];

    }
    
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
    [self.scrollView setContentSize:CGSizeMake(_headerModuleViewController.view.frame.size.width, _scrollableContentHeight + SCROLLVIEW_MARGIN_BOTTOM)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonBackTapped:(id)sender
{
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateScrollViewContentSize];

}
@end
