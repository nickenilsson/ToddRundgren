//
//  DiscoverViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 30/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "DiscoverViewController.h"
#import "FoorseeHTTPClient.h"
#import "ContentViewControllerDelegate.h"
#import "ImageCell.h"
#import "WebViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"
#import "ContentViewControllerDelegate.h"


#define NUMBER_OF_THUMBNAILS_IN_WIDTH_PORTRAIT 2
#define NUMBER_OF_THUMBNAILS_IN_WIDTH_LANDSCAPE 4
#define NUMBER_OF_BANNERS_IN_WIDTH_PORTRAIT 1
#define NUMBER_OF_BANNERS_IN_WIDTH_LANDSCAPE 2
#define BANNER_HEIGHT_TO_WIDTH_CONSTANT 0.6f
#define THUMBNAIL_HEIGHT_TO_WIDTH_CONSTANT 1.4f

static NSString * const imageCellIdentifier = @"imageCellIdentifier";
static NSString * const headerViewIdentifier = @"headerViewIdentifier";
static NSString * const webViewCellIdentifier = @"webViewCellIdentifier";

typedef enum : NSUInteger {
    THUMBNAIL,
    BANNER
} discoverItemType;

@interface DiscoverViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DiscoverViewController{
    
    FoorseeHTTPClient *_foorseeSessionManager;
    NSMutableArray *_layoutItems;
    NSMutableArray *_thumbnailItems;
    NSMutableArray *_bannerItems;
    NSURL *_urlBackgroundImage;
    UICollectionViewFlowLayout *_collectionViewLayout;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

    _collectionViewLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _collectionViewLayout.minimumInteritemSpacing = 5;
    _collectionViewLayout.minimumLineSpacing = 5;


    [self.collectionView registerNib:[ImageCell nib] forCellWithReuseIdentifier:imageCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    [self.collectionView registerNib:[WebViewCell nib] forCellWithReuseIdentifier:webViewCellIdentifier];
    
    
    _foorseeSessionManager = [FoorseeHTTPClient sharedForeseeHTTPClient];
    [_foorseeSessionManager GET:@"discover.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self refineAndSaveDataFromResponse:responseObject];
        [self sortLayoutItems];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];
}

-(void) refineAndSaveDataFromResponse:(id)responseObject
{
    _layoutItems = [NSMutableArray arrayWithCapacity:30];
    for (id key in responseObject[@"layout"][@"blocks"]) {
        NSDictionary *block = responseObject[@"layout"][@"blocks"][key];
        for (NSDictionary *layoutItem in block[@"children"]) {
            [_layoutItems addObject:layoutItem];
        }
    }
    _thumbnailItems = responseObject[@"content"][@"FEATURED_MOVIE"][@"items"];
    _bannerItems = responseObject[@"content"][@"BANNER"][@"items"];
    NSString *urlBackgroundString = responseObject[@"layout"][@"backgroundImage"][@"url"];
    _urlBackgroundImage = [NSURL URLWithString:urlBackgroundString];

}

-(void) sortLayoutItems
{
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:_layoutItems.count];
    int currentSmallestListIndex = 0;
    
