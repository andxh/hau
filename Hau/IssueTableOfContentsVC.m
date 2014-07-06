//
//  IssueTableOfContentsVC.m
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "IssueTableOfContentsVC.h"
#import "VolumeIssue.h"

@interface IssueTableOfContentsVC ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) VolumeIssue *issue;

@end

@implementation IssueTableOfContentsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
