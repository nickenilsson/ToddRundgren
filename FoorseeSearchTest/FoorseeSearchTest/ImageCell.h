//
//  ImageCell.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 14/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UICollectionViewCell

+(UINib *) nib;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
