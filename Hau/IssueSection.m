//
//  IssueSection.m
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "IssueSection.h"
#import "IssueArticle.h"
#import "TFHpple.h"

@interface IssueSection ()

@property (nonatomic, strong) NSMutableArray *articles;

@end

@implementation IssueSection

+ (Class)classForArrayProperty:(NSString *)propertyName
{
    if([propertyName isEqualToString:@"articles"]){
        return [IssueArticle class];
    }
    return nil;
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if(self){
        _title = title;
        _articles = [NSMutableArray array];
    }
    return self;
}

- (void)addArticle:(IssueArticle *)article
{
    [self.articles addObject:article];
}

@end
