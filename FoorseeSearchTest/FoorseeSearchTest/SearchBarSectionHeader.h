//
//  SearchBarSectionHeader.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 12/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBarSectionHeader : UICollectionReusableView

+(UINib *) nib;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
