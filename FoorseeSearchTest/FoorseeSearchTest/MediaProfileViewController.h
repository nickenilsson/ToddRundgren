//
//  MediaProfileViewController.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 24/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MediaProfileDelegate <NSObject>

@optional

-(void) backButtonTappedInMediaProfileView;

@end


@interface MediaProfileViewController : UIViewController


-(void) setData:(id)data;

- (IBAction)buttonBackTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) id <MediaProfileDelegate> delegate;

@end

