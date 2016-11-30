//
//  TSWPersonelRequirementViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/23.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWPersonelRequirementViewController.h"
#import "TSWPersonelRequirement.h"
@interface TSWPersonelRequirementViewController ()
@property (nonatomic, strong) TSWPersonelRequirement *personnelDetail;
@property (nonatomic, strong) NSString *sid;

@property (nonatomic, strong) UILabel *positionT;
@property (nonatomic, strong) UILabel *cityT;
@property (nonatomic, strong) UILabel *numbersT;
@property (nonatomic, strong) UILabel *salaryT;
@property (nonatomic, strong) UILabel *HRpT;
@property (nonatomic, strong) UILabel *HReT;
@property (nonatomic, strong) UILabel *dutyT;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *statusT;

@property (nonatomic, strong) UILabel *submitTime;
@property (nonatomic, strong) UILabel *bottomStatus;

@property (nonatomic, strong) UIView *top;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation TSWPersonelRequirementViewController
- (void)dealloc
{
    [_personnelDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithPersonnelId:(NSString *)personnelId {
    self = [super init];
    if (self) {
        self.sid = personnelId;
        
        self.personnelDetail = [[TSWPersonelRequirement alloc] initWithBaseURL:TSW_API_BASE_URL path:[[PERSONNEL_DETAIL stringByAppendingString:self.sid]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.personnelDetail addObserver:self
                             forKeyPath:kResourceLoadingStatusKeyPath
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = @"人才需求";
//    self.navigationBar.titleView.textColor = RGB(90, 90, 90);
//    self.navigationBar.backgroundView.backgroundColor = [UIColor whiteColor];
//    [self.navigationBar.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    self.navigationBar.bottomLineView.hidden = YES;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height - self.navigationBarHeight)];
    _scrollView.backgroundColor = RGB(234, 234, 234);
    
    _top = [[UIView alloc]initWithFrame:CGRectMake(12.0f, 18.0f, width-2*12.0f, 400.0f)];
    _top.backgroundColor = [UIColor whiteColor];
    _top.layer.cornerRadius = 4.0;
    _top.layer.masksToBounds = YES;
    [_scrollView addSubview:_top];
    
    UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f, width-2*12-2*15, 12.0f)];
    positionLabel.textAlignment = NSTextAlignmentLeft;
    positionLabel.textColor = RGB(97, 97, 97);
    positionLabel.font = [UIFont systemFontOfSize:12.0f];
    positionLabel.backgroundColor = [UIColor clearColor];
    positionLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    positionLabel.text = @"岗位名称:";
    positionLabel.numberOfLines = 0;
    [_top addSubview:positionLabel];
    
    _positionT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f, width-2*12-2*15, 12.0f)];
    _positionT.textAlignment = NSTextAlignmentLeft;
    _positionT.textColor = RGB(162, 162, 162);
    _positionT.font = [UIFont systemFontOfSize:12.0f];
    _positionT.backgroundColor = [UIColor clearColor];
    _positionT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _positionT.text = @"";
    _positionT.numberOfLines = 0;
    [_top addSubview:_positionT];
    
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    cityLabel.textAlignment = NSTextAlignmentLeft;
    cityLabel.textColor = RGB(97, 97, 97);
    cityLabel.font = [UIFont systemFontOfSize:12.0f];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    cityLabel.text = @"职位城市:";
    cityLabel.numberOfLines = 0;
    [_top addSubview:cityLabel];
    
    _cityT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    _cityT.textAlignment = NSTextAlignmentLeft;
    _cityT.textColor = RGB(162, 162, 162);
    _cityT.font = [UIFont systemFontOfSize:12.0f];
    _cityT.backgroundColor = [UIColor clearColor];
    _cityT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _cityT.text = @"";
    _cityT.numberOfLines = 0;
    [_top addSubview:_cityT];
    
    UILabel *numbersLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+2*(12.0f+15.0f), width-2*12-2*15, 12.0f)];
    numbersLabel.textAlignment = NSTextAlignmentLeft;
    numbersLabel.textColor = RGB(97, 97, 97);
    numbersLabel.font = [UIFont systemFontOfSize:12.0f];
    numbersLabel.backgroundColor = [UIColor clearColor];
    numbersLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    numbersLabel.text = @"人数需求:";
    numbersLabel.numberOfLines = 0;
    [_top addSubview:numbersLabel];
    
    _numbersT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+2*(12.0f+15.0f), width-2*12-2*15, 12.0f)];
    _numbersT.textAlignment = NSTextAlignmentLeft;
    _numbersT.textColor = RGB(162, 162, 162);
    _numbersT.font = [UIFont systemFontOfSize:12.0f];
    _numbersT.backgroundColor = [UIColor clearColor];
    _numbersT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _numbersT.text = @"";
    _numbersT.numberOfLines = 0;
    [_top addSubview:_numbersT];
    
    UILabel *salaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+3*(12.0f+15.0f), width-2*12-2*15, 12.0f)];
    salaryLabel.textAlignment = NSTextAlignmentLeft;
    salaryLabel.textColor = RGB(97, 97, 97);
    salaryLabel.font = [UIFont systemFontOfSize:12.0f];
    salaryLabel.backgroundColor = [UIColor clearColor];
    salaryLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    salaryLabel.text = @"薪资范畴:";
    salaryLabel.numberOfLines = 0;
    [_top addSubview:salaryLabel];
    
    _salaryT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+3*(12.0f+15.0f), width-2*12-2*15, 12.0f)];
    _salaryT.textAlignment = NSTextAlignmentLeft;
    _salaryT.textColor = RGB(162, 162, 162);
    _salaryT.font = [UIFont systemFontOfSize:12.0f];
    _salaryT.backgroundColor = [UIColor clearColor];
    _salaryT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _salaryT.text = @"";
    _salaryT.numberOfLines = 0;
    [_top addSubview:_salaryT];
    
    UILabel *HRpLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+4*(12.0f+15.0f), width-2*12-2*15, 12.0f)];
    HRpLabel.textAlignment = NSTextAlignmentLeft;
    HRpLabel.textColor = RGB(97, 97, 97);
    HRpLabel.font = [UIFont systemFontOfSize:12.0f];
    HRpLabel.backgroundColor = [UIColor clearColor];
    HRpLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    HRpLabel.text = @"HR联系人:";
    HRpLabel.numberOfLines = 0;
    [_top addSubview:HRpLabel];
    
    _HRpT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+4*(12.0f+15.0f), width-2*12-2*15, 12.0f)];
    _HRpT.textAlignment = NSTextAlignmentLeft;
    _HRpT.textColor = RGB(162, 162, 162);
    _HRpT.font = [UIFont systemFontOfSize:12.0f];
    _HRpT.backgroundColor = [UIColor clearColor];
    _HRpT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _HRpT.text = @"";
    _HRpT.numberOfLines = 0;
    [_top addSubview:_HRpT];
    
    UILabel *HReLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+5*(12.0f+15.0f), width-2*12-2*15, 12.0f)];
    HReLabel.textAlignment = NSTextAlignmentLeft;
    HReLabel.textColor = RGB(97, 97, 97);
    HReLabel.font = [UIFont systemFontOfSize:12.0f];
    HReLabel.backgroundColor = [UIColor clearColor];
    HReLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    HReLabel.text = @"HR邮箱:";
    HReLabel.numberOfLines = 0;
    [_top addSubview:HReLabel];
    
    _HReT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+5*(12.0f+15.0f), width-2*12-2*15, 12.0f)];
    _HReT.textAlignment = NSTextAlignmentLeft;
    _HReT.textColor = RGB(162, 162, 162);
    _HReT.font = [UIFont systemFontOfSize:12.0f];
    _HReT.backgroundColor = [UIColor clearColor];
    _HReT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _HReT.text = @"";
    _HReT.numberOfLines = 0;
    [_top addSubview:_HReT];
    
    UILabel *dutyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+6*(12.0f+15.0f), width-2*12-2*15, 12.0f)];
    dutyLabel.textAlignment = NSTextAlignmentLeft;
    dutyLabel.textColor = RGB(97, 97, 97);
    dutyLabel.font = [UIFont systemFontOfSize:12.0f];
    dutyLabel.backgroundColor = [UIColor clearColor];
    dutyLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dutyLabel.text = @"岗位职责:";
    dutyLabel.numberOfLines = 0;
    [_top addSubview:dutyLabel];
    
    _dutyT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+6*(12.0f+15.0f), width-2*12-2*15-60.0f, 12.0f)];
    _dutyT.textAlignment = NSTextAlignmentLeft;
    _dutyT.textColor = RGB(162, 162, 162);
    _dutyT.font = [UIFont systemFontOfSize:12.0f];
    _dutyT.backgroundColor = [UIColor clearColor];
    _dutyT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent = @"";
    _dutyT.text = titleContent;
    _dutyT.numberOfLines = 0;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 2*12-2*15-60.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _dutyT.frame = CGRectMake(15.0f+60.0f, 10.0f+6*(12.0f+15.0f), titleSize.width, titleSize.height);
    [_top addSubview:_dutyT];
    
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+6*(12.0f+15.0f)+CGRectGetHeight(_dutyT.frame), width-2*12-2*15, 12.0f)];
    _statusLabel.textAlignment = NSTextAlignmentLeft;
    _statusLabel.textColor = RGB(97, 97, 97);
    _statusLabel.font = [UIFont systemFontOfSize:12.0f];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _statusLabel.text = @"任职要求:";
    _statusLabel.numberOfLines = 0;
    [_top addSubview:_statusLabel];
    
    _statusT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+6*(12.0f+15.0f)+CGRectGetHeight(_dutyT.frame), width-2*12-2*15-60.0f, 12.0f)];
    _statusT.textAlignment = NSTextAlignmentLeft;
    _statusT.textColor = RGB(162, 162, 162);
    _statusT.font = [UIFont systemFontOfSize:12.0f];
    _statusT.backgroundColor = [UIColor clearColor];
    _statusT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent2 = @"";
    _statusT.text = titleContent2;
    _statusT.numberOfLines = 0;
    CGSize titleSize2 = [titleContent2 boundingRectWithSize:CGSizeMake(width - 2*12-2*15-60.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _statusT.frame = CGRectMake(15.0f+60.0f, 10.0f+6*(12.0f+15.0f)+CGRectGetHeight(_dutyT.frame), titleSize2.width, titleSize2.height);
    [_top addSubview:_statusT];
    
    _top.frame = CGRectMake(12.0f, 18.0f, width-2*12.0f, 10.0f+6*(12.0f+15.0f)+titleSize.height+titleSize2.height+40.0f);
    
    _bottom = [[UIView alloc]initWithFrame:CGRectMake(15.0f, CGRectGetHeight(_top.frame)+12.0f+12.0f, width-2*15, 12.0f)];
    _bottom.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_bottom];
    _submitTime = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, width-2*15-50.0f, 12.0f)];
    _submitTime.textAlignment = NSTextAlignmentLeft;
    _submitTime.textColor = RGB(120, 120, 120);
    _submitTime.font = [UIFont systemFontOfSize:12.0f];
    _submitTime.backgroundColor = [UIColor clearColor];
    _submitTime.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _submitTime.text = @"";
    _submitTime.numberOfLines = 0;
    [_bottom addSubview:_submitTime];
    
    _bottomStatus = [[UILabel alloc]initWithFrame:CGRectMake(width-2*15-50, 0.0f, 50.0f, 12.0f)];
    _bottomStatus.textAlignment = NSTextAlignmentRight;
    _bottomStatus.textColor = RGB(120, 120, 120);
    _bottomStatus.font = [UIFont systemFontOfSize:12.0f];
    _bottomStatus.backgroundColor = [UIColor clearColor];
    _bottomStatus.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _bottomStatus.text = @"";
    _bottomStatus.numberOfLines = 0;
    [_bottom addSubview:_bottomStatus];
    
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(width,CGRectGetHeight(_top.frame)+12.0f+12.0f+12.0f);
    
    [self refreshData];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) refreshData{
    [self.personnelDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _personnelDetail) {
            if (_personnelDetail.isLoaded) {
                [self setDetail:_personnelDetail];
            }
            else if (_personnelDetail.error) {
                [self showErrorMessage:[_personnelDetail.error localizedFailureReason]];
            }
        }    }
}

