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
#import "IssueTableOfContentsVC.h"
#import "IssueArticle.h"
#import "IssueSection.h"

@interface RootVC () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *pdfDocument;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
}

#pragma IBActions

- (IBAction)viewArchive:(id)sender
{
    IssuesListVC *vc = [[IssuesListVC alloc] initWithNibName:NSStringFromClass([IssuesListVC class]) bundle:nil];
    vc.volumes = [[ArchiveC ArchiveController] volumes];
    vc.delegate = self;
    [[self navigationController] pushViewController:vc animated:YES];
    [[self navigationController] setNavigationBarHidden:NO];
    
    [[ArchiveC ArchiveController] updateArchiveIndex];
}

- (IBAction)viewCurrent:(id)sender
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self showVolumeIssueAtPath:path];
}

- (void)showVolumeIssueAtPath:(NSIndexPath *)path
{
    NSLog(@"v %d, i %d", path.section, path.row);
    [[self navigationController] popToRootViewControllerAnimated:NO];
    
    // show issue ToC VC
    VolumeIssue *issue = [[ArchiveC ArchiveController] volumeIssue:path];
    
    IssueTableOfContentsVC *vc = [[IssueTableOfContentsVC alloc] initWithNibName:NSStringFromClass([IssueTableOfContentsVC class]) bundle:nil];
    vc.issue = issue;
    vc.delegate = self;

    [[self navigationController] pushViewController:vc animated:YES];
    [[self navigationController] setNavigationBarHidden:NO];

    [[ArchiveC ArchiveController] updateIssue:issue];
}

- (void)showIssue:(VolumeIssue *)issue articleAtPath:(NSIndexPath *)path
{
    // if we have the pdf, show it
    IssueArticle *article = (IssueArticle *)((IssueSection*)issue.sections[path.section]).articles[path.row];
    NSString *pdfFileURL = article.pdfFileURL;
    if( pdfFileURL ){
        [self showDoc:pdfFileURL];
    }
    // otherwise, download the pdf
    else {
        __weak RootVC *this = self;
        [[ArchiveC ArchiveController] getPdfForIssue:issue article:article success:^(NSString *fileURL) {
            [this showDoc: fileURL];
        }];
    }
}
- (void)showDoc:(NSString *)fileURL
{
    NSURL *targetURL = [NSURL fileURLWithPath:fileURL];
    
    self.pdfDocument = [UIDocumentInteractionController interactionControllerWithURL: targetURL];
    self.pdfDocument.delegate = self;
    
    [self.pdfDocument presentPreviewAnimated: YES];
}

-(UIViewController *)documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{
    return self;
}



@end
