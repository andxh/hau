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

@protocol VolumeWatcher;
@protocol IssueWatcher;

@interface ArchiveC : APIController

@property (nonatomic, strong, readonly) NSArray *volumes;

+ (instancetype)ArchiveController;

- (void)registerVolumeWatcher:(id<VolumeWatcher>)watcher;
- (void)registerIssueWatcher:(id<IssueWatcher>)watcher;


- (void)updateArchiveIndex;

- (NSString *)cacheKeyForVolume:(JournalVolume *)volume;
- (NSString *)cacheKeyForVolume:(JournalVolume *)volume issue:(VolumeIssue *)issue;

- (void)updateIssue:(VolumeIssue *)issue;
- (VolumeIssue *)volumeIssue:(NSIndexPath *)path;

- (void)getAllArticlesForIssue:(VolumeIssue *)issue;

- (void)getPdfForIssue:(VolumeIssue *)issue article:(IssueArticle *)article success:(void(^)(NSString *fileURL))success;

@end


@protocol VolumeWatcher <NSObject>

- (void)didUpdateVolume:(JournalVolume *)volume;

@end

@protocol IssueWatcher <NSObject>

- (void)didUpdateIssue:(VolumeIssue *)issue;

@end