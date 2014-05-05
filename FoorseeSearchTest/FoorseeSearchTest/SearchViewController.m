//
//  SearchViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 15/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "SearchViewController.h"
#import "FoorseeHTTPClient.h"
#import "ArrayDataSource.h"
#import "ImageCell.h"
#import "FilterCell.h"
#import "FilterSectionHeader.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"
#import "UIColor+ColorFromHex.h"
#import "FilterFlowLayout.h"
#import "MediaProfileNavigationController.h"
#import "ContentViewControllerDelegate.h"

#define NAVIGATION_CONTROLLER_WIDTH_FRACTION 0.8f
#define DURATION_NAVIGATION_CONTROLLER_SLIDE_IN 0.3f
#define NUMBER_OF_RESULT_ITEMS_ACROSS_PORTRAIT 2
#define NUMBER_OF_RESULT_ITEMS_ACROSS_LANDSCAPE 3

static NSString * const imageCellIdentifier = @"imageCellIdentifier";
static NSString * const filterCellIdentifier = @"filterCellIdentifier";
static NSString * const filterSectionHeaderIdentifier = @"sectionFilterHeaderIdentifier";

@interface SearchViewController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *resultsCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation SearchViewController{
    FoorseeHTTPClient *_foorseeSessionManager;
    ArrayDataSource *_resultsDataSource;
    NSMutableArray *_filters;
    NSMutableDictionary *_activeSearchParameters;
    BOOL _filterIsBeingTouched;
    UIPanGestureRecognizer *_panGestureRecognizer;
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
    MediaProfileNavigationController *_mediaProfileNavigationController;
    NSLayoutConstraint *_MediaProfileLeadingConstraint;
    UITapGestureRecognizer *_tapToCloseContentProfile;
    UICollectionViewFlowLayout *_collectionViewLayoutResults;
    UICollectionViewFlowLayout *_collectionViewLayoutFilters;

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
    self.searchBar.delegate = self;
        
    _foorseeSessionManager = [FoorseeHTTPClient sharedForeseeHTTPClient];
    [self updateSearchRequest];
    
    [self.resultsCollectionView registerNib:[ImageCell nib] forCellWithReuseIdentifier:imageCellIdentifier];
    CellConfigureBlock imageCellConfigurationBlock = ^(ImageCell *cell, NSDictionary *movie){
        
        UIImage *placeHolderImage = [UIImage imageWithColor:[UIColor blackColor]];
        NSURL *imageUrl = [NSURL URLWithString:movie[@"posterThumbnail"][@"url"]];
        [cell.image setImageWithURL:imageUrl placeholderImage:placeHolderImage];
    };
    
    _resultsDataSource = [[ArrayDataSource alloc] initWithItems:nil cellIdentifier:imageCellIdentifier configureCellBlock: imageCellConfigurationBlock];
    self.resultsCollectionView.dataSource = _resultsDataSource;
    self.resultsCollectionView.delegate = self;

