//
//  TSWFinanceRequirementViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/23.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWFinanceRequirementViewController.h"
#import "TSWFinancingRequirement.h"

@interface TSWFinanceRequirementViewController ()
@property (nonatomic, strong) TSWFinancingRequirement *financeDetail;
@property (nonatomic, strong) NSString *sid;

@property (nonatomic, strong) UILabel *valuationT;
@property (nonatomic, strong) UILabel *amountT;
@property (nonatomic, strong) UILabel *currencyLabel;
@property (nonatomic, strong) UILabel *timeT;
@property (nonatomic, strong) UILabel *FAT;
@property (nonatomic, strong) UILabel *statusT;

@property (nonatomic, strong) UILabel *submitTime;
@property (nonatomic, strong) UILabel *bottomStatus;

@property (nonatomic, strong) UIView *top;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation TSWFinanceRequirementViewController
- (void)dealloc
{
    [_financeDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithFinanceId:(NSString *)financeId {
    self = [super init];
    if (self) {
        self.sid = financeId;
        
        self.financeDetail = [[TSWFinancingRequirement alloc] initWithBaseURL:TSW_API_BASE_URL path:[[FINANCE_DETAIL stringByAppendingString:self.sid]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.financeDetail addObserver:self
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
    self.navigationBar.title = @"融资需求";
    self.navigationBar.titleView.textColor = RGB(90, 90, 90);
    self.navigationBar.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.navigationBar.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    self.navigationBar.bottomLineView.hidden = YES;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height - self.navigationBarHeight)];
    _scrollView.backgroundColor = RGB(234, 234, 234);
    
    _top = [[UIView alloc]initWithFrame:CGRectMake(12.0f, 18.0f, width-2*12.0f, 400.0f)];
    _top.backgroundColor = [UIColor whiteColor];
    _top.layer.cornerRadius = 4.0;
    _top.layer.masksToBounds = YES;
    [_scrollView addSubview:_top];
    
    UILabel *valuationLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f, width-2*12-2*15, 12.0f)];
    valuationLabel.textAlignment = NSTextAlignmentLeft;
    valuationLabel.textColor = RGB(97, 97, 97);
    valuationLabel.font = [UIFont systemFontOfSize:12.0f];
    valuationLabel.backgroundColor = [UIColor clearColor];
    valuationLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    valuationLabel.text = @"目前估值:";
    valuationLabel.numberOfLines = 0;
    [_top addSubview:valuationLabel];
    
    _valuationT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f, width-2*12-2*15, 12.0f)];
    _valuationT.textAlignment = NSTextAlignmentLeft;
    _valuationT.textColor = RGB(162, 162, 162);
    _valuationT.font = [UIFont systemFontOfSize:12.0f];
    _valuationT.backgroundColor = [UIColor clearColor];
    _valuationT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _valuationT.text = @"";
    _valuationT.numberOfLines = 0;
    [_top addSubview:_valuationT];
    
    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    amountLabel.textAlignment = NSTextAlignmentLeft;
    amountLabel.textColor = RGB(97, 97, 97);
    amountLabel.font = [UIFont systemFontOfSize:12.0f];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    amountLabel.text = @"融资金额:";
    amountLabel.numberOfLines = 0;
    [_top addSubview:amountLabel];
    
    _amountT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    _amountT.textAlignment = NSTextAlignmentLeft;
    _amountT.textColor = RGB(162, 162, 162);
    _amountT.font = [UIFont systemFontOfSize:12.0f];
    _amountT.backgroundColor = [UIColor clearColor];
    _amountT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _amountT.text = @"";
    _amountT.numberOfLines = 0;
    [_top addSubview:_amountT];
    
    _currencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+120.0f, 10.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    _currencyLabel.textAlignment = NSTextAlignmentLeft;
    _currencyLabel.textColor = RGB(97, 97, 97);
    _currencyLabel.font = [UIFont systemFontOfSize:12.0f];
    _currencyLabel.backgroundColor = [UIColor clearColor];
    _currencyLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _currencyLabel.text = @"";
    _currencyLabel.numberOfLines = 0;
    [_top addSubview:_currencyLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+12.0f+15.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = RGB(97, 97, 97);
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    timeLabel.text = @"融资时间:";
    timeLabel.numberOfLines = 0;
    [_top addSubview:timeLabel];
    
    _timeT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+12.0f+15.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    _timeT.textAlignment = NSTextAlignmentLeft;
    _timeT.textColor = RGB(162, 162, 162);
    _timeT.font = [UIFont systemFontOfSize:12.0f];
    _timeT.backgroundColor = [UIColor clearColor];
    _timeT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _timeT.text = @"";
    _timeT.numberOfLines = 0;
    [_top addSubview:_timeT];
    
    UILabel *FALabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    FALabel.textAlignment = NSTextAlignmentLeft;
    FALabel.textColor = RGB(97, 97, 97);
    FALabel.font = [UIFont systemFontOfSize:12.0f];
    FALabel.backgroundColor = [UIColor clearColor];
    FALabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    FALabel.text = @"是否愿意采用FA:";
    FALabel.numberOfLines = 0;
    [_top addSubview:FALabel];
    
    _FAT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+100.0f, 10.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    _FAT.textAlignment = NSTextAlignmentLeft;
    _FAT.textColor = RGB(162, 162, 162);
    _FAT.font = [UIFont systemFontOfSize:12.0f];
    _FAT.backgroundColor = [UIColor clearColor];
    _FAT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _FAT.text = @"";
    _FAT.numberOfLines = 0;
    [_top addSubview:_FAT];
    
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    statusLabel.textAlignment = NSTextAlignmentLeft;
    statusLabel.textColor = RGB(97, 97, 97);
    statusLabel.font = [UIFont systemFontOfSize:12.0f];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    statusLabel.text = @"产品现状:";
    statusLabel.numberOfLines = 0;
    [_top addSubview:statusLabel];
    
    _statusT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f, width-2*12-2*15-60.0f, 12.0f)];
    _statusT.textAlignment = NSTextAlignmentLeft;
    _statusT.textColor = RGB(162, 162, 162);
    _statusT.font = [UIFont systemFontOfSize:12.0f];
    _statusT.backgroundColor = [UIColor clearColor];
    _statusT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent = @"";
    _statusT.text = titleContent;
    _statusT.numberOfLines = 0;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 2*12-2*15-60.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _statusT.frame = CGRectMake(15.0f+60.0f, 10.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f, titleSize.width, titleSize.height);
    [_top addSubview:_statusT];
    
    _top.frame = CGRectMake(12.0f, 18.0f, width-2*12.0f, 10.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+titleSize.height+40.0f);
    
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
    [self.financeDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
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
        if (object == _financeDetail) {
            if (_financeDetail.isLoaded) {
                [self setDetail:_financeDetail];
            }
            else if (_financeDetail.error) {
                [self showErrorMessage:[_financeDetail.error localizedFailureReason]];
            }
        }    }
}

