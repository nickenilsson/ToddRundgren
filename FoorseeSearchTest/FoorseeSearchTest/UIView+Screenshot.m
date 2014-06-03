//
//  UIView+Screenshot.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 30/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
