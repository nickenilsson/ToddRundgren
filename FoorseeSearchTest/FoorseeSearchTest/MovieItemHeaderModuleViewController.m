//
//  HeaderModuleViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 29/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "MovieItemHeaderModuleViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"
#import "UIColor+ColorFromHex.h"
#import <AXRatingView.h>

#define HEIGHT_RATING_VIEW 30


@interface MovieItemHeaderModuleViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPoster;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UIView *placeholderRatingView;

@property (strong, nonatomic) UIView *previousView;

@end

@implementation MovieItemHeaderModuleViewController

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

-(void)setData:(id)data
{
    _data = data;
    [self setUpView];
}


-(void) setUpView
{
    //self.labelTitle.hidden = NO;
    NSMutableString *titleString = [NSMutableString string];
    [titleString appendString:self.data[@"title"]];
    
    if (self.data[@"releaseDate"][@"year"]) {
        NSString *yearString = [NSString stringWithFormat:@" %@",self.data[@"releaseDate"][@"year"]];
        [titleString appendString:yearString];
    }
    self.labelTitle.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_TITLE_IN_PROFILE_PAGE];
    self.labelTitle.text = titleString;
    self.labelTitle.hidden = NO;
    
    self.previousView = self.labelTitle;
    
    if (self.data[@"posterThumbnail"][@"url"]) {
        [self.imageViewPoster setImageWithURL:[NSURL URLWithString:self.data[@"posterThumbnail"][@"url"]] placeholderImage:[UIImage imageWithColor:[UIColor blackColor]]];
    }else{
        self.imageViewPoster.image = [UIImage imageNamed:@"default_profile.png"];
    }
 
    if (self.data[@"rating"]) {
        [self addRatingView];
    }
    
    if (self.data[@"plot"]) {
        [self addDescriptionView];
    }
    
    
}


-(void) addRatingView
{
    AXRatingView *ratingView = [[AXRatingView alloc] init];
    NSNumber *ratingScore = self.data[@"rating"][@"score"];
    [ratingView setValue:ratingScore.floatValue];
    [ratingView setUserInteractionEnabled:NO];
    
    [self.view addSubview:ratingView];
    [ratingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[poster]-[ratingView]-|" options:0 metrics:nil views:@{@"poster": self.imageViewPoster, @"ratingView":ratingView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[previousView]-[ratingView(%d)]", HEIGHT_RATING_VIEW] options:0 metrics:nil views:@{@"previousView": self.previousView, @"ratingView": ratingView}]];
    
    self.previousView = ratingView;
}

-(void) addRuntimeView
{

}

-(void) addDescriptionView
{
    UITextView *descriptionView = [[UITextView alloc] init];
    [self.view addSubview:descriptionView];
    
    [descriptionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:descriptionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:8]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:descriptionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imageViewPoster attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[poster]-[description]-|" options:0 metrics:nil views:@{@"poster": self.imageViewPoster, @"description": descriptionView}]];
    
    descriptionView.text = self.data[@"plot"];
    descriptionView.textColor = [UIColor colorFromHexString:COLOR_HEX_TEXT_MAIN alpha:1.0];
    descriptionView.backgroundColor = [UIColor colorFromHexString:COLOR_HEX_DESCRIPTION_TEXT_BACKGROUND alpha:ALPHA_DESCRIPTION_BACKGROUND];
    descriptionView.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_DESCRIPTION_TEXT];
    
    

}


@end
