//
//  FilterCell.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 15/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "FilterCell.h"


@implementation FilterCell

-(id)init
{
    self = [super init];
    if (self) {
        [self setUpCell];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self setUpCell];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCell];
    }
    return self;
}
-(void) setUpCell
{
    self.layer.cornerRadius = RADIUS_BORDER_FILTER_CELL;
    self.label.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_FILTER_CELLS];
    
}
+ (UINib *) nib
{
    return [UINib nibWithNibName:@"FilterCell" bundle:nil];
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
