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
#import "UIImageView+BackgroundGradient.h"


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

    NSURL *backdropUrl = [NSURL URLWithString:self.data[@"backdropOriginal"][@"url"]];
    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor clearColor]];
    [self.imageViewBackground setImageWithURL:backdropUrl placeholderImage:placeholderImage];
    [self.imageViewBackground addGradientWithColor:[UIColor colorFromHexString:COLOR_HEX_RESULT_SECTION]];
    
    if (self.data[@"title"]) {
        _headerModuleViewController = [[HeaderModuleViewController alloc] init];
        [self addModuleViewController:_headerModuleViewController ToScrollViewWithHeight:HEIGHT_HEADER_MODULE_PROFILE_PAGE];
        _headerModuleViewController.titleText = self.data[@"title"];
        _headerModuleViewController.descriptionText = self.data[@"plot"];
        
        NSURL *posterUrl = [NSURL URLWithString:self.data[@"posterThumbnail"][@"url"]];
        _headerModuleViewController.urlPoster = posterUrl;
        if (self.data[@"rating"]) {
            _headerModuleViewController.rating = self.data[@"rating"][@"score"];
            
        }
        
    }
    if (self.data[@"products"]) {
        _providersModuleViewController = [[ProvidersModuleViewController alloc] init];
        [self addModuleViewController:_providersModuleViewController ToScrollViewWithHeight:HEIGHT_PROVIDERS_MODULE_PROFILE_PAGE];
        _providersModuleViewController.data = self.data[@"products"];
    }
    
    //TODO: make sure it doesn't crash when cast is empty
    if (self.data[@"credits"][@"cast"]) {
        _actorsModuleViewController = [[ActorsModuleViewController alloc] init];
        [self addModuleViewController:_actorsModuleViewController ToScrollViewWithHeight:HEIGHT_ACTORS_MODULE_PROFILE_PAGE];
        _actorsModuleViewController.data = self.data[@"credits"][@"cast"];
        _actorsModuleViewController.labelModuleTitle.text = @"cast";
    }
    if (self.data[@"related"][@"movies"][@"isAvailable"] == [NSNumber numberWithBool:YES]) {
        _similarContentModuleViewController = [[MoviesModuleViewController alloc]init];
        [self addModuleViewController:_similarContentModuleViewController ToScrollViewWithHeight:HEIGHT_SIMILAR_CONTENT_MODULE_PROFILE_PAGE];
        _similarContentModuleViewController.data = self.data[@"related"][@"movies"][@"items"];
        _similarContentModuleViewController.labelModuleTitle.text = @"Similar";
    }
    if (self.data[@"related"][@"webVideos"][@"youtube"][@"isAvailable"] == [NSNumber numberWithBool:YES]) {
        _videosModuleViewController = [[VideoModuleViewController alloc]init];
        [self addModuleViewController:_videosModuleViewController ToScrollViewWithHeight:HEIGHT_VIDEOS_MODULE_PROFILE_PAGE];
        _videosModuleViewController.data = self.data[@"related"][@"webVideos"][@"youtube"][@"items"];
        
    }
    if (self.data[@"backdrops"][@"thumbnails"]) {
        _imagesModuleViewController = [[ImagesModuleViewController alloc]init];
        [self addModuleViewController:_imagesModuleViewController ToScrollViewWithHeight:HEIGHT_IMAGES_MODULE_PROFILE_PAGE];
        _imagesModuleViewController.dataThumbnails = self.data[@"meta"][@"backdrops"][@"thumbnails"];
        _imagesModuleViewController.dataOriginals = self.data[@"meta"][@"backdrops"][@"originals"];

    }
    
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateScrollViewContentSize];

}
@end