    _collectionViewLayoutResults = (UICollectionViewFlowLayout *)self.resultsCollectionView.collectionViewLayout;
    _collectionViewLayoutResults.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _collectionViewLayoutResults.minimumInteritemSpacing = 5;
    _collectionViewLayoutResults.minimumLineSpacing = 5;
    
    
    [self.filterCollectionView registerNib:[FilterCell nib] forCellWithReuseIdentifier:filterCellIdentifier];
    [self.filterCollectionView registerNib:[FilterSectionHeader nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:filterSectionHeaderIdentifier];
    self.filterCollectionView.dataSource = self;
    self.filterCollectionView.delegate = self;
    _collectionViewLayoutFilters = (UICollectionViewFlowLayout *) self.filterCollectionView.collectionViewLayout;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _filters.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *terms =_filters[section][@"terms"];
    return terms.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.filterCollectionView]) {
        return _collectionViewLayoutFilters.itemSize;
    }
    
    CGFloat availableWidth = self.resultsCollectionView.bounds.size.width - _collectionViewLayoutResults.sectionInset.left - _collectionViewLayoutResults.sectionInset.right;
    
    NSInteger numberOfItemsAcross;
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        numberOfItemsAcross = NUMBER_OF_RESULT_ITEMS_ACROSS_LANDSCAPE;
    }else{
        numberOfItemsAcross = NUMBER_OF_RESULT_ITEMS_ACROSS_PORTRAIT;
    }

    CGFloat availableWidthExcludingSpacing = availableWidth - ((numberOfItemsAcross - 1) * _collectionViewLayoutResults.minimumInteritemSpacing);
    
    CGFloat itemWidth = floor(availableWidthExcludingSpacing / numberOfItemsAcross);
    CGFloat itemHeight = itemWidth * 1.35f;
    
    return CGSizeMake(itemWidth, itemHeight);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FilterCell *cell = [self.filterCollectionView dequeueReusableCellWithReuseIdentifier:filterCellIdentifier forIndexPath:indexPath];
    NSDictionary *filter = _filters[indexPath.section][@"terms"][indexPath.item];
    
    NSString *colorHex = _filters[indexPath.section][@"colorCode"];
    UIColor *filterColor = [UIColor colorFromHexString:colorHex];
    cell.backgroundColor = filterColor;
    
    if (filter[@"isActive"] == [NSNumber numberWithBool:YES]) {
        cell.backgroundColor = [UIColor blueColor];
    }
    
    cell.label.text = [NSString stringWithFormat:@"%@", filter[@"term"]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_filterCollectionView]) {
        NSMutableDictionary *filter = _filters[indexPath.section][@"terms"][indexPath.item];
        if (filter[@"isActive"] == [NSNumber numberWithBool:NO]) {
            [filter setObject:[NSNumber numberWithBool:YES] forKey:@"isActive"];
        }else{
            [filter setObject:[NSNumber numberWithBool:NO] forKey:@"isActive"];
        }
        [self.filterCollectionView reloadData];
        [self updateSearchRequest];
    }else if ([collectionView isEqual:_resultsCollectionView]){
        NSString *foorseeId = _resultsDataSource.items[indexPath.item][@"id"];
        [self.delegate itemSelectedWithFoorseeIdNumber:foorseeId];
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FilterSectionHeader *sectionHeader = [self.filterCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:filterSectionHeaderIdentifier forIndexPath:indexPath];
    
    NSString *filterSectionName = _filters[indexPath.section][@"name"];
    sectionHeader.label.text = filterSectionName;
    
    return sectionHeader;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self updateSearchRequest];
}

-(void) updateSearchRequest
{
    NSString *query = self.searchBar.text;
    NSMutableString *tags = [NSMutableString stringWithString:@""];
    
    BOOL activeFiltersExists = NO;
    for (NSMutableDictionary *filterSection in _filters) {
        NSString *filterType = filterSection[@"name"];
        [tags appendString:filterType];
        [tags appendString:@":"];
        NSArray *filters = filterSection[@"terms"];
        for (NSMutableDictionary *filter in filters) {
            if (filter[@"isActive"] == [NSNumber numberWithBool:YES]) {
                activeFiltersExists = YES;
                NSString *filterTerm = [NSString stringWithFormat:@"%@", filter[@"term"]];
                NSMutableString *urlFriendlyTerm = [NSMutableString stringWithString:[filterTerm lowercaseString]];
                urlFriendlyTerm = [NSMutableString stringWithString:[urlFriendlyTerm stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
                
                [tags appendString:[NSString stringWithFormat:@"%@",urlFriendlyTerm]];

                [tags appendString:@","];
            }
        }
        [tags appendString:@"|"];
    }
    
    if ([tags length] > 0) {
        tags =  [NSMutableString stringWithString:[tags substringToIndex:[tags length] - 1]];
    }
    if (!activeFiltersExists) {
        [tags setString:@""];
    }
    NSDictionary *parameters = @{@"q": query, @"tags":tags};
    [_foorseeSessionManager GET:@"search/default.json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        _resultsDataSource.items = responseObject[@"result"][@"movies"];
        
        _filters = responseObject[@"availableToQuery"][@"tags"];
        
        [self.filterCollectionView reloadData];
        [self.resultsCollectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_collectionViewLayoutResults invalidateLayout];
}

@end
