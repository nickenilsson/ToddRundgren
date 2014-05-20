//
//  ImageViewWithGradient.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 08/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "ImageViewWithGradient.h"
#import "UIColor+ColorFromHex.h"

@implementation ImageViewWithGradient{

    CAGradientLayer *_gradientLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setUpGradient];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //[self setUpGradient];
    }
    return self;
}
-(void)setGradientColor:(UIColor *)gradientColor
{
    _gradientColor = gradientColor;
    [self setUpGradient];
}
-(void) setUpGradient
{
    if (!_gradientColor) {
        _gradientColor = [UIColor whiteColor];
    }
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = CGRectMake(0, 0, 1024, self.frame.size.height);
    _gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[_gradientColor CGColor], nil];
    [self.layer addSublayer:_gradientLayer];
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
