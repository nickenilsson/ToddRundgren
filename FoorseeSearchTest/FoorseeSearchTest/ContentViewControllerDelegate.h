//
//  ContentViewControllerDelegate.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 29/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ContentViewControllerDelegate <NSObject>


@optional
-(void) searchWasMadeInDiscoverViewWithQuery:(NSString *) query;
-(void) itemSelectedWithFoorseeIdNumber:(NSString *) idNumber;

@end
