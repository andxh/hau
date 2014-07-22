//
//  IssueTableOfContentsVC.m
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "IssueTableOfContentsVC.h"
#import "VolumeIssue.h"
#import "IssueSection.h"
#import "IssueArticle.h"
#import "IssueTableOfContentsTVCell.h"
#import "LoadingTVCell.h"
#import "ArchiveC.h"

@interface IssueTableOfContentsVC ()<IssueWatcher>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

static NSString *const kCellIdentifier = @"ArticleCell";
static NSString *const kLoadingCellIdentifier = @"LoadingCell";

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
    
    UIBarButtonItem *loadAllPDF = [[UIBarButtonItem alloc] initWithTitle:@"Load All"
                                                                   style:UIBarButtonItemStyleBordered target:self action:@selector(loadAll)];
    
    self.navigationItem.rightBarButtonItem = loadAllPDF;
    
    // Tableview Cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([IssueTableOfContentsTVCell class])  bundle:nil]
         forCellReuseIdentifier:kCellIdentifier];

    // Loading TVCell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadingTVCell class])  bundle:nil]
         forCellReuseIdentifier:kLoadingCellIdentifier];
    
    [[ArchiveC ArchiveController] registerIssueWatcher:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadAll
{
    [[ArchiveC ArchiveController] getAllArticlesForIssue:self.issue];
}


#pragma TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.issue.sections.count == 0){
        return 1;
    } else {
        return ((IssueSection *)self.issue.sections[section]).articles.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.issue.sections.count == 0) {
        LoadingTVCell *cell = (LoadingTVCell *)[tableView dequeueReusableCellWithIdentifier:kLoadingCellIdentifier];
        return cell;
    } else {
        IssueTableOfContentsTVCell *cell = (IssueTableOfContentsTVCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        
        IssueArticle *article = ((IssueSection *)self.issue.sections[indexPath.section]).articles[indexPath.row];
        
        cell.titleLabel.text = article.title;
        cell.authorsLabel.text = article.author;
        cell.pagesLabel.text = article.pages;
        [cell setPdfFileURL:article.pdfFileURL];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.issue.sections.count == 0) {
        return 1;
    } else {
        return self.issue.sections.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    JournalVolume *jv = self.volumes[section];
//    return jv.volumeYear;
    if (self.issue.sections.count == 0) {
        return @"Loading...";
    } else {
        return ((IssueSection *)self.issue.sections[section]).title;
    }
}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.issue.sections.count > 0) {
        [self.delegate performSelector:@selector(showIssue:articleAtPath:) withObject:self.issue withObject:indexPath];
    }
}

#pragma mark IssueWatcher protocol methods
- (void)didUpdateIssue:(VolumeIssue *)issue
{
    [self.tableView reloadData];
}

@end
