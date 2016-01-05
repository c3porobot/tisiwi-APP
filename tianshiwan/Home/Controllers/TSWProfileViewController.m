//
//  TSWProfileViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWProfileViewController.h"
#import "TSWEditProfileViewController.h"
#import "TSWMyRequirementsViewController.h"
#import "TSWMyProjectsViewController.h"
#import "TSWSettingsViewController.h"
#import "TSWProfile.h"
/**
 *第一界面导航栏右边的按钮,个人中心
 */
@interface TSWProfileViewController ()

@property (nonatomic, strong) UIView *details;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) TSWProfile *profile;

@property (nonatomic, strong) UIImageView *face;  //头像
@property (nonatomic, strong) UIImageView *dFace; //详情头像
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLB;
@property (nonatomic, strong) UILabel *companyLB;

@property (nonatomic, strong) UILabel *dNameLabel;
@property (nonatomic, strong) UILabel *dPositionLabel;
@property (nonatomic, strong) UILabel *dCompanyLabel;
@property (nonatomic, strong) UILabel *dPhoneT;
@property (nonatomic, strong) UILabel *dEmailT;
@property (nonatomic, strong) UILabel *dWechatT;
@property (nonatomic, strong) UILabel *dCityT;
@property (nonatomic, strong) UILabel *dAddressT;

@property (nonatomic, strong) UIView *lineView3;
@property (nonatomic, strong) UIView *lineView4;

@property (nonatomic, strong) UILabel *myProjectLabel; //我的项目
@property (nonatomic, strong) UILabel *myRequireLabel; //我的需求
@property (nonatomic, strong) UILabel *settigLabel;    //设置

@property (nonatomic, strong) UIView *myProjects;
@property (nonatomic, strong) UIView *myRequirements;
@property (nonatomic, strong) UIView *setting;

@end

