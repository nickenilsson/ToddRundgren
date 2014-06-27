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
    CGFloat itemWidth = RELATION_WIDTH_TO_HEIGHT_POSTERS * itemHeight;
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
    
    NSURL *imageUrl = [NSURL URLWithString:cellData[@"portraitThumbnail"][@"url"]];
    if (imageUrl) {
        UIImage *placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
        [cell.imageView setImageWithURL:imageUrl placeholderImage:placeholderImage];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"default_portrait.png"];
    }
    cell.textView.hidden = NO;
    cell.textView.textAlignment = NSTextAlignmentCenter;
    cell.textView.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_DESCRIPTION_TEXT];
    cell.textView.text = cellData[@"name"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedItem = self.data[indexPath.item];
    NSString *foorseeId = selectedItem[@"id"];
    NSDictionary *userInfo = @{@"foorseeId": foorseeId};
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"foorseePersonSelected"
                                      object:nil
                                    userInfo:userInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
