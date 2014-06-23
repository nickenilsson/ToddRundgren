//
//  CrewHeaderModuleViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 19/06/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#define HEIGHT_LABEL_DOB 20
#define HEIGHT_LABEL_DOD 20


#import "CrewHeaderModuleViewController.h"
#import "UIImage+ImageWithColor.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+ColorFromHex.h"



@interface CrewHeaderModuleViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPoster;
@property (weak, nonatomic) IBOutlet UILabel *labelArtistName;
@property (strong, nonatomic) UIView *previousView;

@end

@implementation CrewHeaderModuleViewController

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
    self.previousView = self.labelArtistName;
}

-(void)setData:(id)data
{
    _data = data;
    [self setUpView];
}

-(void) setUpView
{
    NSLog(@"%@", self.data[@"urlFriendlyName"]);
    if (self.data[@"images"][@"thumbnails"][0][@"url"]) {
        NSURL *imageUrl = [NSURL URLWithString:self.data[@"images"][@"thumbnails"][0][@"url"]];
        [self.imageViewPoster setImageWithURL:imageUrl placeholderImage:[UIImage imageWithColor:[UIColor blackColor]]];
    }
    if (self.data[@"name"]) {
        self.labelArtistName.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_TITLE_IN_PROFILE_PAGE];
        self.labelArtistName.textColor = [UIColor colorFromHexString:COLOR_HEX_TEXT_MAIN];
        self.labelArtistName.text = self.data[@"name"];
    }
    
    if (self.data[@"birthDate"] != nil) {
        if ([self.data[@"birthDate"] respondsToSelector:@selector(objectForKey:)]) {
            [self addDateOfBirth];
        }

    }
    if (self.data[@"deathDate"] != nil) {
        if ([self.data[@"deathDate"] respondsToSelector:@selector(objectForKey:)]) {
            [self addDateOfDeath];
        }
    }
    if ([self.data[@"biography"] isKindOfClass:[NSString class]]) {
        
        [self addBiography];
    }
    
}

-(void) addDateOfBirth
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_BIRTH_DEATH_INFO];
    label.textColor = [UIColor colorFromHexString:COLOR_HEX_TEXT_MAIN];

    [self.view addSubview:label];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSNumber *referenceDate = self.data[@"birthDate"][@"utc"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:referenceDate.integerValue];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
 
    NSMutableString *stringForLabel = [NSMutableString stringWithFormat:@"Born: %@",formattedDateString];
    if ([self.data[@"placeOfBirth"] isKindOfClass:[NSString class]]) {
        [stringForLabel appendString:[NSString stringWithFormat:@", %@", self.data[@"placeOfBirth"]]] ;
    }
    label.text = stringForLabel;

    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[previousView]-[label(%d)]", HEIGHT_LABEL_DOB] options:0 metrics:nil views:@{@"previousView": self.previousView, @"label":label}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[posterImageView]-[label]|" options:0 metrics:nil views:@{@"posterImageView": self.imageViewPoster, @"label": label}]];
    self.previousView = label;
}
-(void) addDateOfDeath
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_BIRTH_DEATH_INFO];
    label.textColor = [UIColor colorFromHexString:COLOR_HEX_TEXT_MAIN];
    
    [self.view addSubview:label];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSNumber *referenceDate = self.data[@"deathDate"][@"utc"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:referenceDate.integerValue];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    NSMutableString *stringForLabel = [NSMutableString stringWithFormat:@"Deceased: %@",formattedDateString];
    
    label.text = stringForLabel;
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[previousView]-[label(%d)]", HEIGHT_LABEL_DOB] options:0 metrics:nil views:@{@"previousView": self.previousView, @"label":label}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[posterImageView]-[label]|" options:0 metrics:nil views:@{@"posterImageView": self.imageViewPoster, @"label": label}]];
    self.previousView = label;

}

-(void) addBiography
{
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont fontWithName:FONT_MAIN size:FONT_SIZE_DESCRIPTION_TEXT];
    [textView setEditable:NO];
    textView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:textView];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]-[textView]-(20)-|" options:0 metrics:nil views:@{@"previousView": self.previousView, @"textView": textView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageViewPoster]-[textView]-|" options:0 metrics:nil views:@{@"imageViewPoster": self.imageViewPoster, @"textView": textView}]];
    textView.text = self.data[@"biography"];
    textView.textColor = [UIColor colorFromHexString:COLOR_HEX_TEXT_MAIN];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