@implementation TSWProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = @"";
    self.navigationBar.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.navigationBar.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [self addRightNavigatorButton];
    self.view.backgroundColor = [UIColor whiteColor];
    //头像
    UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height - self.navigationBarHeight)];
    UIImage *image = [UIImage imageNamed:@"default_face"];
    _face = [[UIImageView alloc]initWithImage:image];
    _face.frame = CGRectMake((width - 60)/2, 20.0f, 60.0f, 60.0f);
    _face.layer.masksToBounds = YES; //设置圆角
    _face.layer.cornerRadius = 30;
    [top addSubview:_face];
    //姓名
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 20.0f + 60.0f + 10.0f, width, 16.0f)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = RGB(97, 97, 97);
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    _nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _nameLabel.text = @"";
    _nameLabel.numberOfLines = 0;
    [top addSubview:_nameLabel];
    //职位
    _positionLB = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 20.0f + 60.0f + 10.0f+ 16.0f + 8.0f, width, 12.0f)];
    _positionLB.textAlignment = NSTextAlignmentCenter;
    _positionLB.textColor = RGB(110, 110, 110);
    _positionLB.font = [UIFont systemFontOfSize:12.0f];
    _positionLB.backgroundColor = [UIColor clearColor];
    _positionLB.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _positionLB.text = @"";
    _positionLB.numberOfLines = 0;
    [top addSubview:_positionLB];
    //公司
    _companyLB = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 20.0f + 60.0f + 10.0f + 16.0 + 8.0f + 12.0f + 8.0f, width, 12.0f)];
    _companyLB.textAlignment = NSTextAlignmentCenter;
    _companyLB.textColor = RGB(110, 110, 110);
    _companyLB.font = [UIFont systemFontOfSize:12.0f];
    _companyLB.backgroundColor = [UIColor clearColor];
    _companyLB.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _companyLB.text = @"";
    _companyLB.numberOfLines = 0;
    [top addSubview:_companyLB];
    
    // 添加我的项目、我的需求、设置等元素
    
    UIView *center = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 20.0f+60.0f+10.0f+16.0f+8.0f+12.0f+8.0f+12.0f+220.0f, width, 200.0f)];
    _myProjects = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, width/3, 200.0f)];
    UIImage *projectImage = [UIImage imageNamed:@"project"];
    UIImageView *projectImageView = [[UIImageView alloc]initWithImage:projectImage];
    projectImageView.frame = CGRectMake((width/3 - 44)/2, 0.0f, 44.0f, 44.0f);
    [_myProjects addSubview:projectImageView];
    self.myProjectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 30.0f, width/3, 40.0f)];
    _myProjectLabel.textAlignment = NSTextAlignmentCenter;
    _myProjectLabel.textColor = RGB(110, 110, 110);
    _myProjectLabel.font = [UIFont systemFontOfSize:12.0f];
    _myProjectLabel.backgroundColor = [UIColor clearColor];
    _myProjectLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _myProjectLabel.text = @"我的项目";
    _myProjectLabel.numberOfLines = 0;
    [_myProjects addSubview:_myProjectLabel];
    /**
     *添加手势
     */
    UITapGestureRecognizer *myProjectsTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(projectButtonClicked:)];
    [_myProjects addGestureRecognizer:myProjectsTapGesture];
    [center addSubview:_myProjects];
    
    _myRequirements = [[UIView alloc]initWithFrame:CGRectMake(width/3, 0.0f, width/3, 200.0f)];
    UIImage *image2 = [UIImage imageNamed:@"requirement"];
    UIImageView *mi2 = [[UIImageView alloc]initWithImage:image2];
    mi2.frame = CGRectMake((width/3 - 44)/2, 0.0f, 44.0f, 44.0f);
    [_myRequirements addSubview:mi2];
    self.myRequireLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 30.0f, width/3, 40.0f)];
    _myRequireLabel.textAlignment = NSTextAlignmentCenter;
    _myRequireLabel.textColor = RGB(110, 110, 110);
    _myRequireLabel.font = [UIFont systemFontOfSize:12.0f];
    _myRequireLabel.backgroundColor = [UIColor clearColor];
    _myRequireLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _myRequireLabel.text = @"我的需求";
    _myRequireLabel.numberOfLines = 0;
    [_myRequirements addSubview:_myRequireLabel];
    /**
     *添加手势
     */
    UITapGestureRecognizer *myRequirementsTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requirementButtonClicked:)];
    
    [_myRequirements addGestureRecognizer:myRequirementsTapGesture];
    [center addSubview:_myRequirements];
    
    _setting = [[UIView alloc]initWithFrame:CGRectMake(2*width/3, 0.0f, width/3, 200.0f)];
    UIImage *image3 = [UIImage imageNamed:@"setting"];
    UIImageView *mi3 = [[UIImageView alloc]initWithImage:image3];
    mi3.frame = CGRectMake((width/3 - 44)/2, 0.0f, 44.0f, 44.0f);
    [_setting addSubview:mi3];
    self.settigLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 30.0f, width/3, 40.0f)];
    _settigLabel.textAlignment = NSTextAlignmentCenter;
    _settigLabel.textColor = RGB(110, 110, 110);
    _settigLabel.font = [UIFont systemFontOfSize:12.0f];
    _settigLabel.backgroundColor = [UIColor clearColor];
    _settigLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _settigLabel.text = @"设置";
    _settigLabel.numberOfLines = 0;
    [_setting addSubview:_settigLabel];
    /**
     *添加手势
     */
    UITapGestureRecognizer *settingTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingButtonClicked:)];
    
    [_setting addGestureRecognizer:settingTapGesture];
    [center addSubview:_setting];
    
    // 底部箭头
    UIView *bottomBtn = [[UIView alloc]initWithFrame:CGRectMake(0, height - 44.0f, width, 44.0f)];
    UIImage *arrow = [UIImage imageNamed:@"up"];
    UIImageView *arrowView = [[UIImageView alloc]initWithImage:arrow];
    arrowView.frame = CGRectMake((width - 44)/2, 0.0f, 44.0f, 44.0f);
    [bottomBtn addSubview:arrowView];
    /**
     *添加手势
     */
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upSlide)];
    [bottomBtn addGestureRecognizer:tapGesture];
    
    [self.view addSubview:top];
    [self.view addSubview:center];
    [self.view addSubview:bottomBtn];
    
    
    //在一个Controller里写了两个View,通过动画跳到下一界面
    // 名片详情部分
    self.details = [[UIView alloc]initWithFrame:CGRectMake(0, height, width, height - self.navigationBarHeight)];
    self.details.backgroundColor = [UIColor whiteColor];
    UIView *dTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 80.0f)];
    dTop.backgroundColor = RGB(234, 234, 234);
    [self.details addSubview:dTop];
    //头像
    UIImage *dImage = [UIImage imageNamed:@"default_face"];
    _dFace = [[UIImageView alloc]initWithImage:dImage];
    _dFace.frame = CGRectMake(15.0f, 10.0f, 60.0f, 60.0f);
    _dFace.layer.masksToBounds = YES;
    _dFace.layer.cornerRadius = 30;
    [dTop addSubview:_dFace];
    //姓名
    _dNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f + 60.0f + 24.0f, 10.0f, width - 15.0f - 60.0f - 24.0f, 16.0f)];
    _dNameLabel.textAlignment = NSTextAlignmentLeft;
    _dNameLabel.textColor = RGB(90, 90, 90);
    _dNameLabel.font = [UIFont systemFontOfSize:16.0f];
    _dNameLabel.backgroundColor = [UIColor clearColor];
    _dNameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _dNameLabel.text = @"";
    _dNameLabel.numberOfLines = 0;
    [dTop addSubview:_dNameLabel];
    //职位
    _dPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f + 60.0f + 24.0f, 10.0f + 16.0f + 5.0f, width - 15.0f - 60.0f - 24.0f, 20.0f)];
    _dPositionLabel.textAlignment = NSTextAlignmentLeft;
    _dPositionLabel.textColor = RGB(155, 155, 155);
    _dPositionLabel.backgroundColor = [UIColor grayColor];
    _dPositionLabel.font = [UIFont systemFontOfSize:12.0f];
    _dPositionLabel.backgroundColor = [UIColor clearColor];
    _dPositionLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _dPositionLabel.text = @"";
    _dPositionLabel.numberOfLines = 0;
    [dTop addSubview:_dPositionLabel];
    //公司
    _dCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+24.0f, 10.0f+16.0f+5.0f+12.0f+5.0f, width-15.0f-60.0f-24.0f, 20.0f)];
    _dCompanyLabel.textAlignment = NSTextAlignmentLeft;
    _dCompanyLabel.textColor = RGB(155, 155, 155);
    _dCompanyLabel.font = [UIFont systemFontOfSize:12.0f];
    _dCompanyLabel.backgroundColor = [UIColor clearColor];
    _dCompanyLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _dCompanyLabel.text = @"";
    _dCompanyLabel.numberOfLines = 0;
    [dTop addSubview:_dCompanyLabel];

    //电话Label
    UILabel *dPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(dTop.frame)+24.0f, 35, 12.0f)];
    dPhoneLabel.textAlignment = NSTextAlignmentLeft;
    dPhoneLabel.textColor = RGB(110, 110, 110);
    dPhoneLabel.font = [UIFont systemFontOfSize:12.0f];
    dPhoneLabel.backgroundColor = [UIColor clearColor];
    dPhoneLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dPhoneLabel.text = @"电话:";
    dPhoneLabel.numberOfLines = 0;
    [self.details addSubview:dPhoneLabel];
    //手机号显示
    _dPhoneT = [[UILabel alloc]initWithFrame:CGRectMake(20.0f+35.0f, CGRectGetMaxY(dTop.frame)+24.0f, width-2*20.0f-35.0f, 12.0f)];
    _dPhoneT.textAlignment = NSTextAlignmentLeft;
    _dPhoneT.textColor = RGB(110, 110, 110);
    _dPhoneT.font = [UIFont systemFontOfSize:12.0f];
    _dPhoneT.backgroundColor = [UIColor clearColor];
    _dPhoneT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _dPhoneT.text = @"";
    _dPhoneT.numberOfLines = 0;
    [self.details addSubview:_dPhoneT];
    
    //自己画的横线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(dPhoneLabel.frame)+15.0f, width - 2*10.0f, 0.5f)];
    lineView1.backgroundColor = RGB(227, 227, 227);
    [self.details addSubview:lineView1];
    //Email
    UILabel *dEmailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(lineView1.frame)+15.0f, 35.0f, 12.0f)];
    dEmailLabel.textAlignment = NSTextAlignmentLeft;
    dEmailLabel.textColor = RGB(110, 110, 110);
    dEmailLabel.font = [UIFont systemFontOfSize:12.0f];
    dEmailLabel.backgroundColor = [UIColor clearColor];
    dEmailLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dEmailLabel.text = @"邮箱:";
    dEmailLabel.numberOfLines = 0;
    [self.details addSubview:dEmailLabel];
    //显示Email
    _dEmailT = [[UILabel alloc]initWithFrame:CGRectMake(20.0f + 35.0f, CGRectGetMaxY(lineView1.frame) + 15.0f, width - 2 * 20.0f - 35.0f, 12.0f)];
    _dEmailT.textAlignment = NSTextAlignmentLeft;
    _dEmailT.textColor = RGB(110, 110, 110);
    _dEmailT.font = [UIFont systemFontOfSize:12.0f];
    _dEmailT.backgroundColor = [UIColor clearColor];
    _dEmailT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _dEmailT.text = @"";
    _dEmailT.numberOfLines = 0;
    [self.details addSubview:_dEmailT];
    
    //第二条线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(dEmailLabel.frame)+15.0f, width - 2*10.0f, 0.5f)];
    lineView2.backgroundColor = RGB(227, 227, 227);
    [self.details addSubview:lineView2];
    //微信
    UILabel *dWechatLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(lineView2.frame)+15.0f, 35, 12.0f)];
    dWechatLabel.textAlignment = NSTextAlignmentLeft;
    dWechatLabel.textColor = RGB(110, 110, 110);
    dWechatLabel.font = [UIFont systemFontOfSize:12.0f];
    dWechatLabel.backgroundColor = [UIColor clearColor];
    dWechatLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dWechatLabel.text = @"微信:";
    dWechatLabel.numberOfLines = 0;
    [self.details addSubview:dWechatLabel];
    //微信展示
    _dWechatT = [[UILabel alloc]initWithFrame:CGRectMake(20.0f+35.0f, CGRectGetMaxY(lineView2.frame)+15.0f, width-2*20.0f-35.0f, 12.0f)];
    _dWechatT.textAlignment = NSTextAlignmentLeft;
    _dWechatT.textColor = RGB(110, 110, 110);
    _dWechatT.font = [UIFont systemFontOfSize:12.0f];
    _dWechatT.backgroundColor = [UIColor clearColor];
    _dWechatT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _dWechatT.text = @"";
    _dWechatT.numberOfLines = 0;
    [self.details addSubview:_dWechatT];
    //城市
    UILabel *dCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(dWechatLabel.frame)+66.0f, 35, 12.0f)];
    dCityLabel.textAlignment = NSTextAlignmentLeft;
    dCityLabel.textColor = RGB(110, 110, 110);
    dCityLabel.font = [UIFont systemFontOfSize:12.0f];
    dCityLabel.backgroundColor = [UIColor clearColor];
    dCityLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dCityLabel.text = @"城市:";
    dCityLabel.numberOfLines = 0;
    [self.details addSubview:dCityLabel];
    //城市展示
    _dCityT = [[UILabel alloc]initWithFrame:CGRectMake(20.0f+35.0f, CGRectGetMaxY(dWechatLabel.frame)+66.0f, width-2*20.0f-35.0f, 12.0f)];
    _dCityT.textAlignment = NSTextAlignmentLeft;
    _dCityT.textColor = RGB(110, 110, 110);
    _dCityT.font = [UIFont systemFontOfSize:12.0f];
    _dCityT.backgroundColor = [UIColor clearColor];
    _dCityT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _dCityT.text = @"";
    _dCityT.numberOfLines = 0;
    [self.details addSubview:_dCityT];
    //第三条线
    _lineView3 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(dCityLabel.frame)+15.0f, width - 2*10.0f, 0.5f)];
    _lineView3.backgroundColor = RGB(227, 227, 227);
    [self.details addSubview:_lineView3];
    //地址
    UILabel *dAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(_lineView3.frame)+16.0f, 35, 12.0f)];
    dAddressLabel.textAlignment = NSTextAlignmentLeft;
    dAddressLabel.textColor = RGB(110, 110, 110);
    dAddressLabel.font = [UIFont systemFontOfSize:12.0f];
    dAddressLabel.backgroundColor = [UIColor clearColor];
    dAddressLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dAddressLabel.text = @"地址:";
    dAddressLabel.numberOfLines = 0;
    [self.details addSubview:dAddressLabel];
    //显示地址
    _dAddressT = [[UILabel alloc]initWithFrame:CGRectMake(20.0f+35.0f, CGRectGetMaxY(_lineView3.frame)+15.0f, width-2*20.0f-35.0f, 12.0f)];
    _dAddressT.textAlignment = NSTextAlignmentLeft;
    _dAddressT.textColor = RGB(110, 110, 110);
    _dAddressT.font = [UIFont systemFontOfSize:12.0f];
    _dAddressT.backgroundColor = [UIColor clearColor];
    _dAddressT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self.details addSubview:_dAddressT];
    //底部按钮
    UIView *bottomBtn2 = [[UIView alloc]initWithFrame:CGRectMake(0, height-self.navigationBarHeight-44.0f, width, 44.0f)];
    UIImage *arrow2 = [UIImage imageNamed:@"down"];
    UIImageView *arrowv2 = [[UIImageView alloc]initWithImage:arrow2];
    arrowv2.frame = CGRectMake((width - 44)/2, 0.0f, 44.0f, 44.0f);
    [bottomBtn2 addSubview:arrowv2];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downSlide)];
    [bottomBtn2 addGestureRecognizer:tapGesture2];
    [self.details addSubview:bottomBtn2];
    
    [self.view addSubview:self.details];

    self.profile = [[TSWProfile alloc] initWithBaseURL:TSW_API_BASE_URL path:PROFILE];
    [self.profile addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];

    
    [self refreshData];
}
//添加左侧导航按钮
- (void)addLeftNavigatorButton
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 31, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"back"]  forState:UIControlStateNormal];
    //[leftButton setImage:[UIImage imageNamed:@"back"]  forState:UIControlStateHighlighted];
    //    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(2, 14, 5, 9)];
    [leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftButton = leftButton;
}
//左侧按钮点击事件
-(void)leftButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//更新数据
-(void) refreshData{
    [self showLoadingView];
    //[self disableBtns]; //让三个按钮消失
    [self.profile loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _profile){
            if (_profile.isLoaded) {
                [self hideLoadingView];
                [self enableBtns];
                [self setDetail:_profile];
            }
            else if (_profile.error) {
                [self hideLoadingView];
                [self enableBtns];
                [self showErrorMessage:[_profile.error localizedFailureReason]];
            }
        }
    }
}

