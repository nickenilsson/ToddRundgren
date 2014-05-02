//
//  WebViewCell.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 02/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "WebViewCell.h"

@implementation WebViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpView];
    }
    return self;

}

-(void) setUpView
{
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.scrollEnabled = NO;

}
+(UINib *) nib
{
    return [UINib nibWithNibName:@"WebViewCell" bundle:nil];
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
