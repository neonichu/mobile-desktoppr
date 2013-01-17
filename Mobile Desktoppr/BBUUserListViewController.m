//
//  BBUUserListViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 17.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUUserListViewController.h"
#import "DesktopprUser.h"

static NSString* const kCellIdentifier = @"UserCellIdentifier";

@interface BBUUserListViewController () <UITableViewDataSource, UITabBarDelegate>

@property (strong) NSArray* users;

@end

#pragma mark -

@implementation BBUUserListViewController

-(id)initWithUsers:(NSArray*)users {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"Users", nil);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        
        self.users = users;
    }
    return self;
}

#pragma mark - UITableViewDataSource methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    DesktopprUser* user = self.users[indexPath.row];
    // TODO: Show avatars
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = user.username;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableView delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Implement user page
}

@end
