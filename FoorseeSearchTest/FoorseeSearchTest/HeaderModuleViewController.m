//
//  HeaderModuleViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 29/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "HeaderModuleViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"

@interface HeaderModuleViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPoster;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

@end

@implementation HeaderModuleViewController

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
    self.textViewDescription.editable = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUrlPoster:(NSURL *)urlPoster
{
    _urlPoster = urlPoster;
    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
    [self.imageViewPoster setImageWithURL:urlPoster placeholderImage:placeholderImage];
}

-(void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    [self.labelTitle setText:titleText];
}

-(void)setDescriptionText:(NSString *)descriptionText
{
    _descriptionText = descriptionText;
    [self.textViewDescription setText:descriptionText];
    
}

@end
