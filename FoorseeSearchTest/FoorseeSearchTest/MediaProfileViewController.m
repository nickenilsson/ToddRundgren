//
//  MediaProfileViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 24/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "MediaProfileViewController.h"
#import "HeaderModuleViewController.h"
#import "ExternalSourcesModuleViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"

#define HEIGHT_HEADER_MODULE 350
#define HEIGHT_EXTERNAL_SOURCES_MODULE 200

@interface MediaProfileViewController ()

@property (strong, nonatomic) id data;

@end

@implementation MediaProfileViewController{

    HeaderModuleViewController *_headerModuleViewController;
    ExternalSourcesModuleViewController *_externalSourcesViewController;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews
{

}
-(void) setData:(id)data
{
    _data = data;
    [self setUpView];
    
}

-(void) setUpView
{
    [self addHeaderModuleView];
    if (_data[@"products"]) {
        [self addExternalSourcesModule];
    }
    [self.scrollView setContentSize:CGSizeMake(_headerModuleViewController.view.frame.size.width, _scrollableContentHeight)];
}

-(void) addHeaderModuleView
{
    _headerModuleViewController = [[HeaderModuleViewController alloc] init];
    [self addChildViewController:_headerModuleViewController];
    [_headerModuleViewController didMoveToParentViewController:self];
    
    _headerModuleViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_HEADER_MODULE);
    _scrollableContentHeight += HEIGHT_HEADER_MODULE;
    
    NSString *mediaTitle = self.data[@"title"];
    _headerModuleViewController.titleText = mediaTitle;
    
    NSString *description = self.data[@"plot"];
    _headerModuleViewController.descriptionText = description;
    
    NSURL *backdropUrl = [NSURL URLWithString:self.data[@"meta"][@"backdrops"][@"originals"][0][@"url"]];
    _headerModuleViewController.urlBackdrop = backdropUrl;
    NSURL *posterUrl = [NSURL URLWithString:self.data[@"meta"][@"posters"][@"thumbnails"][0][@"url"]];
    _headerModuleViewController.urlPoster = posterUrl;
    
    _headerModuleViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [self.scrollView addSubview:_headerModuleViewController.view];
    
    
}
-(void) addExternalSourcesModule
{
    _externalSourcesViewController = [[ExternalSourcesModuleViewController alloc]init];
    [self addChildViewController:_externalSourcesViewController];
    [_externalSourcesViewController didMoveToParentViewController:self];
    
    
    _externalSourcesViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.scrollView addSubview:_externalSourcesViewController.view];
    _externalSourcesViewController.view.frame = CGRectMake(0, _scrollableContentHeight, self.view.frame.size.width, HEIGHT_EXTERNAL_SOURCES_MODULE);
    _externalSourcesViewController.collectionViewItems = _data[@"products"];
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
    [self.scrollView setContentSize:CGSizeMake(_headerModuleViewController.view.frame.size.width, _headerModuleViewController.view.frame.size.height)];

}
@end
