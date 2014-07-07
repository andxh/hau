//
//  IssueArticle.h
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "JSONBackedModel.h"
#import "TFHpple.h"

@interface IssueArticle : JSONBackedModel

@property (nonatomic, strong) NSString *abstractURL;
@property (nonatomic, strong) NSString *abstractFileURL;
@property (nonatomic, strong) NSString *pdfURL;
@property (nonatomic, strong) NSString *pdfFileURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *pages;

- (instancetype)initWithElement:(TFHppleElement *)element;

@end
