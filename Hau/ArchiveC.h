//
//  ArchiveC.h
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "APIController.h"
#import "JournalVolume.h"
#import "VolumeIssue.h"
#import "IssueArticle.h"

@interface ArchiveC : APIController

@property (nonatomic, strong, readonly) NSArray *volumes;

+ (instancetype)ArchiveController;

- (void)updateArchiveIndex;

- (NSString *)cacheKeyForVolume:(JournalVolume *)volume;
- (NSString *)cacheKeyForVolume:(JournalVolume *)volume issue:(VolumeIssue *)issue;

- (void)updateIssue:(VolumeIssue *)issue;
- (VolumeIssue *)volumeIssue:(NSIndexPath *)path;

- (void)getPdfForIssue:(VolumeIssue *)issue article:(IssueArticle *)article success:(void(^)(NSString *fileURL))success;

@end
