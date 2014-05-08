//
//  ImageViewWithGradient.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 08/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "ImageViewWithGradient.h"

@implementation ImageViewWithGradient{

    CAGradientLayer *_gradientLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpGradient];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpGradient];
    }
    return self;
}

-(void) setUpGradient
{
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.layer addSublayer:_gradientLayer];
}

-(void)layoutSubviews
{
    _gradientLayer.frame = self.bounds;
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
