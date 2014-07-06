//
//  VolumeIssue.m
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "VolumeIssue.h"
#import "TFHpple.h"


NSString *const kCoverImagePath = @"//div[@class='issueCoverImage']/a/img";
NSString *const kIssueURL = @"//h4/a";

@implementation VolumeIssue

+ (Class)classForArrayProperty:(NSString *)propertyName
{
    // TODO:
    return nil;
}


- (instancetype)initWithElement:(TFHppleElement *)element
{
    self = [super init];
    if(self){
        _coverImageURL = [VolumeIssue issueImageURLFromElement:element];
        _issueURL = [VolumeIssue issueURLFromElement:element];
        _title = [VolumeIssue titleFromElement:element];
    }
    return self;
}


+ (NSString *)issueImageURLFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [VolumeIssue firstElementFromElement:element forPath:kCoverImagePath];
    return [el objectForKey:@"src"];
}

+ (NSString *)issueURLFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [VolumeIssue firstElementFromElement:element forPath:kIssueURL];
    return [el objectForKey:@"href"];
}

+ (NSString *)titleFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [VolumeIssue firstElementFromElement:element forPath:kIssueURL];
    return [el text];
}


+ (TFHppleElement *)firstElementFromElement:(TFHppleElement *)element forPath:(NSString *)path
{
    NSArray *elements = [element searchWithXPathQuery:path];
    if (elements.count > 0) {
        return elements[0];
    }
    return nil;
}

@end
