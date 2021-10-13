//
//  D_ViewController.m
//  D_ImagePicker
//
//  Created by dingpengfei-bwf on 11/08/2018.
//  Copyright (c) 2018 dingpengfei-bwf. All rights reserved.
//

#import "D_ViewController.h"

@interface D_ViewController ()

@end

@implementation D_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *show = [UIButton buttonWithType:UIButtonTypeCustom];
    show.frame = CGRectMake(0, 100, self.view.frame.size.width, 50);
    [show setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [show setTitle:@"显示333" forState:UIControlStateNormal];
    [show addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
