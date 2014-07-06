//
//  JSONBackedModel.m
//  PicVix
//
//  Created by Andrew on 7/3/14.
//
//

#import "JSONBackedModel.h"
#import <objc/runtime.h>

@implementation JSONBackedModel


+ (Class)classForArrayProperty:(NSString *)propertyName
{
    return nil;
}

- (NSDictionary *)dictionary
{
    NSArray *props = [self allPropertyNames];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for(NSString* prop in props){
        id propVal = [self valueForKey:prop];
     
        if(propVal != nil && propVal != [NSNull null]){
            if([propVal isKindOfClass:[NSArray class]]){
                NSMutableArray *propDicts = [NSMutableArray array];
                for (id obj in propVal) {
                    if( [obj respondsToSelector:@selector(dictionary)]){
                        [propDicts addObject:[obj performSelector:@selector(dictionary)]];
                    } else {
                        [propDicts addObject:obj];
                    }
                }
                [dict setObject:propDicts forKey:prop];
            } else {
                [dict setObject:propVal forKey:prop];
            }
        }
    }
    return dict;
}

- (NSData *)JSONData
{
    return [NSJSONSerialization dataWithJSONObject:[self dictionary]
                                           options: 0
                                             error:nil];
}

- (NSString *)JSONString
{
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

- (void)pickValuesForKeysFromDictionary: (NSDictionary *)dict
{
    NSMutableDictionary *acceptDict = [[NSMutableDictionary alloc] init];
    NSDictionary *propClasses = [self propertyTypes];
    
    for(NSString *key in [self allPropertyNames]){
        id obj = [dict objectForKey:key];
        if(obj && obj != [NSNull null]){
            NSString *className = [propClasses objectForKey:key];

            if([className isEqualToString:@"NSArray"]){
                NSMutableArray *classObjs = [NSMutableArray array];
                Class propClass = [[self class] classForArrayProperty:key];
                for (id classObj in obj){
                    id pco = [[propClass alloc] init];
                    [pco performSelector:@selector(pickValuesForKeysFromDictionary:) withObject:classObj];
                    [classObjs addObject:pco];
                }
                [acceptDict setObject:classObjs forKey:key];
            } else {
                [acceptDict setObject:obj forKey:key];
            }
        }
    }
    [self setValuesForKeysWithDictionary:acceptDict];
}



- (NSArray *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

- (NSDictionary *)propertyTypes
{
    NSMutableDictionary *pt = [NSMutableDictionary dictionary];
    
    unsigned int count;
    objc_property_t* props = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = props[i];
        const char * name = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        const char * type = property_getAttributes(property);
        NSString *attr = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];
        
        if (strcmp(rawPropertyType, @encode(float)) == 0) {
            //it's a float
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            //it's an int
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            //it's some sort of object
        } else {
            // According to Apples Documentation you can determine the corresponding encoding values
        }
        
        if ([typeAttribute hasPrefix:@"T@"]) {
            NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns @"NSDate" into NSDate
            Class typeClass = NSClassFromString(typeClassName);
            if (typeClass != nil) {
                // Here is the corresponding class even for nil values
                [pt setObject:typeClassName forKey:propertyName];
            }
        }
        
    }
    free(props);
    
    return pt;
}


@end
