//
//  HeaderModuleViewController.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 29/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieItemHeaderModuleViewController : UIViewController


@property (strong, nonatomic) id data;
@property (strong, nonatomic) NSURL *urlPoster;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSNumber *rating;

@end
