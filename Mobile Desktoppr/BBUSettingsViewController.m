//
//  BBUSettingsViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 17.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUAboutViewController.h"
#import "BBUSettingsViewController.h"
#import "BBUTextViewController.h"
#import "DesktopprWebService.h"
#import "DropboxSDK.h"
#import "MBProgressHUD.h"
#import "UIAlertView+BBU.h"

static NSString* const kCellIdentifier = @"SettingsCellIdentifier";

@interface BBUSettingsViewController () <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong) UIAlertView* alertView;

@end

#pragma mark -

@implementation BBUSettingsViewController

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString* username = [alertView textFieldAtIndex:0].text;
    NSString* password = [alertView textFieldAtIndex:1].text;
    
    if (buttonIndex > 0 && username && password) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[DesktopprWebService sharedService] loginWithUsername:username
                                                      password:password
                                         withCompletionHandler:^(DesktopprUser *user, NSError *error) {
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             
                                             if (!user) {
                                                 [UIAlertView bbu_showAlertWithError:error];
                                                 return;
                                             }
                                             
                                             [self.tableView reloadData];
                                         }];
    }
    
    self.alertView = nil;
}

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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([[DesktopprWebService sharedService] isLoggedIn]) {
                cell.textLabel.text = NSLocalizedString(@"Logout", nil);
            } else {
                cell.textLabel.text = NSLocalizedString(@"Login", nil);
            }
            break;
        case 1:
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.text = NSLocalizedString(@"License information", nil);
            break;
        case 2:
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.text = NSLocalizedString(@"About", nil);
            break;
        case 3:
            if ([[DBSession sharedSession] isLinked]) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = NSLocalizedString(@"Unlink Dropbox", nil);
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textLabel.text = NSLocalizedString(@"Link with Dropbox", nil);
            }
            break;
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            if ([[DesktopprWebService sharedService] isLoggedIn]) {
                [[DesktopprWebService sharedService] logout];
                [self.tableView reloadData];
                return;
            }
            
            self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login to Desktoppr", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            self.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            self.alertView.delegate = self;
            [self.alertView show];
            
            [self.alertView textFieldAtIndex:0].delegate = self;
            [self.alertView textFieldAtIndex:1].delegate = self;
            break;
        }
            
        case 1: {
            BBUTextViewController* licenseInfo = [BBUTextViewController new];
            licenseInfo.navigationItem.title = NSLocalizedString(@"License information", nil);
            [self.navigationController pushViewController:licenseInfo animated:YES];
            [licenseInfo showTextFromBundleResource:@"licenses" ofType:@"txt"];
            break;
        }
            
        case 2: {
            BBUAboutViewController* about = [BBUAboutViewController new];
            [self.navigationController pushViewController:about animated:YES];
            break;
        }
            
        case 3:
            if ([[DBSession sharedSession] isLinked]) {
                [[DBSession sharedSession] unlinkAll];
                [self.tableView reloadData];
            } else {
                [[DBSession sharedSession] linkFromController:self];
            }
            break;
    }
}

#pragma mark - UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!self.alertView) {
        return NO;
    }
    
    if (textField == [self.alertView textFieldAtIndex:0]) {
        [[self.alertView textFieldAtIndex:1] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
    } else {
        [self.alertView dismissWithClickedButtonIndex:1 animated:YES];
    }
    
    return YES;
}

@end
