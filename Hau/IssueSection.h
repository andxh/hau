//
//  IssueSection.h
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "JSONBackedModel.h"
#import "IssueArticle.h"

@interface IssueSection : JSONBackedModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong, readonly) NSMutableArray *articles;

- (instancetype)initWithTitle:(NSString *)title;

- (void)addArticle:(IssueArticle *)article;

@end
