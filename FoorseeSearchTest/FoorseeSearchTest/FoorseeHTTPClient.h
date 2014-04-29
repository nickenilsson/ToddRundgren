//
//  ForeseeHTTPClient.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 14/04/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol ForeseeHTTPClientDelegate;

static NSString * const foreseeApiBaseUrl = @"http://client_abstraction_api.moc/v1/";
static NSString * const apiKey = @"X62G2eUCuid3cF3Dxod32idudYxg";

@interface FoorseeHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<ForeseeHTTPClientDelegate>delegate;

+ (FoorseeHTTPClient *)sharedForeseeHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void) getSearchResultsForParameters:(NSDictionary *) parameters;
-(void) getMediaProfileForIdNumber:(NSString *)idNumber;

@end


@protocol ForeseeHTTPClientDelegate <NSObject>
@optional
-(void)foorseeHTTPClient:(FoorseeHTTPClient *)client gotSearchResult:(id)responseObject;
-(void)foorseeHTTPClient:(FoorseeHTTPClient *)client gotMovieProfile:(id)responseObject;
-(void)foorseeHTTPClient:(FoorseeHTTPClient*)client failedWithError:(NSError *)error;


@end


