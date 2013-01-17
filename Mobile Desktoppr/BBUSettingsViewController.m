//
//  BBUSettingsViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 17.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUSettingsViewController.h"
#import "BBUTextViewController.h"

static NSString* const kCellIdentifier = @"SettingsCellIdentifier";

@interface BBUSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

#pragma mark -

@implementation BBUSettingsViewController

-(id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"Settings", nil);
        
        self.tableView.backgroundColor = [UIColor lightTextColor];
        self.tableView.backgroundView = nil;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return self;
}

#pragma mark - UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Login", nil);
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"License information", nil);
            break;
        case 2:
            // TODO: Implement about screen
            cell.textLabel.alpha = 0.5;
            cell.textLabel.text = NSLocalizedString(@"About", nil);
            cell.userInteractionEnabled = NO;
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - UITableView delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1: {
            BBUTextViewController* licenseInfo = [BBUTextViewController new];
            licenseInfo.navigationItem.title = NSLocalizedString(@"License information", nil);
            [self.navigationController pushViewController:licenseInfo animated:YES];
            [licenseInfo showTextFromBundleResource:@"licenses" ofType:@"txt"];
            break;
        }
    }
}

@end
