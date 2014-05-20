//
//  PersonProfileViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 20/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "PersonProfileViewController.h"
#import "MediaProfileViewController.h"
#import "UIColor+ColorFromHex.h"
#import "HeaderModuleViewController.h"
#import "MoviesModuleViewController.h"

@interface PersonProfileViewController ()

@end

@implementation PersonProfileViewController {

    HeaderModuleViewController *_headerModuleViewController;
    MoviesModuleViewController *_moviesModuleViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: @"ProfileViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)didMoveToParentViewController:(UIViewController *)parent
{
    self.view.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE];
    self.imageViewBackground.backgroundColor = [UIColor clearColor];
    
}

-(void)setUpView
{
    if (self.data[@"name"]) {
        _headerModuleViewController = [[HeaderModuleViewController alloc] init];
        [self addModuleViewController:_headerModuleViewController ToScrollViewWithHeight:HEIGHT_HEADER_MODULE];
        _headerModuleViewController.titleText = self.data[@"name"];
        
        NSURL *posterUrl = [NSURL URLWithString:self.data[@"images"][@"thumbnails"][0][@"url"]];
        _headerModuleViewController.urlPoster = posterUrl;
        
    }
    if (self.data[@"related"][@"movies"]) {
        _moviesModuleViewController = [[MoviesModuleViewController alloc]init];
        [self addModuleViewController:_moviesModuleViewController ToScrollViewWithHeight:HEIGHT_POSTER_THUMBNAILS];
        _moviesModuleViewController.data = self.data[@"related"][@"movies"];
    }




}
- (IBAction)buttonBackTapped:(id)sender
{
    [self.delegate backButtonTappedInMediaProfileView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