    for (int i = 0; i<=_layoutItems.count; i++) {
        for (NSDictionary *item in _layoutItems) {
            NSNumber *contentListIndex = item[@"contentListIndex"];
            if (contentListIndex.intValue <= currentSmallestListIndex && ![sortedArray containsObject:item]) {
                [sortedArray addObject:item];
                currentSmallestListIndex = contentListIndex.integerValue+1;
            }
        }
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _layoutItems.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
    header.backgroundColor = [UIColor clearColor];
    
    return header;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat headerWidth = self.collectionView.bounds.size.width - _collectionViewLayout.sectionInset.left - _collectionViewLayout.sectionInset.right;
    CGFloat headerHeight;
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        headerHeight = 400;
    }else{
        headerHeight = 200;
    }
    return CGSizeMake(headerWidth, headerHeight);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *layoutItem = _layoutItems[indexPath.item];
    NSNumber *contentListIndex = layoutItem[@"contentListIndex"];
    
    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
    if ([self typeOfItemAtIndexPath:indexPath] == THUMBNAIL) {
        ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
       
        NSDictionary *thumbnailItem = _thumbnailItems[contentListIndex.integerValue];
        NSURL *imageUrl = [NSURL URLWithString:thumbnailItem[@"posterThumbnail"][@"url"]];
        [cell.image setImageWithURL:imageUrl placeholderImage:placeholderImage];
        
        return cell;
        
    }
    else if ([self typeOfItemAtIndexPath:indexPath] == BANNER){
        ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
        cell.image.image = nil;
        cell.backgroundColor = [UIColor blueColor];
        
        return cell;
    }
    NSLog(@"Error: unknown cell type");
    return nil;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeOfCollectionView = self.collectionView.bounds.size;
    CGFloat horizontalInsets = _collectionViewLayout.sectionInset.left + _collectionViewLayout.sectionInset.right;
    CGFloat availableWidth = sizeOfCollectionView.width - horizontalInsets;
    
    CGFloat itemWidth = 0;
    CGFloat itemHeight = 0;
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    NSInteger numberOfThumbnailsInWidth;
    NSInteger numberOfBannersWidth;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight) {
        numberOfThumbnailsInWidth = NUMBER_OF_THUMBNAILS_IN_WIDTH_LANDSCAPE;
        numberOfBannersWidth = NUMBER_OF_BANNERS_IN_WIDTH_LANDSCAPE;
    }
    else {
        numberOfThumbnailsInWidth = NUMBER_OF_THUMBNAILS_IN_WIDTH_PORTRAIT;
        numberOfBannersWidth = NUMBER_OF_BANNERS_IN_WIDTH_PORTRAIT;
    }
    
    if ([self typeOfItemAtIndexPath:indexPath] == THUMBNAIL) {
        CGFloat totalItemSpacing = floorf(((numberOfThumbnailsInWidth -1) * _collectionViewLayout.minimumInteritemSpacing));
        CGFloat availableWidthWithSpacing = floorf(availableWidth - totalItemSpacing);
        itemWidth = floorf(availableWidthWithSpacing / numberOfThumbnailsInWidth);
        itemHeight = itemWidth * THUMBNAIL_HEIGHT_TO_WIDTH_CONSTANT;
    }
    else if ([self typeOfItemAtIndexPath:indexPath] == BANNER){
        itemWidth = floorf((availableWidth - ((numberOfBannersWidth - 1) * _collectionViewLayout.minimumInteritemSpacing)) /numberOfBannersWidth);
        itemHeight = itemWidth * BANNER_HEIGHT_TO_WIDTH_CONSTANT;
    }
    
    return CGSizeMake(itemWidth, itemHeight);
}

-(discoverItemType) typeOfItemAtIndexPath:(NSIndexPath *) indexPath
{
    NSDictionary *layoutItem = _layoutItems[indexPath.item];
    NSString *typeString = layoutItem[@"type"];
    discoverItemType itemType;
    if ([typeString isEqualToString:@"FEATURED_MOVIE"]) {
        itemType = THUMBNAIL;
    }
    else if ([typeString isEqualToString:@"BANNER"]){
        itemType = BANNER;
    }

    return itemType;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *layoutItem = _layoutItems[indexPath.item];
    NSNumber *contentListIndex = layoutItem[@"contentListIndex"];
    NSDictionary *clickedItem;
    NSString *foorseeId;
    if ([self typeOfItemAtIndexPath:indexPath] == THUMBNAIL) {
        clickedItem = _thumbnailItems[contentListIndex.integerValue];
        foorseeId = clickedItem[@"id"];
    }else{
        clickedItem = _bannerItems[contentListIndex.integerValue];
        foorseeId = clickedItem[@"target"][@"id"];
    }
    
    [self.delegate itemSelectedWithFoorseeIdNumber:foorseeId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_collectionViewLayout invalidateLayout];
}


@end
