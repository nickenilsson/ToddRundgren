//
//  SearchView2Controller.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 13/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "MainViewController.h"
#import "ImageCell.h"
#import "FilterCell.h"
#import "SupplementaryViewWithImage.h"
#import "SearchBarSectionHeader.h"
#import "FilterSectionHeader.h"
#import "FoorseeHTTPClient.h"
#import "ContentViewControllerDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"
#import "UIColor+ColorFromHex.h"
#import "ImageViewWithGradient.h"

#import "CSStickyHeaderFlowLayout.h"


#define DURATION_ANIMATION_FILTERS_OPEN_CLOSE 0.2f
#define HEIGHT_FILTER_ITEM 50
#define WIDTH_FILTER_ITEM 250
#define PARALLAX_MARGIN 50
#define PARALLAX_HEADER_REFERENCE_HEIGHT 250

#define NUMBER_OF_THUMBNAILS_IN_WIDTH_LANDSCAPE 4
#define NUMBER_OF_BANNERS_IN_WIDTH_PORTRAIT 1
#define NUMBER_OF_BANNERS_IN_WIDTH_LANDSCAPE 2
#define BANNER_HEIGHT_TO_WIDTH_CONSTANT 0.6f
#define THUMBNAIL_HEIGHT_TO_WIDTH_CONSTANT 1.4f
#define HEIGHT_SEARCH_BAR_HEADER 80
#define PARALLAX_SPEED_FRACTION 0.2f


typedef enum : NSUInteger {
    THUMBNAIL,
    BANNER
} discoverItemType;

static NSString * const cellIdentifierImageCell = @"cellIdentifierImageCell";
static NSString * const cellIdentifierFilterCell = @"cellIdentifierFilterCell";
static NSString * const cellIdentifierSearchBarHeader = @"cellIdentifierSearchBarHeader";
static NSString * const cellIdentifierFilterHeader = @"cellIdentifierFilterHeader";
static NSString * const cellIdentifierParallaxHeader = @"cellIdentifierParallaxHeader";

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

- (IBAction)startPageButtonTapped:(id)sender;

- (IBAction)buttonFiltersTapped:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBackgroundTop;

@property (weak, nonatomic) IBOutlet ImageViewWithGradient *imageViewBackground;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewFilters;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewResults;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFilterSectionWidth;
@property (weak, nonatomic) UISearchBar *searchBar;
@property (nonatomic) CGFloat widthOfFilterSection;
@property (weak, nonatomic) IBOutlet UIButton *buttonFilters;

@end

@implementation MainViewController{

    FoorseeHTTPClient *_foorseeSessionManager;
    NSMutableArray *_itemsDiscoverLayout;
    NSMutableArray *_itemsDiscoverThumbnails;
    NSMutableArray *_itemsDiscoverBanners;
    NSMutableArray *_itemsSearchResults;
    NSMutableArray *_itemsFilters;

    BOOL _isDisplayingDiscoverItems;
    BOOL _filterSectionIsOpen;
    CSStickyHeaderFlowLayout *_layoutForResultsCollectionView;
    UICollectionViewFlowLayout *_layoutForFiltersCollectionView;
    CGFloat _widthOfOpenedFilterSection;
    UIPanGestureRecognizer *_gestureRecognizerPanButton;

    
    BOOL _isRotating;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _filterSectionIsOpen = NO;
    self.constraintBackgroundTop.constant = - PARALLAX_MARGIN;
    
    self.imageViewBackground.image = [UIImage imageNamed:@"warner.jpg"];
    self.imageViewBackground.gradientColor = [UIColor colorFromHexString:COLOR_HEX_RESULT_SECTION];
    [self initialSetUpResultsCollectionView];
    [self initialSetUpFiltersCollectionView];
    self.constraintFilterSectionWidth.constant = 0;
    
    _foorseeSessionManager = [FoorseeHTTPClient sharedForeseeHTTPClient];
    [_foorseeSessionManager GET:@"discover.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self setUpViewToDisplayDiscoverItems:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];
    
}
-(CGFloat) widthOfFilterSection
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _widthOfFilterSection = self.view.frame.size.width/4;
    }else{
        _widthOfFilterSection = self.view.frame.size.width/3;
    }
    return _widthOfFilterSection;
}
-(void) initialSetUpResultsCollectionView
{
    self.view.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_RESULT_SECTION];
    self.collectionViewResults.dataSource = self;
    self.collectionViewResults.delegate = self;
    [self.collectionViewResults registerNib:[ImageCell nib] forCellWithReuseIdentifier:cellIdentifierImageCell];
    [self.collectionViewResults registerNib:[SearchBarSectionHeader nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifierSearchBarHeader];
    
    _layoutForResultsCollectionView = [[CSStickyHeaderFlowLayout alloc] init];
    _layoutForResultsCollectionView.parallaxHeaderReferenceSize = CGSizeMake(0, PARALLAX_HEADER_REFERENCE_HEIGHT);
    self.collectionViewResults.collectionViewLayout = _layoutForResultsCollectionView;
    [self.collectionViewResults registerNib:[SupplementaryViewWithImage nib] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:cellIdentifierParallaxHeader];
    _layoutForResultsCollectionView.sectionInset = UIEdgeInsetsMake(30, 5, 5, 5);
    _layoutForResultsCollectionView.minimumInteritemSpacing = 5;
    _layoutForResultsCollectionView.minimumLineSpacing = 5;
    [_layoutForResultsCollectionView invalidateLayout];
}

