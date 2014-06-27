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
#import "PersonItemHeaderModuleViewController.h"
#import "MoviesModuleViewController.h"
#import "UIImageView+BackgroundGradient.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"

@interface PersonProfileViewController ()

@end

@implementation PersonProfileViewController {

    PersonItemHeaderModuleViewController *_headerModuleViewController;
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
}

-(void)setUpView
{
    
    if (self.data[@"name"]) {
        _headerModuleViewController = [[PersonItemHeaderModuleViewController alloc] init];
        [self addModuleViewController:_headerModuleViewController ToScrollViewWithHeight:HEIGHT_HEADER_MODULE_PROFILE_PAGE];
        _headerModuleViewController.data = self.data;
    }
    if (self.data[@"related"][@"movies"][@"isAvailable"] == [NSNumber numberWithBool:YES]) {
        _moviesModuleViewController = [[MoviesModuleViewController alloc]init];
        [self addModuleViewController:_moviesModuleViewController ToScrollViewWithHeight:HEIGHT_POSTER_THUMBNAILS];
        _moviesModuleViewController.data = self.data[@"related"][@"movies"][@"items"];
        _moviesModuleViewController.labelModuleTitle.text = @"Appearances";
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
