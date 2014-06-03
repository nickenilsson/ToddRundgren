//
//  MediaProfileNavigationControllerViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 24/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "MediaProfileNavigationController.h"
#import "FoorseeHTTPClient.h"
#import "MediaProfileViewController.h"
#import "PersonProfileViewController.h"
#import "UIColor+ColorFromHex.h"

@interface MediaProfileNavigationController () <MediaProfileDelegate>

@end

@implementation MediaProfileNavigationController{
    FoorseeHTTPClient *_foorseeSessionManager;
    NSString *_foorseeIdOfCurrentlyActiveProfile;
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
    _foorseeSessionManager = [FoorseeHTTPClient sharedForeseeHTTPClient];
    self.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foorseeItemSelected:) name:@"foorseeItemSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foorseePersonSelected:) name:@"foorseePersonSelected" object:nil];
}

-(void) foorseeItemSelected:(NSNotification *)notification
{
    NSDictionary *notificationInfo = [notification userInfo];
    NSString *foorseeId = notificationInfo[@"foorseeId"];
    [self presentMediaProfileForItemWithFoorseeId:foorseeId animated:YES];
}
-(void) foorseePersonSelected: (NSNotification *) notification
{
    NSDictionary *notificationInfo = [notification userInfo];
    NSString *foorseeId = notificationInfo[@"foorseeId"];
    
    [self presentPersonProfileForItemWithFoorseeId:foorseeId];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) presentMediaProfileForItemWithFoorseeId:(NSString *) foorseeId animated:(BOOL) shouldAnimate
{
    if ([_foorseeIdOfCurrentlyActiveProfile isEqualToString:foorseeId]) {
        return;
    }
    MediaProfileViewController *newMediaProfileView = [[MediaProfileViewController alloc]init];
    newMediaProfileView.view.frame = self.view.frame;
    newMediaProfileView.delegate = self;
    newMediaProfileView.view.autoresizingMask = self.view.autoresizingMask;
    newMediaProfileView.view.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE];
    
    [self addViewController:newMediaProfileView toControlledStackAnimation:shouldAnimate];
    [_foorseeSessionManager GET:[NSString stringWithFormat:@"movies/id/%@.json",foorseeId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        newMediaProfileView.data = responseObject;
        _foorseeIdOfCurrentlyActiveProfile = foorseeId;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

-(void) presentPersonProfileForItemWithFoorseeId:(NSString *) foorseeId
{
    if ([_foorseeIdOfCurrentlyActiveProfile isEqualToString:foorseeId]) {
        return;
    }
    PersonProfileViewController *newPersonProfileViewController = [[PersonProfileViewController alloc]init];
    newPersonProfileViewController.view.frame = self.view.frame;
    newPersonProfileViewController.delegate = self;
    newPersonProfileViewController.view.autoresizingMask = self.view.autoresizingMask;
    newPersonProfileViewController.view.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_PROFILE_PAGE];
    [self addViewController:newPersonProfileViewController toControlledStackAnimation:YES];
    
    [_foorseeSessionManager GET:[NSString stringWithFormat:@"cast/id/%@.json",foorseeId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        newPersonProfileViewController.data = responseObject;
        _foorseeIdOfCurrentlyActiveProfile = foorseeId;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

-(void) addViewController:(UIViewController *)vc toControlledStackAnimation:(BOOL) animate
{
    NSMutableArray *viewControllersInStack = [NSMutableArray arrayWithArray:self.viewControllers];
    if (viewControllersInStack.count > NUMBER_OF_PROFILE_PAGES_MAXIMUM) {
        [viewControllersInStack removeObjectAtIndex:0];
        [self setViewControllers:viewControllersInStack];
    }
    [self pushViewController:vc animated:animate];
}

-(void) backButtonTappedInMediaProfileView
{
    [self popViewControllerAnimated:YES];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}



@end
