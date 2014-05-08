//
//  VideoThumbnailCell.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 07/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoThumbnailCell : UICollectionViewCell

+(UINib *) nib;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
