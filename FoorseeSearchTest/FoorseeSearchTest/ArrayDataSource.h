//
//  ArrayDataSource.h
//  rootVCWithTopBar
//
//  Created by Tomas Nilsson on 9/11/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CellConfigureBlock)(id cell, id item);

@interface ArrayDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

- (id)initWithItems:(NSMutableArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(CellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSMutableArray *items;

@end