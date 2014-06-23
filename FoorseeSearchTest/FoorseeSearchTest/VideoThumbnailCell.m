//
//  VideoThumbnailCell.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 07/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "VideoThumbnailCell.h"
#import "UIImage+ImageWithColor.h"

@interface VideoThumbnailCell()

@property (strong, nonatomic) UIImageView *selectedOverlay;

@end

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
-(void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.selectedOverlay = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]]];
        self.selectedOverlay.frame = self.contentView.frame;
        [self.contentView addSubview:_selectedOverlay];
    }else{
        [self.selectedOverlay removeFromSuperview];
        self.selectedOverlay = nil;
    }
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
