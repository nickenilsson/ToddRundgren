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
#import "MoviesModuleViewController.h"
#import "ImagesModuleViewController.h"
#import "VideoModuleViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"
#import "MediaProfileNavigationController.h"
#import "UIColor+ColorFromHex.h"


@interface MediaProfileViewController () <UIScrollViewDelegate>

@end

@implementation MediaProfileViewController{

    HeaderModuleViewController *_headerModuleViewController;
    ProvidersModuleViewController *_providersModuleViewController;
    ActorsModuleViewController *_actorsModuleViewController;
    MoviesModuleViewController *_similarContentModuleViewController;
    ImagesModuleViewController *_imagesModuleViewController;
    VideoModuleViewController *_videosModuleViewController;
    
    UIView *_contentView;
    UIView *_previousViewInContentView;
    CGFloat _scrollableContentHeight;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ProfilePageViewController" bundle:nibBundleOrNil];
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
    self.view.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE];
    
    
    
}

-(void) setUpView
{

    NSURL *backdropUrl = [NSURL URLWithString:self.data[@"meta"][@"backdrops"][@"originals"][0][@"url"]];
    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor clearColor]];
    [self.imageViewBackground setImageWithURL:backdropUrl placeholderImage:placeholderImage];
    self.imageViewBackground.gradientColor = [UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE];
    
    if (self.data[@"title"]) {
        _headerModuleViewController = [[HeaderModuleViewController alloc] init];
        [self addModuleViewController:_headerModuleViewController ToScrollViewWithHeight:HEIGHT_HEADER_MODULE_PROFILE_PAGE];
        _headerModuleViewController.titleText = self.data[@"title"];
        _headerModuleViewController.descriptionText = self.data[@"plot"];
        
        NSURL *posterUrl = [NSURL URLWithString:self.data[@"posterThumbnail"][@"url"]];
        _headerModuleViewController.urlPoster = posterUrl;
        
    }
    if (self.data[@"products"]) {
        _providersModuleViewController = [[ProvidersModuleViewController alloc] init];
        [self addModuleViewController:_providersModuleViewController ToScrollViewWithHeight:HEIGHT_PROVIDERS_MODULE_PROFILE_PAGE];
        _providersModuleViewController.data = self.data[@"products"];
    }
    
    //TODO: make sure it doesn't crash when cast is empty
    if (self.data[@"meta"][@"credits"][@"cast"]) {
        _actorsModuleViewController = [[ActorsModuleViewController alloc] init];
        [self addModuleViewController:_actorsModuleViewController ToScrollViewWithHeight:HEIGHT_ACTORS_MODULE_PROFILE_PAGE];
        _actorsModuleViewController.data = self.data[@"meta"][@"credits"][@"cast"];
    }
    if (self.data[@"related"][@"movies"][@"isAvailable"] == [NSNumber numberWithBool:YES]) {
        _similarContentModuleViewController = [[MoviesModuleViewController alloc]init];
        [self addModuleViewController:_similarContentModuleViewController ToScrollViewWithHeight:HEIGHT_SIMILAR_CONTENT_MODULE_PROFILE_PAGE];
        _similarContentModuleViewController.data = self.data[@"related"][@"movies"][@"items"];
    }
    if (self.data[@"related"][@"webVideos"][@"youtube"][@"isAvailable"] == [NSNumber numberWithBool:YES]) {
        _videosModuleViewController = [[VideoModuleViewController alloc]init];
        [self addModuleViewController:_videosModuleViewController ToScrollViewWithHeight:HEIGHT_VIDEOS_MODULE_PROFILE_PAGE];
        _videosModuleViewController.data = self.data[@"related"][@"webVideos"][@"youtube"][@"items"];
        
    }
    if (self.data[@"meta"][@"backdrops"][@"thumbnails"]) {
        _imagesModuleViewController = [[ImagesModuleViewController alloc]init];
        [self addModuleViewController:_imagesModuleViewController ToScrollViewWithHeight:HEIGHT_IMAGES_MODULE_PROFILE_PAGE];
        _imagesModuleViewController.dataThumbnails = self.data[@"meta"][@"backdrops"][@"thumbnails"];
        _imagesModuleViewController.dataOriginals = self.data[@"meta"][@"backdrops"][@"originals"];

    }
    
}

//-(void) addModuleViewController:(UIViewController *)viewController ToScrollViewWithHeight:(CGFloat) moduleHeight
//{
//    [self addChildViewController:viewController];
//    [viewController didMoveToParentViewController:self];
//    
//    [self.scrollView addSubview:viewController.view];
//    viewController.view.frame = CGRectMake(0, _scrollableContentHeight, self.view.frame.size.width, moduleHeight);
//    _scrollableContentHeight += moduleHeight;
//    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//
//    [self updateScrollViewContentSize];
//}
//
//-(void) updateScrollViewContentSize
//{
//    [self.scrollView setContentSize:CGSizeMake(_headerModuleViewController.view.frame.size.width, _scrollableContentHeight + SCROLLVIEW_MARGIN_BOTTOM)];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonBackTapped:(id)sender
{
    [self.delegate backButtonTappedInMediaProfileView];
}



-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateScrollViewContentSize];

}
@end
