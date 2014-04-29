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

@interface MediaProfileNavigationController () <MediaProfileDelegate, ForeseeHTTPClientDelegate>

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
    _foorseeSessionManager.delegate = self;
    self.navigationBarHidden = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) itemSelectedInProfileViewWithFoorseeId:(NSString *) foorseeId
{
    [self presentMediaProfileForItemWithFoorseeId:foorseeId];
}

- (void) presentMediaProfileForItemWithFoorseeId:(NSString *) foorseeId
{
    MediaProfileViewController *newMediaProfileView = [[MediaProfileViewController alloc]init];
    newMediaProfileView.view.frame = self.view.frame;
    newMediaProfileView.view.backgroundColor = [UIColor whiteColor];
    newMediaProfileView.delegate = self;
    
    [self pushViewController:newMediaProfileView animated:YES];
    
    [_foorseeSessionManager GET:[NSString stringWithFormat:@"movies/id/%@.json",foorseeId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [newMediaProfileView setData:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

-(void) backButtonTappedInMediaProfileView
{
    [self popViewControllerAnimated:YES];
}




@end
