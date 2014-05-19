//
//  ForeseeHTTPClient.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 14/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "FoorseeHTTPClient.h"

@implementation FoorseeHTTPClient{
    NSMutableDictionary *_currentSearchParameters;
}

+ (FoorseeHTTPClient *)sharedForeseeHTTPClient
{
    static FoorseeHTTPClient *_sharedForeseeHTTPClient = nil;
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@", FOORSEE_API_URL, API_KEY];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedForeseeHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    });
    
    return _sharedForeseeHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];

    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}




@end