-(void) initialSetUpFiltersCollectionView
{
    self.collectionViewFilters.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_FILTER_SECTION];
    self.collectionViewFilters.dataSource = self;
    self.collectionViewFilters.delegate = self;
    [self.collectionViewFilters registerNib:[FilterCell nib] forCellWithReuseIdentifier:cellIdentifierFilterCell];
    [self.collectionViewFilters registerNib:[FilterSectionHeader nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifierFilterHeader];
    
    _layoutForFiltersCollectionView = (UICollectionViewFlowLayout *)self.collectionViewFilters.collectionViewLayout;
    _layoutForFiltersCollectionView.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    _layoutForFiltersCollectionView.minimumInteritemSpacing = 5;
    _layoutForFiltersCollectionView.minimumLineSpacing = 5;

    
}

-(void) setUpViewToDisplayDiscoverItems:(id) responseObject
{
    _isDisplayingDiscoverItems = YES;
    [self refineAndSaveDataFromResponse:responseObject];
    [self sortLayoutItems];
    [self.collectionViewResults reloadData];
    [_layoutForResultsCollectionView invalidateLayout];
}

-(void) refineAndSaveDataFromResponse:(id)responseObject
{
    _itemsDiscoverLayout = [NSMutableArray arrayWithCapacity:30];
    for (id key in responseObject[@"layout"][@"blocks"]) {
        NSDictionary *block = responseObject[@"layout"][@"blocks"][key];
        for (NSDictionary *layoutItem in block[@"children"]) {
            [_itemsDiscoverLayout addObject:layoutItem];
        }
    }
    _itemsDiscoverThumbnails = responseObject[@"content"][@"FEATURED_MOVIE"][@"items"];
    _itemsDiscoverBanners = responseObject[@"content"][@"BANNER"][@"items"];
}

-(void) sortLayoutItems
{
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:_itemsDiscoverLayout.count];
    int currentSmallestListIndex = 0;
    
    for (int i = 0; i<=_itemsDiscoverLayout.count; i++) {
        for (NSDictionary *item in _itemsDiscoverLayout) {
            NSNumber *contentListIndex = item[@"contentListIndex"];
            if (contentListIndex.intValue <= currentSmallestListIndex && ![sortedArray containsObject:item]){
                [sortedArray addObject:item];
                currentSmallestListIndex = contentListIndex.integerValue+1;
            }
        }
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([collectionView isEqual:self.collectionViewFilters]) {
        return _itemsFilters.count;
    }else{
        return 1;
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionViewFilters]) {
        NSArray *terms =_itemsFilters[section][@"terms"];
        return terms.count;
        
    }else{
        if (_isDisplayingDiscoverItems) {
            return _itemsDiscoverLayout.count;
        }else{
            return _itemsSearchResults.count;
        }
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionViewFilters]) {
        return [self filterCellForItemAtIndexPath:indexPath];
    }
    else if ([collectionView isEqual:self.collectionViewResults]){
        return [self resultCellForItemAtIndexPath:indexPath];
    }
    
    return nil;
}

