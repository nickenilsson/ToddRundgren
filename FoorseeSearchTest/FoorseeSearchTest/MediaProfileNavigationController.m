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
#import "UIColor+ColorFromHex.h"

@interface MediaProfileNavigationController () <MediaProfileDelegate>

@end

@implementation MediaProfileNavigationController{
    FoorseeHTTPClient *_foorseeSessionManager;
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foorseeItemSelected:) name:@"foorseeItemSelected" object:nil];
}

-(void) foorseeItemSelected:(NSNotification *)notification
{
    NSDictionary *notificationInfo = [notification userInfo];
    NSString *foorseeId = notificationInfo[@"foorseeId"];
    [self presentMediaProfileForItemWithFoorseeId:foorseeId];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) presentMediaProfileForItemWithFoorseeId:(NSString *) foorseeId
{
    MediaProfileViewController *newMediaProfileView = [[MediaProfileViewController alloc]init];
    newMediaProfileView.view.frame = self.view.frame;
    newMediaProfileView.view.backgroundColor = [UIColor whiteColor];
    newMediaProfileView.delegate = self;
    
    [self pushViewController:newMediaProfileView animated:NO];
    
    [_foorseeSessionManager GET:[NSString stringWithFormat:@"movies/id/%@.json",foorseeId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [newMediaProfileView setData:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

-(void) presentPersonProfileForItemWithFoorseeId:(NSString *) foorseeId
{

}

-(void) backButtonTappedInMediaProfileView
{
    [self popViewControllerAnimated:NO];
}




@end
