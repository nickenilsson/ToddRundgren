//
//  ImageCell.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 14/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "ImageCell.h"
#import "UIColor+ColorFromHex.h"
#import "UIImage+ImageWithColor.h"


@implementation ImageCell{
    UIImageView *_selectedOverlay;
}

+(UINib *) nib
{
    return [UINib nibWithNibName:@"ImageCell" bundle:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        _selectedOverlay = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]]];
        _selectedOverlay.frame = self.contentView.frame;
        [self.contentView addSubview:_selectedOverlay];
    }else{
        [_selectedOverlay removeFromSuperview];
        _selectedOverlay = nil;
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
