//
//  ForeseeHTTPClient.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 14/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "AFHTTPSessionManager.h"


static NSString * const foreseeApiBaseUrl = @"http://client_abstraction_api.moc/v1/";
static NSString * const apiKey = @"X62G2eUCuid3cF3Dxod32idudYxg";

@interface FoorseeHTTPClient : AFHTTPSessionManager


+ (FoorseeHTTPClient *)sharedForeseeHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

@end



