//
//  BBUTextViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 17.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUTextViewController.h"

@interface BBUTextViewController ()

@property (strong) UITextView* textView;

@end

#pragma mark -

@implementation BBUTextViewController

-(void)showTextFromBundleResource:(NSString *)resource ofType:(NSString *)type {
    NSString* path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    self.textView.text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.editable = NO;
    self.textView.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:self.textView];
}

@end
