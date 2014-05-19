//
//  ForeseeHTTPClient.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 14/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "AFHTTPSessionManager.h"




@interface FoorseeHTTPClient : AFHTTPSessionManager


+ (FoorseeHTTPClient *)sharedForeseeHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

@end



