//
//  CollectionModuleViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 05/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "CollectionModuleViewController.h"

@interface CollectionModuleViewController ()

@end

@implementation CollectionModuleViewController

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
    self.labelModuleTitle.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_MODULE_TITLE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
