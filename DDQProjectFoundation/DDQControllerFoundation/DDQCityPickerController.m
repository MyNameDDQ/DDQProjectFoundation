//
//  DDQCityPickerController.m
//  DDQProjectEdit
//
//  Copyright © 2017年 DDQ. All rights reserved.


#import "DDQCityPickerController.h"

#import "UIView+DDQSimplyGetViewProperty.h"

@interface DDQCityPickerController ()<UIPickerViewDelegate, UIPickerViewDataSource> {
    
    UIView *_picker_topSeparatorLine;
    UIView *_picker_bottomSeparatorLine;
    DDQRateSet _rateSet;
    NSString *_selectContent;
}

@property (nonatomic, copy) NSArray *picker_dataSource;

@end

@implementation DDQCityPickerController

- (instancetype)init {
    
    self = [super init];
    
    //Subviews
    [self picker_layoutSubviews];

    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.picker_separatorColor = kSetColor(235.0, 235.0, 235.0, 1.0);
    _rateSet = [UIView view_getCurrentDeviceRateWithVersion:DDQFoundationRateDevice_iPhone6];

    //DataSource
    [self picker_reloadDataSource];

}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    CGFloat pickerH = 150.0 * _rateSet.widthRate;;
    self.picker_pickerView.frame = CGRectMake(0.0, self.view.height - pickerH, self.view.width, pickerH);

    CGFloat toolBarH = 35.0 * _rateSet.widthRate;
    CGFloat toolBarY = self.picker_pickerView.y - toolBarH;
    self.picker_toolBar.frame = CGRectMake(0.0, toolBarY, self.view.width, toolBarH);

    CGFloat horMargin = 12.0 * _rateSet.widthRate;
    CGFloat buttonW = 45.0 * _rateSet.widthRate;
    CGFloat buttonH = 30.0 * _rateSet.widthRate;
    CGFloat buttonY = CGRectGetMidY(self.picker_toolBar.bounds) - buttonH * 0.5;
    self.picker_cancelButton.frame = CGRectMake(horMargin, buttonY, buttonW, buttonH);
    
    CGFloat sureX = self.picker_toolBar.width - buttonW - horMargin;
    self.picker_sureButton.frame = CGRectMake(sureX, buttonY, buttonW, buttonH);
    
    CGFloat pickerW = CGRectGetWidth(self.picker_pickerView.bounds);
    _picker_topSeparatorLine.frame = CGRectMake(0.0, pickerH * 0.5 - RowHeight * 0.5 - 1.0, pickerW, 1);
    _picker_bottomSeparatorLine.frame = CGRectMake(0.0, pickerH * 0.5 + RowHeight * 0.5 + 1.0, pickerW, 1);
}

/** 布局子视图 */
- (void)picker_layoutSubviews {
    
    self.picker_toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.picker_toolBar];
    self.picker_toolBar.backgroundColor = [UIColor colorWithRed:235.0 /255.0 green:235.0 / 255.0 blue:235.0 / 255.0 alpha:1.0];
    
    self.picker_pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.picker_pickerView];
    self.picker_pickerView.delegate = self;
    self.picker_pickerView.dataSource = self;

    UIFont *buttonFont = [UIFont systemFontOfSize:15.0];
    self.picker_cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.picker_toolBar addSubview:self.picker_cancelButton];
    [self.picker_cancelButton addTarget:self action:@selector(picker_didSelectCancelWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.picker_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.picker_cancelButton setTitleColor:kSetColor(105.0, 105.0, 105.0, 1.0) forState:UIControlStateNormal];
    self.picker_cancelButton.titleLabel.font = buttonFont;
    
    self.picker_sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.picker_toolBar addSubview:self.picker_sureButton];
    [self.picker_sureButton addTarget:self action:@selector(picker_didSelectSureWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.picker_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.picker_sureButton setTitleColor:kSetColor(63.0, 204.0, 203.0, 1.0) forState:UIControlStateNormal];
    self.picker_sureButton.titleLabel.font = buttonFont;

    if (!self.showCustomSeparator) return;
    
    _picker_topSeparatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    [self.picker_pickerView addSubview:_picker_topSeparatorLine];
    _picker_topSeparatorLine.backgroundColor = self.picker_separatorColor;
    
    _picker_bottomSeparatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    [self.picker_pickerView addSubview:_picker_bottomSeparatorLine];
    _picker_bottomSeparatorLine.backgroundColor = self.picker_separatorColor;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(picker_didSelectCityPickerWithController:)]) {
        [self.delegate picker_didSelectCityPickerWithController:self];
    }
}

