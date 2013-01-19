//
//  BBUUserListViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 17.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUGalleryViewController.h"
#import "BBUUserListViewController.h"
#import "DesktopprUser.h"
#import "UIImageView+AFNetworking.h"

static NSString* const kCellIdentifier = @"UserCellIdentifier";

@interface BBUUserListViewController () <UITableViewDataSource, UITabBarDelegate>

@property (strong) NSArray* users;

@end

#pragma mark -

@implementation BBUUserListViewController

-(id)initWithUsers:(NSArray*)users {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"Following", nil);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        
        self.users = users;
    }
    return self;
}

#pragma mark - UITableViewDataSource methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    DesktopprUser* user = self.users[indexPath.row];
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:user.avatar_url]
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       cell.imageView.image = image;
                                       [cell setNeedsLayout];
                                   } failure:NULL];
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
    DesktopprUser* user = self.users[indexPath.row];
    BBUGalleryViewController* userGallery = [[BBUGalleryViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:userGallery animated:YES];
}

@end
