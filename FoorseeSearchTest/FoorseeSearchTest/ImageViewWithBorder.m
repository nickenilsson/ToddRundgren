//
//  ImageViewWithBorder.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 16/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "ImageViewWithBorder.h"
#import "UIColor+ColorFromHex.h"

@implementation ImageViewWithBorder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpBorder];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpBorder];
    }
    return self;
}
-(void) setUpBorder
{
    self.layer.borderColor = [[UIColor colorFromHexString:COLOR_BORDER_IMAGES]CGColor];
    self.layer.borderWidth = WIDTH_BORDER_IMAGES;
    self.layer.shouldRasterize = YES;
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
