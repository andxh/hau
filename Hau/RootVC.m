//
//  RootVC.m
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "RootVC.h"
#import "ArchiveC.h"
#import "IssuesListVC.h"

@interface RootVC ()

- (IBAction)viewArchive:(id)sender;
- (IBAction)viewCurrent:(id)sender;

@end

@implementation RootVC

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


#pragma IBActions

- (IBAction)viewArchive:(id)sender
{
    IssuesListVC *vc = [[IssuesListVC alloc] initWithNibName:NSStringFromClass([IssuesListVC class]) bundle:nil];
    vc.volumes = [[ArchiveC ArchiveController] volumes];
    [[self navigationController] pushViewController:vc animated:YES];
    [[self navigationController] setNavigationBarHidden:NO];
    
    [[ArchiveC ArchiveController] updateArchiveIndex];
}

- (IBAction)viewCurrent:(id)sender
{
    
}


@end
