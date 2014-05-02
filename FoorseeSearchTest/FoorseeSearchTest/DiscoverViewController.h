//
//  DiscoverViewController.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 30/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentViewControllerDelegate;

@interface DiscoverViewController : UIViewController

@property (weak, nonatomic) id <ContentViewControllerDelegate> delegate;

@end