- (void)setDetail:(TSWFinancingRequirement *)financeDetail{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    _financeDetail = financeDetail;
    
    // 设置所有控件的值
    _valuationT.text = [NSString stringWithFormat:@"%@", _financeDetail.valuation];
    _amountT.text = _financeDetail.amount;
    if([_financeDetail.amountType isEqualToString:@"rmb"]){
        _currencyLabel.text = @"人民币";
    }else{
        _currencyLabel.text = @"美元";
    }
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM"];
//    NSDate *datea = [NSDate dateWithTimeIntervalSince1970:[_financeDetail.start doubleValue]];
//    NSString *dateString = [formatter stringFromDate:datea];
    _timeT.text = _financeDetail.start;
    
    if(_financeDetail.fa == 1){
        _FAT.text = @"是";
    }else{
        _FAT.text = @"否";
    }
    
    _statusT.text = _financeDetail.projectStatus;
    _statusT.numberOfLines = 0;
    CGSize titleSize = [_financeDetail.projectStatus boundingRectWithSize:CGSizeMake(width - 2*12-2*15-60.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _statusT.frame = CGRectMake(15.0f+60.0f, 10.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f, titleSize.width, titleSize.height);
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSDate *datea1 = [NSDate dateWithTimeIntervalSince1970:[_financeDetail.time doubleValue]];
    NSString *dateString1 = [formatter1 stringFromDate:datea1];
    _submitTime.text = [[NSString alloc]initWithFormat:@"提交时间: %@",dateString1];
    
    if(_financeDetail.status == 0){
        _bottomStatus.text = @"已提交";
    }else if(_financeDetail.status == 1){
        _bottomStatus.text = @"处理中";
    }else if(_financeDetail.status == 2){
        _bottomStatus.text = @"已完成";
    }else if(_financeDetail.status == 3){
        _bottomStatus.text = @"关闭";
    }
    
    self.top.frame = CGRectMake(12.0f, 18.0f, width-2*12.0f, 10.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+titleSize.height+40.0f);
    self.bottom.frame = CGRectMake(15.0f, CGRectGetHeight(_top.frame)+12.0f+12.0f, width-2*15, 12.0f);
    self.scrollView.contentSize = CGSizeMake(width,CGRectGetHeight(self.top.frame)+12.0f+12.0f+12.0f);
}

@end
