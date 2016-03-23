//
//  BXCalendar.h
//  BXCalendar
//
//  Created by bianxiang on 16/3/23.
//  Copyright © 2016年 bianxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Sure)(NSString *dateStr);

@interface BXCalendar : UIView



- (instancetype)initWithFrame:(CGRect)frame Sure:(Sure)sure;

@end
