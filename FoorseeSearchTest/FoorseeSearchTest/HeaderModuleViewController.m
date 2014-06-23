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
#import <AXRatingView.h>

@interface HeaderModuleViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPoster;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UIView *placeholderRatingView;

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
    self.labelTitle.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_TITLE_IN_PROFILE_PAGE];
    self.textViewDescription.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_DESCRIPTION_TEXT];
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
    self.labelTitle.hidden = NO;
    _titleText = titleText;
    [self.labelTitle setText:titleText];
}

-(void) setRating:(NSNumber *)rating
{
    _rating = rating;
    AXRatingView *notEditableRatingView = [[AXRatingView alloc] initWithFrame:self.placeholderRatingView.bounds];
    [notEditableRatingView sizeToFit];
    [notEditableRatingView setUserInteractionEnabled:NO];
    [notEditableRatingView setValue:rating.floatValue]
    ;
    self.placeholderRatingView.hidden = NO;
    [self.placeholderRatingView addSubview:notEditableRatingView];
}

-(void)setDescriptionText:(NSString *)descriptionText
{
    self.textViewDescription.hidden = NO;
    _descriptionText = descriptionText;
    [self.textViewDescription setText:descriptionText];
    
}

@end
