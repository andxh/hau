//
//  JournalVolume.m
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "JournalVolume.h"
#import "VolumeIssue.h"

NSString *const kVolumeYear = @"//h3";
NSString *const kIssue = @"//div[@id='issue']";

@implementation JournalVolume

+ (Class)classForArrayProperty:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"issues"]) {
        return [VolumeIssue class];
    }
    return nil;
}


- (instancetype)initWithElement:(TFHppleElement *)element
{
    self = [super init];
    if(self){
        _volumeYear = [JournalVolume volumeYearFromElement:element];
        _issues = [JournalVolume issuesFromElement:element];
    }
    return self;
}

+ (NSString *)volumeYearFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [JournalVolume firstElementFromElement:element forPath:kVolumeYear];
    return [el text];
}

+ (NSArray *)issuesFromElement:(TFHppleElement *)element
{
    NSArray *elements = [element searchWithXPathQuery:kIssue];
    NSMutableArray *issues = [NSMutableArray array];
    for (TFHppleElement *el in elements) {
        VolumeIssue *vi = [[VolumeIssue alloc] initWithElement:el];
        [issues addObject:vi];
    }
    return issues;
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
