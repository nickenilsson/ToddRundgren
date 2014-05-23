//
//  ProvidersModuleViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 05/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#define ITEM_WIDTH 250
#define ITEM_HEIGHT 70

#import "ProvidersModuleViewController.h"
#import "ImageCell.h"
#import "UIImage+ImageWithColor.h"
#import "UIImageView+AFNetworking.h"
#import "SnappyFlowLayout.h"

static NSString * const imageCellIdentifier = @"imageCellIdentifier";

@interface ProvidersModuleViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation ProvidersModuleViewController{
    
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
    
    self.labelModuleTitle.text = @"Providers";
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[ImageCell nib] forCellWithReuseIdentifier:imageCellIdentifier];
    _collectionViewLayout = [[SnappyFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = _collectionViewLayout;

    
}
-(void)viewDidLayoutSubviews
{
    
    [self setUpCollectionViewLayout];
}

-(void)setData:(NSMutableArray *)data
{
    _data = data;
    [self.collectionView reloadData];
    [self setUpCollectionViewLayout];
}
-(void) setUpCollectionViewLayout
{
    _collectionViewLayout.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
    CGFloat verticalInsetHeight = (self.collectionView.frame.size.height / 2)-_collectionViewLayout.itemSize.height;
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(verticalInsetHeight, 5, verticalInsetHeight, 5);
    _collectionViewLayout.minimumLineSpacing = 5;
    [_collectionViewLayout invalidateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
    NSDictionary *cellData = self.data[indexPath.item];
    NSURL *iconUrl = [NSURL URLWithString:cellData[@"provider"][@"iconUrl"]];
    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor blueColor]];
    [cell.imageView setImageWithURL:iconUrl placeholderImage:placeholderImage];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedItem = self.data[indexPath.item];
    NSURL *externalUrl = [NSURL URLWithString:selectedItem[@"externalUrl"]];
    [[UIApplication sharedApplication] openURL:externalUrl];
}


@end
