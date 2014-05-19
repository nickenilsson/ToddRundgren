//
//  SupplementaryViewWithImage.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 14/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "SupplementaryViewWithImage.h"

@implementation SupplementaryViewWithImage

+(UINib *) nib
{
    return [UINib nibWithNibName:@"SupplementaryViewWithImage" bundle:nil];
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