-(UICollectionViewCell *) filterCellForItemAtIndexPath:(NSIndexPath *) indexPath
{
    FilterCell *cell = [self.collectionViewFilters dequeueReusableCellWithReuseIdentifier:cellIdentifierFilterCell forIndexPath:indexPath];
    
    NSDictionary *filter = _itemsFilters[indexPath.section][@"terms"][indexPath.item];
    
    NSString *colorHex = _itemsFilters[indexPath.section][@"colorCode"];
    UIColor *filterColor = [UIColor colorFromHexString:colorHex];
    cell.backgroundColor = filterColor;
    
    if (filter[@"isActive"] == [NSNumber numberWithBool:YES]) {
        cell.backgroundColor = [UIColor blueColor];
    }
    
    cell.label.text = [NSString stringWithFormat:@"%@", filter[@"term"]];
    
    return cell;
}

-(UICollectionViewCell *) resultCellForItemAtIndexPath:(NSIndexPath *) indexPath
{
    if (_isDisplayingDiscoverItems) {
        NSDictionary *layoutItem = _itemsDiscoverLayout[indexPath.item];
        NSNumber *contentListIndex = layoutItem[@"contentListIndex"];
        
        UIImage *placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
        if ([self typeOfDiscoverItemAtIndexPath:indexPath] == THUMBNAIL) {
            ImageCell *cell = [self.collectionViewResults dequeueReusableCellWithReuseIdentifier:cellIdentifierImageCell forIndexPath:indexPath];
            
            NSDictionary *thumbnailItem = _itemsDiscoverThumbnails[contentListIndex.integerValue];
            NSURL *imageUrl = [NSURL URLWithString:thumbnailItem[@"posterThumbnail"][@"url"]];
            [cell.imageView setImageWithURL:imageUrl placeholderImage:placeholderImage];
            
            return cell;
            
        }
        else if ([self typeOfDiscoverItemAtIndexPath:indexPath] == BANNER){
            ImageCell *cell = [self.collectionViewResults dequeueReusableCellWithReuseIdentifier:cellIdentifierImageCell forIndexPath:indexPath];
            cell.imageView.image = nil;
            cell.backgroundColor = [UIColor blueColor];
            
            return cell;
        }
        return nil;
    }
    else{
        ImageCell *cell = [self.collectionViewResults dequeueReusableCellWithReuseIdentifier:cellIdentifierImageCell forIndexPath:indexPath];
        NSDictionary *movie = _itemsSearchResults[indexPath.item];
        UIImage *placeHolderImage = [UIImage imageWithColor:[UIColor blackColor]];
        NSURL *imageUrl = [NSURL URLWithString:movie[@"posterThumbnail"][@"url"]];
        [cell.imageView setImageWithURL:imageUrl placeholderImage:placeHolderImage];
        
        return cell;
    }
    
}
-(discoverItemType) typeOfDiscoverItemAtIndexPath:(NSIndexPath *) indexPath
{
    NSDictionary *layoutItem = _itemsDiscoverLayout[indexPath.item];
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

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionViewResults]) {
        if (kind == UICollectionElementKindSectionHeader){
            SearchBarSectionHeader *header =[self.collectionViewResults dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifierSearchBarHeader forIndexPath:indexPath];
            
            header.searchBar.delegate = self;
            self.searchBar = header.searchBar;
            NSLog(@"self.searchbar = %@", self.searchBar);
            NSLog(@"header.searchbar = %@", header.searchBar);

            return header;
        }else{
            SupplementaryViewWithImage *header = [self.collectionViewResults dequeueReusableSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:cellIdentifierParallaxHeader forIndexPath:indexPath];
            header.imageView.image = [UIImage imageNamed:@"warner.jpg"];
            return header;
        }
       
    }else{
        FilterSectionHeader *sectionHeader = [self.collectionViewFilters dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifierFilterHeader forIndexPath:indexPath];
        
        NSString *filterSectionName = _itemsFilters[indexPath.section][@"name"];
        sectionHeader.label.text = filterSectionName;
        return sectionHeader;
    }
    
    return nil;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize itemSize;

    if ([collectionView isEqual:self.collectionViewFilters]) {
        CGFloat availableWidth = self.collectionViewFilters.bounds.size.width - _layoutForFiltersCollectionView.sectionInset.left - _layoutForFiltersCollectionView.sectionInset.right;
        return CGSizeMake(availableWidth, HEIGHT_FILTER_ITEM);
    }
    else{
        
        CGSize sizeOfCollectionView = self.collectionViewResults.bounds.size;
        CGFloat horizontalInsets = _layoutForResultsCollectionView.sectionInset.left + _layoutForResultsCollectionView.sectionInset.right;
        CGFloat availableWidth = sizeOfCollectionView.width - horizontalInsets;
        
        if (!_isDisplayingDiscoverItems || [self typeOfDiscoverItemAtIndexPath:indexPath] == THUMBNAIL) {
            CGFloat totalItemSpacing = (([self numberOfThumbnailsToDisplayInWidth] - 1) * _layoutForResultsCollectionView.minimumInteritemSpacing);
            CGFloat availableWidthWithSpacing = floor(availableWidth - totalItemSpacing);
            
            CGFloat thumbnailWidth = floor(availableWidthWithSpacing / [self numberOfThumbnailsToDisplayInWidth]);
            
            CGFloat thumbnailHeight = thumbnailWidth * THUMBNAIL_HEIGHT_TO_WIDTH_CONSTANT;
            itemSize = CGSizeMake(thumbnailWidth, thumbnailHeight);
        }
        else{
            CGFloat bannerWidth = floor((availableWidth - (([self numberOfBannersToDisplayInWidth] - 1) * _layoutForResultsCollectionView.minimumInteritemSpacing)) /[self numberOfBannersToDisplayInWidth]);
            CGFloat bannerHeight = bannerWidth * BANNER_HEIGHT_TO_WIDTH_CONSTANT;
            itemSize = CGSizeMake(bannerWidth, bannerHeight);
        }
    }
    return itemSize;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionViewResults]) {
        return CGSizeMake(collectionView.bounds.size.width, HEIGHT_SEARCH_BAR_HEADER);
    }else{
        return CGSizeMake(collectionView.bounds.size.width, 70);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionViewFilters]) {
        NSMutableDictionary *filter = _itemsFilters[indexPath.section][@"terms"][indexPath.item];
        if (filter[@"isActive"] == [NSNumber numberWithBool:NO]) {
            [filter setObject:[NSNumber numberWithBool:YES] forKey:@"isActive"];
        }else{
            [filter setObject:[NSNumber numberWithBool:NO] forKey:@"isActive"];
        }
        [self.collectionViewFilters reloadData];
        [self updateSearchRequestWithQuery:nil];
    }else if ([collectionView isEqual:self.collectionViewResults]){
       
        NSString *foorseeId;
        if(_isDisplayingDiscoverItems){
           NSDictionary *layoutItem = _itemsDiscoverLayout[indexPath.item];
           NSNumber *contentListIndex = layoutItem[@"contentListIndex"];
            if ([self typeOfDiscoverItemAtIndexPath:indexPath] == THUMBNAIL) {
                NSDictionary *thumbnailItem = _itemsDiscoverThumbnails[contentListIndex.integerValue];
                foorseeId = thumbnailItem[@"id"];
            }else{
                NSDictionary *bannerItem = _itemsDiscoverBanners[contentListIndex.integerValue];
                foorseeId = bannerItem[@"target"][@"id"];
            }
        }else{
            NSDictionary *selectedResultItem = _itemsSearchResults[indexPath.item];
            foorseeId = selectedResultItem[@"id"];
        }
        [self.delegate itemSelectedWithFoorseeIdNumber:foorseeId];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self updateSearchRequestWithQuery:searchBar.text];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.collectionViewResults scrollRectToVisible:CGRectMake(0, PARALLAX_HEADER_REFERENCE_HEIGHT+1, self.collectionViewResults.bounds.size.width, self.collectionViewResults.bounds.size.height) animated:YES];
    
    
}