- (void)setDetail:(TSWPersonelRequirement *)personnelDetail{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    _personnelDetail = personnelDetail;
    
    // 设置所有控件的值
    _positionT.text = _personnelDetail.name;
    _cityT.text = _personnelDetail.cityName;
    _numbersT.text = _personnelDetail.amount;
    _salaryT.text = _personnelDetail.salary;
    _HRpT.text = _personnelDetail.hr;
    _HReT.text = _personnelDetail.hrEmail;
    _dutyT.text = _personnelDetail.responsibility;
    _dutyT.numberOfLines = 0;
    CGSize titleSize = [_personnelDetail.responsibility boundingRectWithSize:CGSizeMake(width - 2*12-2*15-60.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _dutyT.frame = CGRectMake(15.0f+60.0f, 10.0f+6*(12.0f+15.0f), titleSize.width, titleSize.height);
    
    _statusT.text = _personnelDetail.requirements;
    _statusT.numberOfLines = 0;
    CGSize titleSize2 = [_personnelDetail.requirements boundingRectWithSize:CGSizeMake(width - 2*12-2*15-60.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _statusT.frame = CGRectMake(15.0f+60.0f, 10.0f+6*(12.0f+15.0f)+CGRectGetHeight(_dutyT.frame), titleSize2.width, titleSize2.height);
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSDate *datea1 = [NSDate dateWithTimeIntervalSince1970:[_personnelDetail.time doubleValue]];
    NSString *dateString1 = [formatter1 stringFromDate:datea1];
    _submitTime.text = [[NSString alloc]initWithFormat:@"提交时间: %@",dateString1];
    
    if(_personnelDetail.status == 0){
        _bottomStatus.text = @"已提交";
    }else if(_personnelDetail.status == 1){
        _bottomStatus.text = @"处理中";
    }else if(_personnelDetail.status == 2){
        _bottomStatus.text = @"已完成";
    }else if(_personnelDetail.status == 3){
        _bottomStatus.text = @"关闭";
    }
    
    _statusLabel.frame = CGRectMake(15.0f, 10.0f+6*(12.0f+15.0f)+CGRectGetHeight(_dutyT.frame), width-2*12-2*15, 12.0f);
    
    _top.frame = CGRectMake(12.0f, 18.0f, width-2*12.0f, 10.0f+6*(12.0f+15.0f)+titleSize.height+titleSize2.height+40.0f);
    
    _bottom.frame = CGRectMake(15.0f, CGRectGetHeight(_top.frame)+12.0f+12.0f, width-2*15, 12.0f);
    
    _scrollView.contentSize = CGSizeMake(width,CGRectGetHeight(_top.frame)+12.0f+12.0f+12.0f);
}

@end
