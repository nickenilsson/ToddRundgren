//
//  FilterSectionHeader.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 16/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "FilterSectionHeader.h"

@implementation FilterSectionHeader

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
    self.label.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_FILTER_SECTION_HEADERS];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (UINib *) nib
{
    return [UINib nibWithNibName:@"FilterSectionHeader" bundle:nil];
}

@end
