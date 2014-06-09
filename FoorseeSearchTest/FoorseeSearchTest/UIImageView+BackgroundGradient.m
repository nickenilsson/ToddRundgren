//
//  UIImageView+BackgroundGradient.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 05/06/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "UIImageView+BackgroundGradient.h"
#import "UIColor+ColorFromHex.h"

@implementation UIImageView (BackgroundGradient)

-(void) addGradientWithColor:(UIColor *) color
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 1024, self.frame.size.height);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[color CGColor], nil];
    [self.layer addSublayer:gradientLayer];
    self.layer.shouldRasterize = YES;
}



@end
