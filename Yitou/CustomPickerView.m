//
//  CustomPickerView.m
//  ZJYG
//
//  Created by imac on 15/12/29.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//
#define currentMonth [currentMonthString integerValue]
#import "CustomPickerView.h"


@interface CustomPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    UIToolbar *toolbarCancelDone;
    UIPickerView *customPicker;
    
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    NSArray *amPmArray;
    NSArray *hoursArray;
    NSMutableArray *minutesArray;
    
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
    BlockCancel blockremove;
    BlockDone blockValue;
}

@end

@implementation CustomPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpToolBar];
        [self setUpPickView];
        
    }
    return self;
}

-(void)setUpToolBar{
    toolbarCancelDone=[self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    [self addSubview:toolbarCancelDone];
}

-(UIToolbar *)setToolbarStyle{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    toolbar.items=@[lefttem,centerSpace,right];
    return toolbar;
}

- (void)remove{
    blockremove();
}
- (void)doneClick{
    NSInteger monthint = [[monthArray objectAtIndex:[customPicker selectedRowInComponent:1]] integerValue];
    NSInteger dayint = [[DaysArray objectAtIndex:[customPicker selectedRowInComponent:2]] integerValue];
    NSString *time = [NSString stringWithFormat:@"%@%02ld%02ld",[yearArray objectAtIndex:[customPicker selectedRowInComponent:0]],(long)monthint,dayint];
      NSString *timeStr = [NSString stringWithFormat:@"%@-%02ld-%02ld",[yearArray objectAtIndex:[customPicker selectedRowInComponent:0]],(long)monthint,dayint];
    blockValue(time,timeStr);
}

- (void)CustomPickerViewCancelBlock:(BlockCancel)block{
    blockremove = block;
}

- (void)CustomPickerViewDoneBlock:(BlockDone)block{
    blockValue = block;
}

-(void)setUpPickView{
    customPicker = [[UIPickerView alloc] init];
    customPicker.backgroundColor = [UIColor colorWithRed:1.000 green:0.994 blue:0.982 alpha:1.000];
    customPicker.delegate=self;
    customPicker.dataSource=self;
    customPicker.frame=CGRectMake(0, 40, SCREENWidth, customPicker.frame.size.height);
    [self addSubview:customPicker];
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",[[formatter stringFromDate:date] integerValue]];
    
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%ld",[[formatter stringFromDate:date] integerValue]];
    
//    // Get Current  Hour
//    [formatter setDateFormat:@"HH"];
//    NSString *currentHourString = [NSString stringWithFormat:@"%tu",[[formatter stringFromDate:date]integerValue]];
//    
//    // Get Current  Minutes
//    [formatter setDateFormat:@"mm"];
//    NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // PickerView -  Years data
    yearArray = [[NSMutableArray alloc]init];
    
    for (int i = 2015; i <= 2050 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    // PickerView -  Months data
    monthArray =@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    // PickerView -  Hours data
    hoursArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    
    // PickerView -  Hours data
    minutesArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 60; i++)
    {
        
        [minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }
    
    // PickerView -  days data
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    // PickerView - Default Selection as per current Date
    
    [customPicker selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:YES];
    
    [customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    
    [customPicker selectRow:[DaysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
    
//    [customPicker selectRow:[hoursArray indexOfObject:currentHourString] inComponent:3 animated:YES];
//    
//    [customPicker selectRow:[minutesArray indexOfObject:currentMinutesString] inComponent:4 animated:YES];
}

#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component == 0)
    {
        selectedYearRow = row;
        [customPicker reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [customPicker reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [customPicker reloadAllComponents];
        
    }
    
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, SCREENWidth/5, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    if (component == 0)
    {
        pickerLabel.text = [NSString stringWithFormat:@"%@年",[yearArray objectAtIndex:row]]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text = [NSString stringWithFormat:@"%@月",[monthArray objectAtIndex:row]];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text = [NSString stringWithFormat:@"%@日",[DaysArray objectAtIndex:row]]; // Date
        
    }
    else if (component == 3)
    {
        pickerLabel.text = [NSString stringWithFormat:@"%@时",[hoursArray objectAtIndex:row]]; // Hours
    }
    else
    {
        pickerLabel.text =  [NSString stringWithFormat:@"%@分",[minutesArray objectAtIndex:row]]; // Mins
    }
    return pickerLabel;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 40;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [yearArray count];
    }
    else if (component == 1)
    {
        return [monthArray count];
    }
    else if (component == 2)
    {
        if (firstTimeLoad)
        {
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
        }
        else
        {
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
        }
    }
    else if (component == 3)
    {
        return 24;
    }
    else{
        return 60;
    }
}

-(void)setToolbarWithPickViewFrame{
    toolbarCancelDone.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 40);
}

@end
