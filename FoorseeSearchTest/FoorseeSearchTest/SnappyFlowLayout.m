//
//  SnappyFlowLayout.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 06/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "SnappyFlowLayout.h"

@implementation SnappyFlowLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    CGFloat offsetAdjustment = MAXFLOAT;
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemOrigin = layoutAttributes.frame.origin.x;
        
        if (ABS(itemOrigin - proposedContentOffset.x) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemOrigin - proposedContentOffset.x;
        }
    }
    CGPoint newOffset;
    if(proposedContentOffset.x >= self.collectionViewContentSize.width - self.collectionView.bounds.size.width){
        newOffset = proposedContentOffset;
    }else{
        CGFloat insetLeft = self.sectionInset.left;
        newOffset = CGPointMake(proposedContentOffset.x + offsetAdjustment - insetLeft, proposedContentOffset.y);
    }
    return newOffset;
}


@end
