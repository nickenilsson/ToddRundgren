//
//  ImageCell.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 14/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "ImageCell.h"


@implementation ImageCell

+(UINib *) nib
{
    return [UINib nibWithNibName:@"ImageCell" bundle:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
