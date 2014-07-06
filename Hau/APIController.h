//
//  APIController.h
//  PicVix
//
//  Created by Andrew on 6/26/14.
//
//

#import <Foundation/Foundation.h>

@interface APIController : NSObject

- (NSMutableURLRequest *)GETRequestForEndpoint:(NSString *)endpoint;
- (NSMutableURLRequest *)PUTRequestForEndpoint:(NSString *)endpoint jsonObject:(id)jsonDictOrArray;
- (NSMutableURLRequest *)POSTRequestForEndpoint:(NSString *)endpoint jsonObject:(id)jsonDictOrArray;

@end
