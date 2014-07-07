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

@interface IssueTableOfContentsVC ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

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

#pragma TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //number of issues in volume
    return ((IssueSection *)self.issue.sections[section]).articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const kCellIdentifier = @"ArticleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    IssueArticle *article = ((IssueSection *)self.issue.sections[indexPath.section]).articles[indexPath.row];
    
    cell.textLabel.text = article.title;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.issue.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    JournalVolume *jv = self.volumes[section];
//    return jv.volumeYear;
    
    return ((IssueSection *)self.issue.sections[section]).title;
}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.delegate performSelector:@selector(showIssue:articleAtPath:) withObject:self.issue withObject:indexPath];
}
@end
