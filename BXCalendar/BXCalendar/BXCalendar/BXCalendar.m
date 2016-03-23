//
//  BXCalendar.m
//  BXCalendar
//
//  Created by bianxiang on 16/3/23.
//  Copyright © 2016年 bianxiang. All rights reserved.
//

#import "BXCalendar.h"
#import "JTCalendar.h"

@interface BXCalendar ()<JTCalendarDelegate>{
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_dateSelected;
    
    Sure _sure;
    Cancel _cancel;
}
@property (strong, nonatomic)  JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic)  JTCalendarWeekDayView *weekDayView;
@property (strong, nonatomic)  JTVerticalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@end

@implementation BXCalendar

- (instancetype)initWithFrame:(CGRect)frame Cancel:(Cancel)cancel Sure:(Sure)sure{
    if (self = [super initWithFrame:frame]) {
        _sure = sure;
        _cancel = cancel;
        [self addSubviewsWithFrame:frame];
        [self setupBXCalendar];
    }
    return self;
}

- (void)addSubviewsWithFrame:(CGRect)frame {
    self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(100, 0, frame.size.width-200, 44)];
    [self addSubview:self.calendarMenuView];
    
    self.weekDayView = [[JTCalendarWeekDayView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendarMenuView.frame), frame.size.width, 30)];
    self.weekDayView.backgroundColor = [UIColor colorWithWhite:0.741 alpha:1.000];
    [self addSubview:_weekDayView];
    
    self.calendarContentView = [[JTVerticalCalendarView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.weekDayView.frame), frame.size.width, frame.size.height-CGRectGetMaxY(self.weekDayView.frame))];
    [self addSubview:_calendarContentView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 50, 0, 50, 44)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
}

- (void)setupBXCalendar {
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    _calendarManager.settings.pageViewHaveWeekDaysView = NO;
    _calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    _calendarManager.settings.weekDayFormat = 0;
    
    
    _weekDayView.manager = _calendarManager;
    [_weekDayView reload];
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    //    _dateSelected = [NSDate date];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    
    [_calendarManager setDate:_dateSelected];
    [_calendarManager.contentView setDate:_dateSelected];
    
    _calendarMenuView.scrollView.scrollEnabled = NO;
}


#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    BOOL dayViewIsEqualToSelectedDay = [[[self dateFormatter] stringFromDate:_dateSelected] isEqualToString:[[self dateFormatter] stringFromDate:dayView.date]];
    
    // Hide if from another month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor =  dayViewIsEqualToSelectedDay  ?[UIColor blueColor]:[UIColor clearColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor blueColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        
        
        
        
        if (dayViewIsEqualToSelectedDay) {
            dayView.textLabel.textColor = [UIColor whiteColor];
            
        }else {
            
            dayView.textLabel.textColor = [UIColor blueColor];
            NSLog(@"-----%@",dayView.textLabel.text);
            
        }
        //        _previousDayView = dayView;
        
        
    }
    else{
        
        dayView.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    
    if (![self haveEventForDay:dayView.date] ) {
        return;
    }
    
    
    
    //    _previousDayView.circleView.hidden = YES;
    //    _previousDayView.circleView.backgroundColor = [UIColor clearColor];
    _dateSelected = dayView.date;
    NSLog(@"%@",_dateSelected);
    // Animation for the circleView
    
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy年MM月dd日";
    }
    
    return dateFormatter;
}
- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}
- (void)createRandomEvents {
    _eventsByDate = [NSMutableDictionary new];
    
    
    
    for(int i = 0; i < 5; ++i){
        
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(3600 * 24 * (i-1)) sinceDate:[NSDate date]];
        
        if (i == 0) {
            _dateSelected = randomDate;
            //            isSelected = YES;
        }
        
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        NSLog(@"随机时间%@",key);
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}

- (void)cancel {
    NSLog(@"取消");
    _cancel([[self dateFormatter] stringFromDate:_dateSelected]);
}

- (void)sure {
    NSLog(@"确定");
    //    NSLog(@"%@",[[self dateFormatter] stringFromDate:_dateSelected]);
    _sure([[self dateFormatter] stringFromDate:_dateSelected]);
}
@end
