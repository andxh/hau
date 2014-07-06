//
//  ArchiveC.h
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "APIController.h"

@interface ArchiveC : APIController

@property (nonatomic, strong, readonly) NSArray *volumes;

+ (instancetype)ArchiveController;

- (void)updateArchiveIndex;


@end
