//
//  ViewController.m
//  DesTest
//
//  Created by LinZehua on 13/11/15.
//  Copyright © 2015 LinZehua. All rights reserved.
//

#import "ViewController.h"
#import "ALAssetsLibraryExt.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GroupVC.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *groups;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initData
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    NSMutableArray *groups = [NSMutableArray array];
    
    // 1.遍历library
    ALAssetsLibrary *library = [ALAssetsLibrary defaultAssetsLibrary];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group != nil && group.numberOfAssets > 0) {
            [groups addObject:group];
        }
        
        if (stop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _groups = (NSMutableArray *)[[groups reverseObjectEnumerator] allObjects];
                [_tableView reloadData];
            });
        }
        
    } failureBlock:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"设置->隐私->照片 打开权限", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
        [alert show];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    ALAssetsGroup *group = _groups[indexPath.item];
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupVC *groupVC = (GroupVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"GroupVC"];
    groupVC.group = _groups[indexPath.item];
    [self.navigationController pushViewController:groupVC animated:YES];
}

@end
