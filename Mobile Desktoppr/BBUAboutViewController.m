//
//  BBUAboutViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 18.03.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUAboutViewController.h"

@implementation BBUAboutViewController

-(void)desktopprTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://desktoppr.co"]];
}

-(void)designerTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://donswelt.de"]];
}

-(void)devTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://buegling.com"]];
}

-(id)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"About", nil);
    }
    return self;
}

-(void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithRed:(0x12 / 255.0) green:(0x2c / 255.0) blue:(0x45 / 255.0) alpha:1.0];
    
    UIButton* devAvatar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [devAvatar addTarget:self action:@selector(devTapped) forControlEvents:UIControlEventTouchUpInside];
    [devAvatar setFrame:CGRectMake(20.0, 20.0, 70.0, 70.0)];
    [devAvatar setImage:[UIImage imageNamed:@"avatar_neonacho.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:devAvatar];
    
    UILabel* devLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(devAvatar.frame) + 20.0, devAvatar.y,
                                                                  200.0, devAvatar.height)];
    devLabel.backgroundColor = self.view.backgroundColor;
    devLabel.numberOfLines = 0;
    devLabel.text = NSLocalizedString(@"This fine app was written by Boris Bügling.", nil);
    devLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:devLabel];
    
    UIButton* designerAvatar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [designerAvatar addTarget:self action:@selector(designerTapped) forControlEvents:UIControlEventTouchUpInside];
    [designerAvatar setFrame:CGRectMake(20.0, CGRectGetMaxY(devAvatar.frame) + 20.0, 70.0, 70.0)];
    [designerAvatar setImage:[UIImage imageNamed:@"avatar_donswelt.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:designerAvatar];
    
    UILabel* designerLabel = [[UILabel alloc] initWithFrame:CGRectMake(devLabel.x, designerAvatar.y,
                                                                       devLabel.width, devLabel.height)];
    designerLabel.backgroundColor = self.view.backgroundColor;
    designerLabel.numberOfLines = 0;
    designerLabel.text = NSLocalizedString(@"The app icon was designed by Thorsten Hartmann.", nil);
    designerLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:designerLabel];
    
    UILabel* desktopprInfo = [[UILabel alloc] initWithFrame:CGRectMake(devAvatar.x, CGRectGetMaxY(designerAvatar.frame) + 20.0,
                                                                       CGRectGetMaxX(designerLabel.frame) - designerAvatar.x,
                                                                       90.0)];
    desktopprInfo.backgroundColor = self.view.backgroundColor;
    desktopprInfo.numberOfLines = 0;
    desktopprInfo.text = NSLocalizedString(@"This is a client application for the excellent Desktoppr service."
                                           " Made with love and cheese by @keithpitt and @mariovisic.", nil);
    desktopprInfo.textColor = [UIColor whiteColor];
    [self.view addSubview:desktopprInfo];
    
    UIImageView* desktopprLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"desktoppr_logo"]];
    [desktopprLogo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(desktopprTapped)]];
    desktopprLogo.userInteractionEnabled = YES;
    desktopprLogo.x = (self.view.width - desktopprLogo.width) / 2.0;
    desktopprLogo.y = CGRectGetMaxY(desktopprInfo.frame) + 20.0;
    [self.view addSubview:desktopprLogo];
}

@end
