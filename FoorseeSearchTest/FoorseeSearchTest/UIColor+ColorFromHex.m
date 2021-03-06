//
//  UIColor+ColorFromHex.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 16/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "UIColor+ColorFromHex.h"

@implementation UIColor (ColorFromHex)

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

@end
