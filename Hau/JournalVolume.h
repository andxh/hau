//
//  JournalVolume.h
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONBackedModel.h"
#import "TFHpple.h"

@interface JournalVolume : JSONBackedModel

@property (nonatomic,strong) NSString *volumeYear;
@property (nonatomic, strong) NSArray *issues;


- (instancetype)initWithElement:(TFHppleElement *)element;

@end
