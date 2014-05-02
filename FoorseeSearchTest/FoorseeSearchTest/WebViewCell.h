//
//  WebViewCell.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 02/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewCell : UICollectionViewCell

+(UINib *) nib;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
