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
#import "IssueSection.h"
#import "IssueArticle.h"
#import "EGOCache.h"
#import <CommonCrypto/CommonDigest.h>

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


- (NSString *)cacheKeyForVolume:(JournalVolume *)volume
{
    return [[self class] md5HexDigest:[NSString stringWithFormat:@"volume_%@", volume.volumeYear]];
}

- (NSString *)cacheKeyForVolume:(JournalVolume *)volume issue:(VolumeIssue *)issue
{
    return [[self class] md5HexDigest:[NSString stringWithFormat:@"volume_%@_issue_%@", volume.volumeYear, issue.issueURL]];
}

- (NSString *)cacheKeyForIssue:(VolumeIssue *)issue
{
    return [[self class] md5HexDigest:[NSString stringWithFormat:@"issue_%@", issue.issueURL]];
}

- (void)updateCacheWithVolumes:(NSArray*)volumes
{
    NSMutableArray *vols = [NSMutableArray array];
    for (JournalVolume *v in volumes){
        NSString *volCacheKey = [self cacheKeyForVolume:v];
        [[EGOCache documentsCache] setObject:[v dictionary] forKey:volCacheKey withTimeoutInterval:NSUIntegerMax];
        [vols addObject:volCacheKey];
        
        for(VolumeIssue *i in v.issues) {
            NSString *cacheKey = [self cacheKeyForVolume:v issue:i];
            
            if(![[EGOCache documentsCache] hasCacheForKey:cacheKey]){
                [[EGOCache documentsCache] setObject:[v dictionary] forKey:cacheKey withTimeoutInterval:NSUIntegerMax];
            }
        }
    }
    
    [[EGOCache documentsCache] setObject:vols forKey:kVolumesListCacheKey withTimeoutInterval:NSUIntegerMax];
    
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
    NSArray *volKeys = (NSArray *)[[EGOCache documentsCache] objectForKey:kVolumesListCacheKey];
    NSMutableArray *vols = [NSMutableArray array];
    for(NSString *volCacheKey in volKeys){
        NSDictionary *volDict = (NSDictionary *)[[EGOCache documentsCache] objectForKey:volCacheKey];
        JournalVolume *jv = [[JournalVolume alloc] init];
        [jv pickValuesForKeysFromDictionary:volDict];
        [vols addObject:jv];
    }
    return vols;
}

- (VolumeIssue *)volumeIssue:(NSIndexPath *)path
{
    VolumeIssue *issue = [(JournalVolume *)[[ArchiveC ArchiveController] volumes][path.section] issues][path.row];
    NSString *cacheKey = [self cacheKeyForIssue:issue];
    
    [issue pickValuesForKeysFromDictionary:(NSDictionary *)[[EGOCache documentsCache] objectForKey:cacheKey]];

    return issue;
}

- (void)updateIssue:(VolumeIssue *)issue
{
    NSMutableURLRequest *request = [self GETRequestForEndpoint:nil];
    [request setURL:[NSURL URLWithString:issue.issueURL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                               NSDictionary *headers  = [httpResponse allHeaderFields];
                               NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               
                               if([httpResponse statusCode] == 200){
                                   NSLog(@"200 PHOTO response");
                                   TFHpple *parser = [TFHpple hppleWithHTMLData:data];
                                   
                                   NSString *sectionsQ = @"//h4[@class='tocSectionTitle'] | //table[@class='tocArticle']";
                                   NSArray *sectionElements = [parser searchWithXPathQuery:sectionsQ];
                                   NSMutableArray *sections = [NSMutableArray array];
                                   IssueSection *section;
                                   for(TFHppleElement *sectionEl in sectionElements){
                                       if ([[sectionEl tagName] isEqualToString:@"h4"]) {
                                           if (section) {
                                               [sections addObject:section];
                                           }
                                          section = [[IssueSection alloc] initWithTitle:[sectionEl text]];
                                       } else if ([[sectionEl tagName] isEqualToString:@"table"]){
                                           IssueArticle *article = [[IssueArticle alloc] initWithElement: sectionEl];
                                           [section addArticle:article];
                                       }
                                   }
                                   if (section) {
                                       [sections addObject:section];
                                   }
                                   issue.sections = sections;
                                   [self updateCacheWithIssue:issue];
                                   
                               } else {
                                   
                                   
                                   NSLog(@"Other PHOTO response: %@", responseString);
                               }
                           }];
    
   
}

- (void)updateCacheWithIssue:(VolumeIssue *)issue
{
    NSString *cacheKey = [self cacheKeyForIssue:issue];
    [issue updateWithDictionary:(NSDictionary *)[[EGOCache documentsCache] objectForKey:cacheKey]];
    [self cacheIssue:issue];
}

- (void)cacheIssue:(VolumeIssue *)issue
{
    NSString *cacheKey = [self cacheKeyForIssue:issue];
    [[EGOCache documentsCache] setObject:[issue dictionary] forKey:cacheKey withTimeoutInterval:NSUIntegerMax];
}


- (void)getPdfForIssue:(VolumeIssue *)issue article:(IssueArticle *)article success:(void(^)(NSString *fileURL))success
{
    NSMutableURLRequest *request = [self GETRequestForEndpoint:nil];
    [request setURL:[NSURL URLWithString:article.pdfURL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                               NSDictionary *headers  = [httpResponse allHeaderFields];
                               
                               if([httpResponse statusCode] == 200){
                                   NSLog(@"200 PDF response");

                                   NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                   NSString *dfp = [searchPaths objectAtIndex: 0];
                                   
                                   NSString *filename = [NSString stringWithFormat:@"%@.pdf", [[self class] md5HexDigest:article.pdfURL]];
                                   NSString *filePath = [dfp stringByAppendingPathComponent:filename];
                                   NSFileManager *NSFM = [[NSFileManager alloc] init];
                                   [NSFM createFileAtPath:filePath
                                                 contents:data
                                               attributes:nil];

                                   article.pdfFileURL = filePath;
                                   [self cacheIssue:issue];
                                   
                                   if (success) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           success(filePath);
                                       });
                                   }
                               } else {
                                   NSLog(@"pdf download fail");
                               }
                           }];
}

+ (NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
