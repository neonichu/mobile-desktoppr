//
//  BBUFollowersViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 19.03.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUFollowersViewController.h"
#import "DesktopprWebService.h"
#import "MBProgressHUD.h"
#import "UIAlertView+BBU.h"

@interface BBUFollowersViewController ()

@property (strong) NSArray* followers;
@property (strong) NSArray* following;

@end

#pragma mark -

@implementation BBUFollowersViewController

-(id)initWithUsers:(NSArray *)users {
    self = [super initWithUsers:users];
    if (self) {
        self.following = users;
        
        UISegmentedControl* titleView = [[UISegmentedControl alloc] initWithItems:@[ NSLocalizedString(@"Followers", nil),
                                         NSLocalizedString(@"Following", nil) ]];
        titleView.segmentedControlStyle = UISegmentedControlStyleBar;
        titleView.selectedSegmentIndex = 1;
        self.navigationItem.titleView = titleView;
        
        [titleView addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)segmentedControlTapped:(UISegmentedControl*)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        if (self.followers) {
            self.users = self.followers;
            [self.tableView reloadData];
            return;
        }
        
        if (self.user) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [[DesktopprWebService sharedService] followersForUser:self.user
                                            withCompletionHandler:^(NSArray *objects, NSError *error) {
                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                
                                                if (!objects) {
                                                    [UIAlertView bbu_showAlertWithError:error];
                                                    return;
                                                }
                                                
                                                self.followers = objects;
                                                [self segmentedControlTapped:segmentedControl];
                                            }];
        }
        
        return;
    }
    
    self.users = self.following;
    [self.tableView reloadData];
}

@end
