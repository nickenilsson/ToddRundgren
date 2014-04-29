//
//  ForeseeHTTPClient.m
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 14/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "FoorseeHTTPClient.h"

static NSString *const base_url = @"http://client_abstraction_api.moc/v1/X62G2eUCuid3cF3Dxod32idudYxg";

@implementation FoorseeHTTPClient{
    NSMutableDictionary *_currentSearchParameters;
}

+ (FoorseeHTTPClient *)sharedForeseeHTTPClient
{
    static FoorseeHTTPClient *_sharedForeseeHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedForeseeHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:base_url]]; 
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

-(void) getSearchResultsForParameters:(NSDictionary *) parameters
{
    [self GET:@"search/default.json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(foorseeHTTPClient:gotSearchResult:)]){
            [self.delegate foorseeHTTPClient:self gotSearchResult:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(foorseeHTTPClient:failedWithError:)]) {
            [self.delegate foorseeHTTPClient:self failedWithError:error];
        }
    }];
}

-(void) getMediaProfileForIdNumber:(NSString *)idNumber
{
    [self GET:[NSString stringWithFormat:@"movies/id/%@.json",idNumber] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(foorseeHTTPClient:gotMovieProfile:)]){
            [self.delegate foorseeHTTPClient:self gotMovieProfile:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(foorseeHTTPClient:failedWithError:)]) {
            [self.delegate foorseeHTTPClient:self failedWithError:error];
        }
    }];
}






@end
