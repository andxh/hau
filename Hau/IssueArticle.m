//
//  IssueArticle.m
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "IssueArticle.h"

static NSString *const kArticleTitleQ = @"//td[@class='tocTitle']/a"; // absract link with title text
static NSString *const kArticlePDFQ = @"//td[@class='tocGalleys']/a"; // must replace "view" with "download"
static NSString *const kArticleAuthorsQ = @"//td[@class='tocAuthors']";
static NSString *const kArticlePagesQ = @"//td[@class='tocPages']";

@implementation IssueArticle

- (instancetype)initWithElement:(TFHppleElement *)element
{
    self = [super init];
    if(self){
        _abstractURL = [IssueArticle abstractURLFromElement:element];
        _pdfURL = [IssueArticle pdfURLFromElement:element];
        _title = [IssueArticle titleFromElement:element];
        _author = [IssueArticle authorsFromElement:element];
        _pages = [IssueArticle pagesFromElement:element];
    }
    return self;
}

+ (NSString *)abstractURLFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [super firstElementFromElement:element forPath:kArticleTitleQ];
    return [el objectForKey:@"href"];
}

+ (NSString *)titleFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [super firstElementFromElement:element forPath:kArticleTitleQ];
    return [el text];
}

+ (NSString *)pdfURLFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [super firstElementFromElement:element forPath:kArticlePDFQ];
    NSString *viewURL = [el objectForKey:@"href"];
    return [viewURL stringByReplacingOccurrencesOfString:@"article/view" withString:@"article/download"];
}

+ (NSString *)authorsFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [super firstElementFromElement:element forPath:kArticleAuthorsQ];
    return [el text];
}

+ (NSString *)pagesFromElement:(TFHppleElement *)element
{
    TFHppleElement *el = [super firstElementFromElement:element forPath:kArticlePagesQ];
    return [el text];
}

@end