- (IBAction)startPageButtonTapped:(id)sender {
    
    if (self.collectionViewResults.bounds.origin.y > 0) {
        [self.collectionViewResults scrollRectToVisible:CGRectMake(0, 0, self.collectionViewResults.frame.size.width, self.collectionViewResults.frame.size.height) animated:YES];
    }
    
    [_foorseeSessionManager GET:@"discover.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self setUpViewToDisplayDiscoverItems:responseObject];
        if (self.searchBar) {
            self.searchBar.text = @"";
            
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];

}

- (IBAction)buttonFiltersTapped:(id)sender {
    CGFloat newWidth;
    if (_filterSectionIsOpen) {
        newWidth = 0;
        _filterSectionIsOpen = NO;
    }
    else{
        newWidth = self.widthOfFilterSection;
        _filterSectionIsOpen = YES;
    }
    
    [UIView animateWithDuration:DURATION_ANIMATION_FILTERS_OPEN_CLOSE animations:^{
        self.constraintFilterSectionWidth.constant = newWidth;
        [_layoutForFiltersCollectionView invalidateLayout];
        [_layoutForResultsCollectionView invalidateLayout];
        [self.view layoutIfNeeded];
        
    }];
    
    
}


-(void) updateSearchRequestWithQuery:(NSString *) query
{
    if (!query) {
        query = @"";
    }
    NSMutableString *tags = [NSMutableString stringWithString:@""];
    
    BOOL activeFiltersExists = NO;
    for (NSMutableDictionary *filterSection in _itemsFilters) {
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
        _itemsSearchResults = responseObject[@"result"][@"movies"];
        
        _itemsFilters = responseObject[@"availableToQuery"][@"tags"];
        
        _isDisplayingDiscoverItems = NO;
        [self.collectionViewFilters reloadData];
        [self.collectionViewResults reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];
}
-(NSInteger) numberOfThumbnailsToDisplayInWidth
{
    NSInteger thumbnailCount;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)){
        if (!_filterSectionIsOpen) {
            thumbnailCount = NUMBER_OF_THUMBNAILS_IN_WIDTH_LANDSCAPE;
        }else{
            thumbnailCount = NUMBER_OF_THUMBNAILS_IN_WIDTH_LANDSCAPE - 1;
        }
    }else if (UIInterfaceOrientationIsPortrait(orientation)){
        if (!_filterSectionIsOpen) {
            thumbnailCount = NUMBER_OF_THUMBNAILS_IN_WIDTH_LANDSCAPE - 1;
        }else{
            thumbnailCount = NUMBER_OF_THUMBNAILS_IN_WIDTH_LANDSCAPE - 2;
        }
    }
    return thumbnailCount;
}
-(NSInteger) numberOfBannersToDisplayInWidth
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    NSInteger bannerCount;
    
    if (UIInterfaceOrientationIsLandscape(orientation) && !_filterSectionIsOpen) {
        bannerCount = 2;
    }else{
        bannerCount = 1;
    }

    return bannerCount;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:self.collectionViewResults]) {
        CGFloat verticalScrollDistance = scrollView.bounds.origin.y;
        self.constraintBackgroundTop.constant = -PARALLAX_MARGIN -(PARALLAX_SPEED_FRACTION * verticalScrollDistance);
        CGFloat newAlpha = 1 - (0.0025 * verticalScrollDistance);
        if (newAlpha < 0) {
            newAlpha = 0;
        }
        self.imageViewBackground.alpha = newAlpha;
    }

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (!_filterSectionIsOpen) {
        self.collectionViewFilters.hidden = YES;
    }
    [_layoutForResultsCollectionView invalidateLayout];
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (_filterSectionIsOpen) {
        self.constraintFilterSectionWidth.constant = self.widthOfFilterSection;
        
    }else{
        self.collectionViewFilters.hidden = NO;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
