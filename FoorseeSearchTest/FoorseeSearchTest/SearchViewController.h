//
//  SearchViewController.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 15/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentViewControllerDelegate;

@interface SearchViewController : UIViewController

@property (weak, nonatomic) id<ContentViewControllerDelegate> delegate;

@end
