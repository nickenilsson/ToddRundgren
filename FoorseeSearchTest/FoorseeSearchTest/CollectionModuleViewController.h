//
//  CollectionModuleViewController.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 05/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//


#import <UIKit/UIKit.h>

static NSString * const collectionModuleNibName = @"CollectionModuleViewController";

@interface CollectionModuleViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *labelModuleTitle;

@end
