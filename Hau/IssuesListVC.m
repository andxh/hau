//
//  IssuesListVC.m
//  Hau
//
//  Created by Andrew on 7/6/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "IssuesListVC.h"
#import "JournalVolume.h"
#import "VolumeIssue.h"
#import "ArchiveC.h"

@interface IssuesListVC ()<VolumeWatcher>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *issues;

@end

@implementation IssuesListVC

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
    [[ArchiveC ArchiveController] registerVolumeWatcher:self];
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
    JournalVolume *jv = self.volumes[section];
    return jv.issues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const kCellIdentifier = @"IssueCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }

    JournalVolume *jv = self.volumes[indexPath.section];
    
    cell.textLabel.text = [(VolumeIssue *)jv.issues[indexPath.row] title];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.volumes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    JournalVolume *jv = self.volumes[section];
    return jv.volumeYear;
}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate performSelector:@selector(showVolumeIssueAtPath:) withObject:indexPath];
}

#pragma mark VolumeWatcher protocol method
-(void)didUpdateVolume:(JournalVolume *)volume
{
    [self.tableView reloadData];
}

-(void)didUpdateVolumes:(NSArray *)volumes
{
    self.volumes = volumes;
    [self.tableView reloadData];
}
@end
