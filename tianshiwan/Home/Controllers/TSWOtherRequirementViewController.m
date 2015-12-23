//
//  TSWOtherRequirementViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/23.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWOtherRequirementViewController.h"
#import "TSWOtherRequirement.h"
@interface TSWOtherRequirementViewController ()
@property (nonatomic, strong) TSWOtherRequirement *otherDetail;
@property (nonatomic, strong) NSString *sid;

@property (nonatomic, strong) UILabel *typeT;
@property (nonatomic, strong) UILabel *statusT;

@property (nonatomic, strong) UILabel *submitTime;
@property (nonatomic, strong) UILabel *bottomStatus;

@property (nonatomic, strong) UIView *top;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation TSWOtherRequirementViewController
- (void)dealloc
{
    [_otherDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithOtherId:(NSString *)otherId {
    self = [super init];
    if (self) {
        self.sid = otherId;
        
        self.otherDetail = [[TSWOtherRequirement alloc] initWithBaseURL:TSW_API_BASE_URL path:[[OTHER_DETAIL stringByAppendingString:self.sid]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.otherDetail addObserver:self
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
    self.navigationBar.title = @"其他需求";
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
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f, width-2*12-2*15, 12.0f)];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    typeLabel.textColor = RGB(97, 97, 97);
    typeLabel.font = [UIFont systemFontOfSize:12.0f];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    typeLabel.text = @"需求类型:";
    typeLabel.numberOfLines = 0;
    [_top addSubview:typeLabel];
    
    _typeT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f, width-2*12-2*15, 12.0f)];
    _typeT.textAlignment = NSTextAlignmentLeft;
    _typeT.textColor = RGB(162, 162, 162);
    _typeT.font = [UIFont systemFontOfSize:12.0f];
    _typeT.backgroundColor = [UIColor clearColor];
    _typeT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _typeT.text = @"";
    _typeT.numberOfLines = 0;
    [_top addSubview:_typeT];
    
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+12.0f+15.0f, width-2*12-2*15, 12.0f)];
    statusLabel.textAlignment = NSTextAlignmentLeft;
    statusLabel.textColor = RGB(97, 97, 97);
    statusLabel.font = [UIFont systemFontOfSize:12.0f];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    statusLabel.text = @"需求描述:";
    statusLabel.numberOfLines = 0;
    [_top addSubview:statusLabel];
    
    _statusT = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f, 10.0f+12.0f+15.0f, width-2*12-2*15-60.0f, 12.0f)];
    _statusT.textAlignment = NSTextAlignmentLeft;
    _statusT.textColor = RGB(162, 162, 162);
    _statusT.font = [UIFont systemFontOfSize:12.0f];
    _statusT.backgroundColor = [UIColor clearColor];
    _statusT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent = @"";
    _statusT.text = titleContent;
    _statusT.numberOfLines = 0;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 2*12-2*15-60.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _statusT.frame = CGRectMake(15.0f+60.0f, 10.0f+12.0f+15.0f, titleSize.width, titleSize.height);
    [_top addSubview:_statusT];
    
    _top.frame = CGRectMake(12.0f, 18.0f, width-2*12.0f, 10.0f+12.0f+15.0f+titleSize.height+40.0f);
    
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
    [self.otherDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
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
        if (object == _otherDetail) {
            if (_otherDetail.isLoaded) {
                [self setDetail:_otherDetail];
            }
            else if (_otherDetail.error) {
                [self showErrorMessage:[_otherDetail.error localizedFailureReason]];
            }
        }    }
}

- (void)setDetail:(TSWOtherRequirement *)otherDetail{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    _otherDetail = otherDetail;
    
    // 设置所有控件的值
    _typeT.text = _otherDetail.typeName;
    _statusT.text = _otherDetail.requirementDesc;
    _statusT.numberOfLines = 0;
    CGSize titleSize = [_otherDetail.requirementDesc boundingRectWithSize:CGSizeMake(width - 2*12-2*15-60.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _statusT.frame = CGRectMake(15.0f+60.0f, 10.0f+12.0f+15.0f, titleSize.width, titleSize.height);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSDate *datea = [NSDate dateWithTimeIntervalSince1970:[_otherDetail.time doubleValue]];
    NSString *dateString = [formatter stringFromDate:datea];
    _submitTime.text = [[NSString alloc]initWithFormat:@"提交时间: %@",dateString];
    
    if(_otherDetail.status == 0){
        _bottomStatus.text = @"已提交";
    }else if(_otherDetail.status == 1){
        _bottomStatus.text = @"处理中";
    }else if(_otherDetail.status == 2){
        _bottomStatus.text = @"已完成";
    }else if(_otherDetail.status == 3){
        _bottomStatus.text = @"关闭";
    }
    
    _top.frame = CGRectMake(12.0f, 18.0f, width-2*12.0f, 10.0f+12.0f+15.0f+titleSize.height+40.0f);
    
    _bottom.frame = CGRectMake(15.0f, CGRectGetHeight(_top.frame)+12.0f+12.0f, width-2*15, 12.0f);
    
    _scrollView.contentSize = CGSizeMake(width,CGRectGetHeight(_top.frame)+12.0f+12.0f+12.0f);

    
}

@end
