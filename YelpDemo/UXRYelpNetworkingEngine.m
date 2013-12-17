//
//  RSTwitterEngine.m
//  RSOAuthEngine
//
//  Created by Rodrigo Sieiro on 12/8/11.
//  Copyright (c) 2011-2020 Rodrigo Sieiro <rsieiro@sharpcube.com>. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UXRYelpNetworkingEngine.h"

// Never share this information
#error YOU MUST PROVIDE YOUR YELP INFORMATION HERE OR THIS WONT WORK
#define YELP_CONSUMER_KEY @"NOT_SET"
#define YELP_CONSUMER_SECRET @"NOT_SET"
#define YELP_TOKEN @"NOT_SET"
#define YELP_TOKEN_SECRET @"NOT_SET"

// Default twitter hostname and paths
#define YELP_HOSTNAME @"api.yelp.com"
#define YELP_API @"v2"

//
#define YELP_SEARCH_PATH @"search"

@interface UXRYelpNetworkingEngine ()
@end

@implementation UXRYelpNetworkingEngine

#pragma mark - Initialization

- (id)init
{
    NSString *hostPath = [NSString stringWithFormat:@"%@/%@", YELP_HOSTNAME, YELP_API];
    self = [super initWithHostName:hostPath
                customHeaderFields:nil
                   signatureMethod:RSOAuthHMAC_SHA1
                       consumerKey:YELP_CONSUMER_KEY
                    consumerSecret:YELP_CONSUMER_SECRET
                       callbackURL:nil];
    [self setAccessToken:YELP_TOKEN secret:YELP_TOKEN_SECRET];
    if (self) {
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)getRestaurantsWithCompletionBlock:(UXRYelpEngineCompletionBlock)completionBlock
     failureBlock:(UXRYelpEngineErrorBlock)errorBlock
{
    
    // Fill the post body with the tweet
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"food", @"type",
                                       @"San Francisco", @"location",
                                       nil];
    MKNetworkOperation *op = [self operationWithPath:YELP_SEARCH_PATH
                                              params:postParams
                                          httpMethod:@"GET"
                                                 ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSError* error = nil;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:[completedOperation responseData]
                              options:kNilOptions
                              error:&error];
        if(error != nil){
            errorBlock(error);
        }
        
        NSArray* businesses = json[@"businesses"];
        completionBlock(businesses);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueSignedOperation:op];    
}

@end
