//
//  IssueTableOfContentsVC.h
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VolumeIssue.h"

@interface IssueTableOfContentsVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) VolumeIssue *issue;

@end
