//
//  VideoModuleViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 07/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "VideoModuleViewController.h"
#import "VideoThumbnailCell.h"
#import "UIImage+ImageWithColor.h"
#import "UIImageView+AFNetworking.h"
#import "SnappyFlowLayout.h"

#define WIDTH_TO_HEIGHT_RELATION 2.0f

static NSString * const cellIdentifier = @"cellIdentifier";

@interface VideoModuleViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation VideoModuleViewController{

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
    
    self.labelModuleTitle.text = @"Related videos";
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[VideoThumbnailCell nib] forCellWithReuseIdentifier:cellIdentifier];
    _collectionViewLayout = [[SnappyFlowLayout alloc]init];
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
    CGFloat itemWidth = WIDTH_TO_HEIGHT_RELATION * itemHeight;
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
    VideoThumbnailCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *cellData = self.data[indexPath.item];
    NSURL *imageUrl = [NSURL URLWithString:cellData[@"images"][@"thumbnails"][0][@"url"]];
    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
    [cell.ImageView setImageWithURL:imageUrl placeholderImage:placeholderImage];
    cell.labelTitle.text = cellData[@"title"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedItem = self.data[indexPath.item];
    NSString *youtubeVideoId = selectedItem[@"externalId"];
    
    NSDictionary *userInfo = @{@"youtubeVideoId": youtubeVideoId};
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"videoSelected"
                                      object:nil
                                    userInfo:userInfo];
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
