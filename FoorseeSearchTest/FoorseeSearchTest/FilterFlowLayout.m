//
//  FilterFlowLayout.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 22/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "FilterFlowLayout.h"

@implementation FilterFlowLayout


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *cellLayoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self applyTouchTranslationToCellLayoutAttributes:cellLayoutAttributes];
    return cellLayoutAttributes;
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *allLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *cellLayoutAttributes in allLayoutAttributes) {
        [self applyTouchTranslationToCellLayoutAttributes:cellLayoutAttributes];
    }
    return allLayoutAttributes;
}


-(void) applyTouchTranslationToCellLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{

    
    if ([layoutAttributes.indexPath isEqual:self.touchedCellIndexPath]) {
        NSLog(@"indexpath : %@", layoutAttributes.indexPath);
        layoutAttributes.center = self.touchedCellCenter;
        layoutAttributes.zIndex = 1;
    }
}
-(void) setTouchedCellCenter:(CGPoint)touchedCellCenter
{
    _touchedCellCenter = touchedCellCenter;
    [self invalidateLayout];
}




@end
