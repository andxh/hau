//
//  VolumeIssue.m
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "VolumeIssue.h"
#import "IssueArticle.h"
#import "IssueSection.h"
#import "TFHpple.h"


NSString *const kCoverImagePath = @"//div[@class='issueCoverImage']/a/img";
NSString *const kIssueURL = @"//h4/a";

@implementation VolumeIssue

+ (Class)classForArrayProperty:(NSString *)propertyName
{
    if([propertyName isEqualToString:@"articles"]){
        return [IssueArticle class];
    }
    if([propertyName isEqualToString:@"sections"]){
        return [IssueSection class];
    }
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

- (void)updateWithDictionary:(NSDictionary *)issueDict
{
    // fill in self with any values from issueDict
    // up will be from the cache
    VolumeIssue *up = [[VolumeIssue alloc] init];
    [up pickValuesForKeysFromDictionary:issueDict];

    // ignore sections, just check articles. Not the most efficient, but...
    for (IssueSection *upSection in up.sections){
        for (IssueArticle *upArticle in upSection.articles) {
            for (IssueSection *section in self.sections) {
                for (IssueArticle *article in section.articles) {
                    if ([upArticle.abstractURL isEqualToString:article.abstractURL]) {
                        article.abstractFileURL = upArticle.abstractFileURL;
                        article.pdfFileURL = upArticle.pdfFileURL;
                    }
                }
            }
        }
    }
}

+ (NSString *)issueImageURLFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [super firstElementFromElement:element forPath:kCoverImagePath];
    return [el objectForKey:@"src"];
}

+ (NSString *)issueURLFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [super firstElementFromElement:element forPath:kIssueURL];
    return [el objectForKey:@"href"];
}

+ (NSString *)titleFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [super firstElementFromElement:element forPath:kIssueURL];
    return [el text];
}



@end
