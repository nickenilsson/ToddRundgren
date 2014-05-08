//
//  MediaPlayerViewController.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 07/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MediaPlayerDelegate <NSObject>

-(void) closeMediaPlayer;

@end

@interface MediaPlayerViewController : UIViewController

- (void)playVideoWithId:(NSString *)videoId;

@property (weak, nonatomic) id <MediaPlayerDelegate> delegate;

@end
