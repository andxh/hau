//
//  JSONBackedModel.h
//  PicVix
//
//  Created by Andrew on 7/3/14.
//
//

#import <Foundation/Foundation.h>

@interface JSONBackedModel : NSObject

+ (Class)classForArrayProperty:(NSString *)propertyName;

- (NSDictionary *)dictionary;
- (NSData *)JSONData;
- (NSString *)JSONString;
- (void)pickValuesForKeysFromDictionary: (NSDictionary *)dict;


@end
