//
//  ExternalSourcesModuleViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 05/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#define CELL_WIDTH 250
#define CELL_HEIGHT 70


#import "ExternalSourcesModuleViewController.h"
#import "ImageCell.h"
#import "ArrayDataSource.h"
#import "UIImage+ImageWithColor.h"
#import "UIImageView+AFNetworking.h"

static NSString * const externalSourceCellIdentifier = @"externalSourceCellIdentifier";

@interface ExternalSourcesModuleViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ExternalSourcesModuleViewController{
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
    // Do any additional setup after loading the view from its nib.
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[ImageCell nib] forCellWithReuseIdentifier:externalSourceCellIdentifier];
    
}

-(void)setCollectionViewItems:(NSMutableArray *)collectionViewItems
{
    _collectionViewItems = collectionViewItems;
    [self.collectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _collectionViewItems.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:externalSourceCellIdentifier forIndexPath:indexPath];
//    NSDictionary *dataItem = _collectionViewItems[indexPath.item];
//    NSURL *imageUrl = [NSURL URLWithString:dataItem[@"provider"][@"iconUrl"]];
//    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
//    
//    [cell.image setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        cell.image.image = image;
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        NSLog(@"Failure: %@", [error localizedDescription]);
//    }];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat insetBottomAndTop = floor(self.collectionView.bounds.size.height / 2)-layout.itemSize.height;

    return UIEdgeInsetsMake(insetBottomAndTop, 10, insetBottomAndTop, 10);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
