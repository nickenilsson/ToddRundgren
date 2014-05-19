//
//  SearchView2Controller.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 13/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentViewControllerDelegate;

@interface MainViewController : UIViewController

@property (weak, nonatomic) id <ContentViewControllerDelegate> delegate;

@end
