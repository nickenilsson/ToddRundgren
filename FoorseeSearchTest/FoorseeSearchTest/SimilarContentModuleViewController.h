//
//  SimilarContentModuleViewController.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 06/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "CollectionModuleViewController.h"

@protocol ContentViewControllerDelegate;

@interface SimilarContentModuleViewController : CollectionModuleViewController

@property (strong, nonatomic) NSMutableArray *data;

@end
