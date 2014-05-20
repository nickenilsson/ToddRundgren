//
//  ImagesModuleViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 06/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#define ITEM_WIDTH_TO_HEIGHT_RELATION 2.0f

#import "ImagesModuleViewController.h"
#import "ImageCell.h"
#import "UIImage+ImageWithColor.h"
#import "UIImageView+AFNetworking.h"
#import "SnappyFlowLayout.h"
#import <JTSImageViewController.h>

static NSString * const cellIdentifier = @"cellIdentifier";

@interface ImagesModuleViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation ImagesModuleViewController{

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
    
    self.labelModuleTitle.text = @"Images";
    
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
    CGFloat itemWidth = ITEM_WIDTH_TO_HEIGHT_RELATION * itemHeight;
    _collectionViewLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    [_collectionViewLayout invalidateLayout];
    
}
-(void)setDataThumbnails:(NSMutableArray *)dataThumbnails
{
    _dataThumbnails = dataThumbnails;
    [self.collectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataThumbnails.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *cellData = self.dataThumbnails[indexPath.item];
    NSURL *imageUrl = [NSURL URLWithString:cellData[@"url"]];
    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
    [cell.imageView setImageWithURL:imageUrl placeholderImage:placeholderImage];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedItem = self.dataOriginals[indexPath.item];
    NSURL *imageUrl = [NSURL URLWithString:selectedItem[@"url"]];
    
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.imageURL = imageUrl;
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmed];

    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    imageInfo.referenceRect = cell.frame;
    imageInfo.referenceView = self.collectionView;
    

    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
