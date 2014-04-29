//
//  FilterFlowLayout.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 22/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterFlowLayout : UICollectionViewFlowLayout

@property (strong, nonatomic) NSIndexPath *touchedCellIndexPath;
@property (nonatomic) CGPoint touchedCellCenter;

@end
