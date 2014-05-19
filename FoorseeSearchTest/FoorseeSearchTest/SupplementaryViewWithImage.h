//
//  SupplementaryViewWithImage.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 14/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupplementaryViewWithImage : UICollectionReusableView


+(UINib *) nib;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end
