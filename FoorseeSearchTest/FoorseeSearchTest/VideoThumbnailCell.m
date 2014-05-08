//
//  VideoThumbnailCell.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 07/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "VideoThumbnailCell.h"

@implementation VideoThumbnailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (UINib *) nib
{
    return [UINib nibWithNibName:@"VideoThumbnailCell" bundle:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
