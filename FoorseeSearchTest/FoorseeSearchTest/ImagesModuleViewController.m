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
#import "ASMediaFocusManager.h"


static NSString * const cellIdentifier = @"cellIdentifier";

@interface ImagesModuleViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ASMediasFocusDelegate>

@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;


@property (nonatomic, assign) BOOL statusBarHidden;


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
    
    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.animationDuration = 0.5;
    self.mediaFocusManager.delegate = (id)self;


    
    
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

-(void)setDataOriginals:(NSMutableArray *)dataOriginals
{
    _dataOriginals = dataOriginals;
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
    
    NSDictionary *cellData = self.dataOriginals[indexPath.item];
    NSURL *imageUrl = [NSURL URLWithString:cellData[@"url"]];
    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
    [cell.imageView setImageWithURL:imageUrl placeholderImage:placeholderImage];
    cell.imageView.tag = indexPath.item;
    [self.mediaFocusManager installOnView:cell.imageView];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
}

#pragma mark - ASMediaFocusDelegate
-(CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
{
    return CGRectZero;
}
-(UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
{
    return nil;
}

- (UIImageView *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageViewForView:(UIView *)view
{
    return (UIImageView *)view;
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameForView:(UIView *)view
{
   return [[[UIApplication sharedApplication]delegate] window].rootViewController.view.bounds;
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return [[[UIApplication sharedApplication]delegate] window].rootViewController;
}

- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view
{
    NSDictionary *selectedImage = self.dataOriginals[view.tag];
    NSURL *imageUrl = [NSURL URLWithString:selectedImage[@"url"]];
    return imageUrl;
}

- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view;
{
    return nil;
}

- (void)mediaFocusManagerWillAppear:(ASMediaFocusManager *)mediaFocusManager
{
    self.statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)mediaFocusManagerWillDisappear:(ASMediaFocusManager *)mediaFocusManager
{
    self.statusBarHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
    return self.prefersStatusBarHidden;
}


- (void)mediaFocusManagerDidDisappear:(ASMediaFocusManager *)mediaFocusManager
{
    NSLog(@"The view has been dismissed");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
