//
//  FilterCell.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 15/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UICollectionViewCell

+(UINib *)nib;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end
