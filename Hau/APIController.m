//
//  APIController.m
//  PicVix
//
//  Created by Andrew on 6/26/14.
//
//

#import "APIController.h"

static NSString *const kBaseURL = @"http://www.haujournal.org/index.php/";

@implementation APIController
{
    NSURL *baseUrl;
}

- (instancetype)init
{
    self = [super init];
    if(self) {
        baseUrl = [NSURL URLWithString:kBaseURL];
    }
    return self;
}

- (NSMutableURLRequest *)GETRequestForEndpoint:(NSString *)endpoint
{
    NSURL *url = [NSURL URLWithString:endpoint relativeToURL:baseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3 * 60];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    return request;
}

- (NSMutableURLRequest *)PUTRequestForEndpoint:(NSString *)endpoint jsonObject:(id)jsonDictOrArray
{
    NSURL *url = [NSURL URLWithString:endpoint relativeToURL:baseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if(jsonDictOrArray){
        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDictOrArray
                                                       options: 0
                                                         error:nil];
        [request setHTTPBody:data];
        
    }
    
    return request;
}

- (NSMutableURLRequest *)POSTRequestForEndpoint:(NSString *)endpoint jsonObject:(id)jsonDictOrArray
{
    NSURL *url = [NSURL URLWithString:endpoint relativeToURL:baseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3 * 60];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    if(jsonDictOrArray){
        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDictOrArray
                                                       options: 0
                                                         error:nil];
        [request setHTTPBody:data];
        
    }

    return request;
}

@end
