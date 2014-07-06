//
//  ArchiveC.m
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "ArchiveC.h"
#import "TFHpple.h"
#import "JournalVolume.h"
#import "VolumeIssue.h"
#import "EGOCache.h"

static NSString *const kVolumesListCacheKey = @"volumes";

@implementation ArchiveC

+ (instancetype)ArchiveController
{
    static ArchiveC *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)updateArchiveIndex
{
    NSMutableURLRequest *request = [self GETRequestForEndpoint:@"hau/issue/archive"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                               NSDictionary *headers  = [httpResponse allHeaderFields];
                               NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                               if([httpResponse statusCode] == 200){
                                   NSLog(@"200 PHOTO response");
                                   TFHpple *parser = [TFHpple hppleWithHTMLData:data];

                                   NSString *volumesQ = @"//div[@id='issue']/../.";
                                   NSArray *volumeElements = [parser searchWithXPathQuery:volumesQ];
                                   NSMutableArray *volumes = [NSMutableArray array];
                                   for(TFHppleElement *volume in volumeElements){
                                       JournalVolume *jv = [[JournalVolume alloc] initWithElement:volume];
                                       [volumes addObject:jv];
                                   }
                                   
                                   [self updateCacheWithVolumes:volumes];

                               } else {
                                   
                                   
                                   NSLog(@"Other PHOTO response: %@", responseString);
                               }
                           }];

}

- (void)updateCacheWithVolumes:(NSArray*)volumes
{
    NSMutableArray *vols = [NSMutableArray array];
    for (JournalVolume *v in volumes){
        NSString *volCacheKey = [NSString stringWithFormat:@"volume_%@", v.volumeYear];
        [[EGOCache globalCache] setObject:[v dictionary] forKey:volCacheKey withTimeoutInterval:NSUIntegerMax];
        [vols addObject:volCacheKey];
        
        for(VolumeIssue *i in v.issues) {
            NSString *cacheKey = [NSString stringWithFormat:@"volume_%@_issue_%@", v.volumeYear, i.issueURL];
            
            if(![[EGOCache globalCache] hasCacheForKey:cacheKey]){
                [[EGOCache globalCache] setObject:[v dictionary] forKey:cacheKey withTimeoutInterval:NSUIntegerMax];
            }
        }
    }
    
    [[EGOCache globalCache] setObject:vols forKey:kVolumesListCacheKey withTimeoutInterval:NSUIntegerMax];
    
    // TODO:
    // notify of update...
    
    /*
     journal
       issue
         section
           title
           index
         article
           sectionIndex
             listIndex
             url
             title
             author
             pdf
             pages
     */
}

- (NSArray *)volumes
{
    NSArray *volKeys = (NSArray *)[[EGOCache globalCache] objectForKey:kVolumesListCacheKey];
    NSMutableArray *vols = [NSMutableArray array];
    for(NSString *volCacheKey in volKeys){
        NSDictionary *volDict = (NSDictionary *)[[EGOCache globalCache] objectForKey:volCacheKey];
        JournalVolume *jv = [[JournalVolume alloc] init];
        [jv pickValuesForKeysFromDictionary:volDict];
        [vols addObject:jv];
    }
    return vols;
}

@end
