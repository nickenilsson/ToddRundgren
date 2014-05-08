//
//  MediaPlayerViewController.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 07/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "MediaPlayerViewController.h"

static NSString *youTubeVideoHTML = @"<!DOCTYPE html><html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'%0.0f', height:'%0.0f', videoId:'%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>";


@interface MediaPlayerViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)buttonCloseTapped:(id)sender;

@end

@implementation MediaPlayerViewController

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
    self.webView.delegate = self;
    self.webView.mediaPlaybackRequiresUserAction = NO;
    
}

- (void)playVideoWithId:(NSString *)videoId {
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML,self.view.frame.size.width, self.view.frame.size.height, videoId];
    
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] resourceURL]];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Webview failed: %@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonCloseTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closeMediaPlayer)]) {
        [self.delegate closeMediaPlayer];
    }
}
@end