-(void)setDetail:(TSWProfile *)profile{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    // 塞数据，布局
    [_face setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profile.imgUrl_3x]]]];
    [_dFace setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profile.imgUrl_3x]]]];
    _nameLabel.text = profile.name;
    _positionLB.text = profile.title;
    _companyLB.text = profile.company;
    
    _dNameLabel.text = profile.name;
    _dPositionLabel.text = profile.title;
    _dCompanyLabel.text = profile.companyFullName;
    _dPhoneT.text = profile.phone;
    _dEmailT.text = profile.email;
    _dWechatT.text = profile.wechat;
    _dCityT.text = profile.companyCityName;
    NSString *titleContent = profile.companyAddress;
    _dAddressT.text = titleContent;
    _dAddressT.numberOfLines = 0;
    //根据文字计算Label的高度
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 2 * 20.0f - 35.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _dAddressT.frame = CGRectMake(20.0f + 35.0f, CGRectGetMaxY(_lineView3.frame) + 15.0f,  titleSize.width, titleSize.height);
    //第四条线
    _lineView4 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(_dAddressT.frame)+15.0f, width - 2*10.0f, 0.5f)];
    _lineView4.backgroundColor = RGB(227, 227, 227);
    [self.details addSubview:_lineView4];
    
}

//添加右侧导航按钮
- (void)addRightNavigatorButton
{
    self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 58, 20, 48, 12)];
    [self.editBtn setTitleColor:RGB(32, 158, 217) forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightButton:self.editBtn]; //navigation里自己封装的方法
    self.editBtn.hidden = YES;
}
//显示按钮
-(void)enableBtns{
    [_myProjects setHidden:NO];
    [_myRequirements setHidden:NO];
    [_setting setHidden:NO];
}
//隐藏按钮
-(void)disableBtns{
    [_myProjects setHidden:YES];
    [_myRequirements setHidden:YES];
    [_setting setHidden:YES];
}
//我的项目按钮点击事件
- (void)projectButtonClicked:(id)sender
{
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(myProjectsDetail) object:sender];
    //NSTheard技术
    [self performSelector:@selector(myProjectsDetail) withObject:sender afterDelay:0.2f];
}
//进入我的项目详情界面
-(void)myProjectsDetail {
    TSWMyProjectsViewController *pushController = [[TSWMyProjectsViewController alloc] init];
    [self.navigationController pushViewController:pushController animated:YES];
}
//我的需求按钮点击事件
- (void)requirementButtonClicked:(id)sender
{
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(myRequirementsDetail) object:sender];
    [self performSelector:@selector(myRequirementsDetail) withObject:sender afterDelay:0.2f];
}
//进入我的需求界面
-(void)myRequirementsDetail {
    TSWMyRequirementsViewController *pushController = [[TSWMyRequirementsViewController alloc] init];
    [self.navigationController pushViewController:pushController animated:YES];
}
//设置按钮点击事件
- (void)settingButtonClicked:(id)sender
{
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(settingDetail) object:sender];
    [self performSelector:@selector(settingDetail) withObject:sender afterDelay:0.2f];
}
//进入设置详情
-(void)settingDetail {
    TSWSettingsViewController *pushController = [[TSWSettingsViewController alloc] init];
    [self.navigationController pushViewController:pushController animated:YES];
}
//滑动动画,弹出下一个视图
- (void)upSlide {
    //打印动画块的位置
    //NSLog(@"动画执行之前的位置：%@",NSStringFromCGPoint(self.details.center));
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:0.5];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
    self.details.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, ([UIScreen mainScreen].bounds.size.height - self.navigationBarHeight) / 2 + self.navigationBarHeight); //滑动之后视图的中心点
    //self.details.center = CGPointMake(160, 310);
    [UIView commitAnimations];
    
    // 出现编辑按钮 TODO:要先隐藏
    self.editBtn.hidden = NO;
}

-(void)downSlide{
    //打印动画块的位置
    //NSLog(@"动画执行之前的位置：%@",NSStringFromCGPoint(self.details.center));
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:0.5];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
    //动画弹出位置
    self.details.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 1000);
    [UIView commitAnimations];
    // 出现编辑按钮 TODO:要先隐藏
    self.editBtn.hidden = YES;
}

- (void)editProfile {
    // 弹出编辑个人名片的vc
    TSWEditProfileViewController *editProfileController = [[TSWEditProfileViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editProfileController];
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
}


- (void)dealloc
{
    [_profile removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (void)didStopAnimation {
    
}

@end
