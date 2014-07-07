//
//  VolumeIssue.h
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONBackedModel.h"
#import "TFHpple.h"

@interface VolumeIssue : JSONBackedModel

@property (nonatomic,strong) NSString *coverImageURL;
@property (nonatomic,strong) NSString *issueURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *sections;

- (instancetype)initWithElement:(TFHppleElement *)element;

- (void)updateWithDictionary:(NSDictionary *)issueDict;

@end
