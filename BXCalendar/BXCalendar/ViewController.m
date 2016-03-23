//
//  ViewController.m
//  BXCalendar
//
//  Created by bianxiang on 16/3/23.
//  Copyright © 2016年 bianxiang. All rights reserved.
//

#import "ViewController.h"
#import "BXCalendar.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BXCalendar *v = [[BXCalendar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260) Cancel:^(NSString *dateStr) {
        NSLog(@"%@",dateStr);
        
    } Sure:^(NSString *dateStr) {
        NSLog(@"%@",dateStr);
    
    }];
    [self.view addSubview:v];
}



@end
