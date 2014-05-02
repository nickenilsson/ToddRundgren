//
//  DiscoverViewHeader.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 02/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "DiscoverViewHeader.h"

@interface DiscoverViewHeader ()



@end

@implementation DiscoverViewHeader

-(id)init
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
        
    }
    
    return self;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
    }
    return self;
}

-(void) setUpGradientView
{
    
}

+(UINib *) nib
{
    return [UINib nibWithNibName:@"DiscoverViewHeader" bundle:nil];
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