/** 点击取消按钮 */
- (void)picker_didSelectCancelWithButton:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(picker_didSelectCancelWithController:)]) {
        [self.delegate picker_didSelectCancelWithController:self];
    }
}

/** 点击确认按钮 */
- (void)picker_didSelectSureWithButton:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(picker_didSelectSureWithController:)]) {
        [self.delegate picker_didSelectSureWithController:self];
    }
}

/** 读取数据源 */
- (void)picker_reloadDataSource {
    
    //如果设置过数据源则不读取数据
    if (self.picker_dataSource.count > 0) return;
    
    NSString *filePath = DDQ_DEFAULT_SOURCE_FILEPATH(@"jd-area", @"json");
    if (!filePath) return;
    
    NSData *provinceData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *provinceDic = [NSJSONSerialization JSONObjectWithData:provinceData options:NSJSONReadingMutableContainers error:nil];
    self.picker_dataSource = provinceDic[@"info"];
}

- (NSString *)picker_content {
    
    NSInteger provinceRow = [self.picker_pickerView selectedRowInComponent:0];
    NSDictionary *provinceDic = self.picker_dataSource[provinceRow];
    
    NSInteger cityRow = [self.picker_pickerView selectedRowInComponent:1];
    NSDictionary *cityDic = provinceDic[@"children"][cityRow];
    
    NSInteger areaRow = [self.picker_pickerView selectedRowInComponent:2];
    NSDictionary *areaDic = cityDic[@"children"][areaRow];
    
    return [NSString stringWithFormat:@"%@ %@ %@", [provinceDic valueForKey:@"name"], [cityDic valueForKey:@"name"], [areaDic valueForKey:@"name"]];
}

#pragma mark - Picker Delegate && DataSource
static CGFloat const RowHeight = 30.0;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    //获取当前省份的row
    NSInteger provinceRow = [pickerView selectedRowInComponent:0];
    NSDictionary *provinceDic = self.picker_dataSource[provinceRow];
    if (component == 0) {
        
        return self.picker_dataSource.count;
    } else if (component == 1) {
        
        NSArray *cityArray = [provinceDic valueForKey:@"children"];
        return cityArray.count;
    } else {
        
        NSInteger cityRow = [pickerView selectedRowInComponent:1];
        NSArray *cityArray = [provinceDic valueForKey:@"children"];
        
        NSArray *areaArray = nil;
        if (cityRow <= cityArray.count - 1) {
            areaArray = cityArray[cityRow][@"children"];
        }
        return areaArray.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
    label.frame = CGRectMake(0, 0, CGRectGetWidth(pickerView.frame) * 0.33333333, RowHeight * _rateSet.widthRate);
    
    NSString *text = nil;
    //PS:pickerview 因为他有滑动的延时性，必须各种防越界。
    if (component == 0) {//省份
        
        NSDictionary *provinceDic = self.picker_dataSource[row];
        text = provinceDic[@"name"];
    } else if (component == 1) {//市区
        
        NSInteger provinceRow = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDic = self.picker_dataSource[provinceRow];
        NSArray *cityArray = [provinceDic valueForKey:@"children"];
        
        NSDictionary *cityDic;
        if (row <= cityArray.count - 1) {
            cityDic = cityArray[row];
        }
        text = cityDic[@"name"];
    } else {//区县
        
        NSInteger provinceRow = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDic = self.picker_dataSource[provinceRow];
        
        NSInteger cityRow = [pickerView selectedRowInComponent:1];
        NSArray *cityArray = [provinceDic valueForKey:@"children"];
        
        NSArray *areaArray;
        if (cityRow <= cityArray.count - 1) {
            areaArray = cityArray[cityRow][@"children"];
        }
        
        NSDictionary *areaDic;
        if (row <= areaArray.count - 1) {
            areaDic = areaArray[row];
        }
        text = areaDic[@"name"];
    }
    
    label.text = text;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return CGRectGetWidth(pickerView.frame) * 0.33333333;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return RowHeight * _rateSet.widthRate;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    } else if (component == 1) {
        
        [pickerView reloadComponent:2];
    }
}
@end
