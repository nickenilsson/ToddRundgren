//
//  ActorsModuleViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 08/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "ActorsModuleViewController.h"
#import "ImageCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"
#import "SnappyFlowLayout.h"

#define ITEM_WIDTH_TO_HEIGHT_RELATIONSHIP 0.75f

static NSString * const cellIdentifier = @"cellIdentifier";

@interface ActorsModuleViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation ActorsModuleViewController{

    SnappyFlowLayout *_collectionViewLayout;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:collectionModuleNibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.labelModuleTitle.text = @"Cast";
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[ImageCell nib] forCellWithReuseIdentifier:cellIdentifier];
    _collectionViewLayout = [[SnappyFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = _collectionViewLayout;
}
-(void)viewDidLayoutSubviews
{
    [self setUpCollectionViewLayout];
}

-(void) setUpCollectionViewLayout
{
    _collectionViewLayout.minimumInteritemSpacing = 0;
    _collectionViewLayout.minimumLineSpacing = 5;
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    CGFloat availableHeight = self.collectionView.frame.size.height - _collectionViewLayout.sectionInset.bottom - _collectionViewLayout.sectionInset.top;
    CGFloat itemHeight = availableHeight;
    CGFloat itemWidth = ITEM_WIDTH_TO_HEIGHT_RELATIONSHIP * itemHeight;
    _collectionViewLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    [_collectionViewLayout invalidateLayout];
}


-(void)setData:(NSMutableArray *)data
{
    _data = data;
    [self.collectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *cellData = self.data[indexPath.item];
    
    NSURL *imageUrl = [NSURL URLWithString:cellData[@"images"][@"thumbnails"][0][@"url"]];
    if (imageUrl) {
        UIImage *placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
        [cell.imageView setImageWithURL:imageUrl placeholderImage:placeholderImage];
    }
    else{
        cell.backgroundColor = [UIColor grayColor];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
