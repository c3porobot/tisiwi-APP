//
//  TSWEditProfileViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/9.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//
#import "SZTextView.h"
#import "TSWEditProfileViewController.h"
#import "TSWProfile.h"
#import "TSWSendProfile.h"
#import "ZHAreaPickerView.h"

@interface TSWEditProfileViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZHAreaPickerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

//@property (nonatomic, strong) TSWFeedback *feedback;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) SZTextView *textView;

@property (nonatomic, strong) TSWProfile *profile;
@property (nonatomic, strong) TSWSendProfile *sendProfile;

@property (nonatomic, strong) UIScrollView *details;
@property (nonatomic, strong) ZHAreaPickerView *locatePicker;
@property (nonatomic, strong) NSString *selectedCityCode;

@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, strong) UIImageView *dFace;
@property (nonatomic, strong) UITextField *dNameField;
@property (nonatomic, strong) UITextField *dPositionField;
@property (nonatomic, strong) UITextField *dCompanyField;
@property (nonatomic, strong) UILabel *dPhoneT;
@property (nonatomic, strong) UITextField *dEmailField;
@property (nonatomic, strong) UITextField *dWechatField;
@property (nonatomic, strong) UIButton *dCityBtn;
@property (nonatomic, strong) UITextField *dAddressField;

@property (nonatomic, strong) UIView *dTop;

@property (nonatomic, strong) UILabel *nameVeri;
@property (nonatomic, strong) UILabel *positionVeri;
@property (nonatomic, strong) UILabel *companyVeri;
@property (nonatomic, strong) UILabel *emailVeri;
@property (nonatomic, strong) UILabel *wechatVeri;
@property (nonatomic, strong) UILabel *addressVeri;

@property (nonatomic, strong) UIButton *dismissButton; //返回按钮
@end

@implementation TSWEditProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = @"";
    self.navigationBar.titleView.textColor = RGB(90, 90, 90);
    self.navigationBar.backgroundView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = RGB(234, 234, 234);
    _selectedCityCode = @"";
    
    [self addRightNavigatorButton];
    
    if ([self.navigationController.viewControllers indexOfObject:self] == 0) {
        CGRect dismissButtonFrame = CGRectMake(00.0f, 0.0f, 21.0f, 44.0f);
        
        self.dismissButton = [[UIButton alloc] initWithFrame:dismissButtonFrame];
        _dismissButton.backgroundColor = [UIColor clearColor];
        [_dismissButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_dismissButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        [_dismissButton setImageEdgeInsets:UIEdgeInsetsMake(0,10.0f,0,0)];
        [_dismissButton setTitle:@" " forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_dismissButton setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
        [_dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationBar.leftButton = _dismissButton;
    }
    
    self.details = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    self.details.backgroundColor = [UIColor whiteColor];
    _dTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 80.0f)];
    _dTop.backgroundColor = RGB(234, 234, 234);
    [self.details addSubview:_dTop];
    UIImage *dImage = [UIImage imageNamed:@"photo"];
    _dFace = [[UIImageView alloc]initWithImage:dImage];
    _dFace.frame = CGRectMake(15.0f, 10.0f, 60.0f, 60.0f);
    _dFace.layer.masksToBounds = YES;
    _dFace.layer.cornerRadius = 30;
    [_dFace setUserInteractionEnabled:YES];
    _dFace.exclusiveTouch = YES;
    UITapGestureRecognizer *imgTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
    [_dFace addGestureRecognizer:imgTapGesture];
    [_dTop addSubview:_dFace];
    
    UILabel *nameStar = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+24.0f-8.0f, 10.0f, width-15.0f-60.0f-24.0f, 16.0f)];
    nameStar.textColor = [UIColor redColor];
    nameStar.text = @"*";
    [_dTop addSubview:nameStar];
    
    self.dNameField = [[UITextField alloc]initWithFrame:CGRectMake(15.0f+60.0f+24.0f, 10.0f, width-15.0f-60.0f-24.0f, 16.0f)];
    self.dNameField.borderStyle = UITextBorderStyleNone;
    self.dNameField.font = [UIFont systemFontOfSize:12.0f];
    [self.dNameField setTextColor:RGB(200, 200, 200)];
    self.dNameField.delegate = self;
    self.dNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.dNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.dNameField.backgroundColor = [UIColor clearColor];
    self.dNameField.placeholder = @"姓名";
    self.dNameField.autocapitalizationType = NO;
    self.dNameField.tag = 1;
    [_dTop addSubview:self.dNameField];
    _nameVeri = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+24.0f+(width-15.0f-60.0f-24.0f)/2-10.0f, 10.0f, (width-15.0f-60.0f-24.0f)/2, 16.0f)];
    _nameVeri.textAlignment = NSTextAlignmentRight;
    _nameVeri.textColor = [UIColor redColor];
    _nameVeri.font = [UIFont systemFontOfSize:12.0f];
    _nameVeri.backgroundColor = [UIColor clearColor];
    _nameVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _nameVeri.text = @"超出有效长度";
    _nameVeri.numberOfLines = 0;
    _nameVeri.hidden = YES;
    [_dTop addSubview:_nameVeri];
    
    UILabel *positionStar = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+24.0f-8.0f, 10.0f+16.0f+5.0f, width-15.0f-60.0f-24.0f, 20.0f)];
    positionStar.textColor = [UIColor redColor];
    positionStar.text = @"*";
    [_dTop addSubview:positionStar];
    
    self.dPositionField = [[UITextField alloc]initWithFrame:CGRectMake(15.0f+60.0f+24.0f, 10.0f+16.0f+5.0f, width-15.0f-60.0f-24.0f, 20.0f)];
    self.dPositionField.borderStyle = UITextBorderStyleNone;
    self.dPositionField.font = [UIFont systemFontOfSize:12.0f];
    [self.dPositionField setTextColor:RGB(200, 200, 200)];
    self.dPositionField.delegate = self;
    self.dPositionField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.dPositionField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.dPositionField.backgroundColor = [UIColor clearColor];
    self.dPositionField.placeholder = @"职位";
    self.dPositionField.autocapitalizationType = NO;
    self.dPositionField.tag = 2;
    [_dTop addSubview:self.dPositionField];
    _positionVeri = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+24.0f+(width-15.0f-60.0f-24.0f)/2-10.0f, 10.0f+16.0f+5.0f, (width-15.0f-60.0f-24.0f)/2, 20.0f)];
    _positionVeri.textAlignment = NSTextAlignmentRight;
    _positionVeri.textColor = [UIColor redColor];
    _positionVeri.font = [UIFont systemFontOfSize:12.0f];
    _positionVeri.backgroundColor = [UIColor clearColor];
    _positionVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _positionVeri.text = @"超出有效长度";
    _positionVeri.numberOfLines = 0;
    _positionVeri.hidden = YES;
    [_dTop addSubview:_positionVeri];
    
    UILabel *companyStar = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+24.0f-8.0f, 10.0f+16.0f+5.0f+12.0f+5.0f, width-15.0f-60.0f-24.0f, 20.0f)];
    companyStar.textColor = [UIColor redColor];
    companyStar.text = @"*";
    [_dTop addSubview:companyStar];
    
    self.dCompanyField = [[UITextField alloc]initWithFrame:CGRectMake(15.0f+60.0f+24.0f, 10.0f+16.0f+5.0f+12.0f+5.0f, width-15.0f-60.0f-24.0f, 20.0f)];
    self.dCompanyField.borderStyle = UITextBorderStyleNone;
    self.dCompanyField.font = [UIFont systemFontOfSize:12.0f];
    [self.dCompanyField setTextColor:RGB(200, 200, 200)];
    self.dCompanyField.delegate = self;
    self.dCompanyField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.dCompanyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.dCompanyField.backgroundColor = [UIColor clearColor];
    self.dCompanyField.placeholder = @"公司";
    self.dCompanyField.autocapitalizationType = NO;
    self.dCompanyField.tag = 3;
    [_dTop addSubview:self.dCompanyField];
    _companyVeri = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+24.0f+(width-15.0f-60.0f-24.0f)/2-10.0f, 10.0f+16.0f+5.0f+12.0f+5.0f, (width-15.0f-60.0f-24.0f)/2, 20.0f)];
    _companyVeri.textAlignment = NSTextAlignmentRight;
    _companyVeri.textColor = [UIColor redColor];
    _companyVeri.font = [UIFont systemFontOfSize:12.0f];
    _companyVeri.backgroundColor = [UIColor clearColor];
    _companyVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _companyVeri.text = @"超出有效长度";
    _companyVeri.numberOfLines = 0;
    _companyVeri.hidden = YES;
    [_dTop addSubview:_companyVeri];
    
    
    UILabel *dPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(_dTop.frame)+24.0f, 35, 20.0f)];
    dPhoneLabel.textAlignment = NSTextAlignmentLeft;
    dPhoneLabel.textColor = RGB(155, 155, 155);
    dPhoneLabel.font = [UIFont systemFontOfSize:12.0f];
    dPhoneLabel.backgroundColor = [UIColor clearColor];
    dPhoneLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dPhoneLabel.text = @"电话:";
    dPhoneLabel.numberOfLines = 0;
    [self.details addSubview:dPhoneLabel];
    
     _dPhoneT = [[UILabel alloc]initWithFrame:CGRectMake(20.0f+35.0f, CGRectGetMaxY(_dTop.frame)+24.0f, width-2*20.0f-35.0f, 20.0f)];
    _dPhoneT.textAlignment = NSTextAlignmentLeft;
    _dPhoneT.textColor = RGB(155, 155, 155);
    _dPhoneT.font = [UIFont systemFontOfSize:12.0f];
    _dPhoneT.backgroundColor = [UIColor clearColor];
    _dPhoneT.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _dPhoneT.text = @"";
    _dPhoneT.numberOfLines = 0;
    [self.details addSubview:_dPhoneT];

    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(dPhoneLabel.frame)+15.0f, width - 2*10.0f, 0.5f)];
    lineView1.backgroundColor = RGB(227, 227, 227);
    [self.details addSubview:lineView1];
    
    
    UILabel *emailStar = [[UILabel alloc]initWithFrame:CGRectMake(20.0f-8.0f, CGRectGetMaxY(lineView1.frame)+15.0f, 35.0f, 20.0f)];
    emailStar.textColor = [UIColor redColor];
    emailStar.text = @"*";
    [self.details addSubview:emailStar];
    
    UILabel *dEmailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(lineView1.frame)+15.0f, 35.0f, 20.0f)];
    dEmailLabel.textAlignment = NSTextAlignmentLeft;
    dEmailLabel.textColor = RGB(110, 110, 110);
    dEmailLabel.font = [UIFont systemFontOfSize:12.0f];
    dEmailLabel.backgroundColor = [UIColor clearColor];
    dEmailLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dEmailLabel.text = @"邮箱:";
    dEmailLabel.numberOfLines = 0;
    [self.details addSubview:dEmailLabel];
    
    self.dEmailField = [[UITextField alloc]initWithFrame:CGRectMake(20.0f+35.0f, CGRectGetMaxY(lineView1.frame)+15.0f, width-2*20.0f-35.0f, 20.0f)];
    self.dEmailField.borderStyle = UITextBorderStyleNone;
    self.dEmailField.font = [UIFont systemFontOfSize:12.0f];
    [self.dEmailField setTextColor:RGB(155, 155, 155)];
    self.dEmailField.delegate = self;
    self.dEmailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.dEmailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.dEmailField.backgroundColor = [UIColor clearColor];
    self.dEmailField.placeholder = @"";
    self.dEmailField.autocapitalizationType = NO;
    self.dEmailField.tag = 4;
    [self.details addSubview:self.dEmailField];
    _emailVeri = [[UILabel alloc]initWithFrame:CGRectMake(20.0f+35.0f+(width-2*20.0f-35.0f)/2, CGRectGetMaxY(lineView1.frame)+15.0f, (width-2*20.0f-35.0f)/2, 20.0f)];
    _emailVeri.textAlignment = NSTextAlignmentRight;
    _emailVeri.textColor = [UIColor redColor];
    _emailVeri.font = [UIFont systemFontOfSize:12.0f];
    _emailVeri.backgroundColor = [UIColor clearColor];
    _emailVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _emailVeri.text = @"请输入正确格式";
    _emailVeri.numberOfLines = 0;
    _emailVeri.hidden = YES;
    [self.details addSubview:_emailVeri];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(dEmailLabel.frame)+15.0f, width - 2*10.0f, 0.5f)];
    lineView2.backgroundColor = RGB(227, 227, 227);
    [self.details addSubview:lineView2];
    
    UILabel *dWechatLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(lineView2.frame)+15.0f, 35, 20.0f)];
    dWechatLabel.textAlignment = NSTextAlignmentLeft;
    dWechatLabel.textColor = RGB(110, 110, 110);
    dWechatLabel.font = [UIFont systemFontOfSize:12.0f];
    dWechatLabel.backgroundColor = [UIColor clearColor];
    dWechatLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dWechatLabel.text = @"微信:";
    dWechatLabel.numberOfLines = 0;
    [self.details addSubview:dWechatLabel];
    
    self.dWechatField = [[UITextField alloc]initWithFrame:CGRectMake(20.0f+35.0f, CGRectGetMaxY(lineView2.frame)+15.0f, width-2*20.0f-35.0f, 20.0f)];
    self.dWechatField.borderStyle = UITextBorderStyleNone;
    self.dWechatField.font = [UIFont systemFontOfSize:12.0f];
    [self.dWechatField setTextColor:RGB(155, 155, 155)];
    self.dWechatField.delegate = self;
    self.dWechatField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.dWechatField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.dWechatField.backgroundColor = [UIColor clearColor];
    self.dWechatField.placeholder = @"";
    self.dWechatField.autocapitalizationType = NO;
    self.dWechatField.tag = 5;
    [self.details addSubview:self.dWechatField];
    _wechatVeri = [[UILabel alloc]initWithFrame:CGRectMake(20.0f+35.0f+(width-2*20.0f-35.0f)/2, CGRectGetMaxY(lineView2.frame)+15.0f, (width-2*20.0f-35.0f)/2, 20.0f)];
    _wechatVeri.textAlignment = NSTextAlignmentRight;
    _wechatVeri.textColor = [UIColor redColor];
    _wechatVeri.font = [UIFont systemFontOfSize:12.0f];
    _wechatVeri.backgroundColor = [UIColor clearColor];
    _wechatVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _wechatVeri.text = @"超出有效长度";
    _wechatVeri.numberOfLines = 0;
    _wechatVeri.hidden = YES;
    [self.details addSubview:_wechatVeri];
    
    
    UILabel *cityStar = [[UILabel alloc]initWithFrame:CGRectMake(20.0f-8.0f, CGRectGetMaxY(dWechatLabel.frame)+66.0f, 35, 20.0f)];
    cityStar.textColor = [UIColor redColor];
    cityStar.text = @"*";
    [self.details addSubview:cityStar];
    
    UILabel *dCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(dWechatLabel.frame)+66.0f, 35, 20.0f)];
    dCityLabel.textAlignment = NSTextAlignmentLeft;
    dCityLabel.textColor = RGB(110, 110, 110);
    dCityLabel.font = [UIFont systemFontOfSize:12.0f];
    dCityLabel.backgroundColor = [UIColor clearColor];
    dCityLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dCityLabel.text = @"城市:";
    dCityLabel.numberOfLines = 0;
    [self.details addSubview:dCityLabel];

    self.dCityBtn = [[UIButton alloc]initWithFrame:CGRectMake(20.0f+35.0f, CGRectGetMaxY(dWechatLabel.frame)+66.0f, width-2*20.0f-35.0f, 20.0f)];
    self.dCityBtn.backgroundColor = [UIColor whiteColor];
    [self.dCityBtn setTitleColor:RGB(155, 155, 155) forState:UIControlStateNormal];
    [self.dCityBtn setTitle:@"" forState:UIControlStateNormal];
    self.dCityBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.dCityBtn addTarget:self action:@selector(cityBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.details addSubview:self.dCityBtn];

    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(dCityLabel.frame)+15.0f, width - 2*10.0f, 0.5f)];
    lineView3.backgroundColor = RGB(227, 227, 227);
    [self.details addSubview:lineView3];
    
    UILabel *dAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(lineView3.frame)+15.0f, 35, 20.0f)];
    dAddressLabel.textAlignment = NSTextAlignmentLeft;
    dAddressLabel.textColor = RGB(110, 110, 110);
    dAddressLabel.font = [UIFont systemFontOfSize:12.0f];
    dAddressLabel.backgroundColor = [UIColor clearColor];
    dAddressLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    dAddressLabel.text = @"地址:";
    dAddressLabel.numberOfLines = 0;
    [self.details addSubview:dAddressLabel];

    self.dAddressField = [[UITextField alloc]initWithFrame:CGRectMake(20.0f+35.0f, CGRectGetMaxY(lineView3.frame)+15.0f, width-2*20.0f-35.0f, 20.0f)];
    self.dAddressField.borderStyle = UITextBorderStyleNone;
    self.dAddressField.font = [UIFont systemFontOfSize:12.0f];
    [self.dAddressField setTextColor:RGB(155, 155, 155)];
    self.dAddressField.delegate = self;
    self.dAddressField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.dAddressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.dAddressField.backgroundColor = [UIColor clearColor];
    self.dAddressField.placeholder = @"";
    self.dAddressField.autocapitalizationType = NO;
    self.dAddressField.tag = 6;
    [self.details addSubview:self.dAddressField];
    _addressVeri = [[UILabel alloc]initWithFrame:CGRectMake(20.0f+35.0f+(width-2*20.0f-35.0f)/2, CGRectGetMaxY(lineView3.frame)+15.0f, (width-2*20.0f-35.0f)/2, 20.0f)];
    _addressVeri.textAlignment = NSTextAlignmentRight;
    _addressVeri.textColor = [UIColor redColor];
    _addressVeri.font = [UIFont systemFontOfSize:12.0f];
    _addressVeri.backgroundColor = [UIColor clearColor];
    _addressVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _addressVeri.text = @"超出有效长度";
    _addressVeri.numberOfLines = 0;
    _addressVeri.hidden = YES;
    [self.details addSubview:_addressVeri];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(dAddressLabel.frame)+15.0f, width - 2*10.0f, 0.5f)];
    lineView4.backgroundColor = RGB(227, 227, 227);
    [self.details addSubview:lineView4];
    
    [self.view addSubview:self.details];
    
    self.sendProfile = [[TSWSendProfile alloc] initWithBaseURL:TSW_API_BASE_URL path:SEND_PROFILE];
    [self.sendProfile addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    self.profile = [[TSWProfile alloc] initWithBaseURL:TSW_API_BASE_URL path:PROFILE];
    [self.profile addObserver:self
                   forKeyPath:kResourceLoadingStatusKeyPath
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self refreshData];
}

- (void)addRightNavigatorButton
{
    self.finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 58, 20, 48, 48)];
    [self.finishBtn setTitleColor:RGB(90, 90, 90) forState:UIControlStateNormal];
    self.finishBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishBtn addTarget:self action:@selector(finishProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightButton:self.finishBtn];
}

-(void)dismiss{
        // 放弃信息反馈应出现提示框”亲,要放弃编辑吗?””确定””取消”
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲,要放弃编辑吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 2;
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 2){
        if(buttonIndex == 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cityBtnTouched{
    self.locatePicker = [[ZHAreaPickerView alloc] initWithDelegate:self];
    [self.locatePicker showInView:self.view];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(ZHAreaPickerView *)picker
{
    [self.dCityBtn setTitle:[NSString stringWithFormat:@"%@", picker.locate.city] forState:UIControlStateNormal];
    self.selectedCityCode = picker.locate.cityCode;
}

-(void)hidePicker{
    [self.locatePicker cancelPicker];
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) refreshData{
    [self.profile loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}


-(void)setDetail:(TSWProfile *)profile{
    // 塞数据，布局
    [_dFace setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profile.imgUrl_3x]]]];
    
    _dNameField.text = profile.name;
    _dPositionField.text = profile.title;
    _dCompanyField.text = profile.companyFullName;
    _dPhoneT.text = profile.phone;
    _dEmailField.text = profile.email;
    _dWechatField.text = profile.wechat;
    _selectedCityCode = profile.companyCityCode;
    _dCityBtn.titleLabel.text = profile.companyCityName;
    [_dCityBtn setTitle:profile.companyCityName forState:UIControlStateNormal];
    _dAddressField.text = profile.companyAddress;
    
}


#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _sendProfile){
            if (_sendProfile.isLoaded) {
                [self hideLoadingView];
                // 回到profile详情页，TODO:并在profile详情页刷新
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
            else if (_sendProfile.error) {
                [self showErrorMessage:[_sendProfile.error localizedFailureReason]];
            }
            
        }else if(object == _profile){
            if (_profile.isLoaded) {
                [self setDetail:_profile];
            }
            else if (_profile.error) {
                [self showErrorMessage:[_profile.error localizedFailureReason]];
            }
        }
    }
}

-(void) imgClick:(UITapGestureRecognizer *)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从手机相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.dFace.image=image;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //    imagePicker.view.frame=s
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            
        }
        imagePicker.allowsEditing=YES;
        //    [self.view addSubview:imagePicker.view];
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }else if(buttonIndex == 1) {
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //    imagePicker.view.frame=s
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
        }
        imagePicker.allowsEditing=YES;
        //    [self.view addSubview:imagePicker.view];
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }else if(buttonIndex == 2) {
    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)finishProfile {
    if(_dFace.image != nil) {
    if(_dNameField.text.length > 0){
        if(_dNameField.text.length <= 32){
            _nameVeri.hidden = YES;
            if(_dPositionField.text.length > 0){
                if(_dPositionField.text.length <= 64){
                    _positionVeri.hidden = YES;
                    if(_dCompanyField.text.length>0){
                        if(_dCompanyField.text.length <= 128){
                            _companyVeri.hidden = YES;
                            if(_dEmailField.text.length>0){
                                if(_dEmailField.text.length <= 128 && [_dEmailField.text containsString:@"@"]){
                                    _emailVeri.hidden = YES;
                                    if(_dWechatField.text.length > 0 && _dWechatField.text.length <= 128){
                                            _wechatVeri.hidden = YES;
                                            if(_dAddressField.text.length > 0 && _dAddressField.text.length <= 256){
                                                    _addressVeri.hidden = YES;
                                                    [self showLoadingViewWithText:@"提交中..."];
                                                    [self.sendProfile loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"name":_dNameField.text,@"title":_dPositionField.text,@"company":_dCompanyField.text,@"cityCode":_selectedCityCode,@"address":_dAddressField.text,@"email":_dEmailField.text,@"wechat":_dWechatField.text,@"avatar":self.dFace.image} dataType:kHttpRequestDataTypeMultipart];
                                            }else if(_dAddressField.text.length>256){
                                                _addressVeri.hidden = NO;
                                            }
                                            }else if(_dWechatField.text.length>128){
                                        _wechatVeri.hidden = NO;
                                    }
                                }else{
                                    _emailVeri.hidden = NO;
                                }
                            }else{
                                _emailVeri.text = @"请填写有效邮箱";
                                _emailVeri.hidden = NO;
                            }
                        }else{
                            _companyVeri.hidden = NO;
                        }
                    }else{
                        _companyVeri.text = @"请填写有效公司名";
                        _companyVeri.hidden = NO;
                    }
                }else{
                    _positionVeri.hidden = NO;
                }
            }else{
                _positionVeri.text = @"请填写个人职位";
                _positionVeri.hidden = NO;
            }
        }else{
            _nameVeri.hidden = NO;
        }
    }else{
        _nameVeri.text = @"请填写有效姓名";
        _nameVeri.hidden = NO;
    }
    } else {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置头像" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
    }
    
}

- (void)dealloc
{
    [_sendProfile removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_profile removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.finishBtn.hidden = NO;
    self.dismissButton.hidden = NO;
    switch (textField.tag) {
        case 1:
            if(_dNameField.text.length>0){
                if(_dNameField.text.length<=32){
                    _nameVeri.hidden = YES;
                }else{
                    _nameVeri.hidden = NO;
                }
            }else{
                _nameVeri.text = @"请填写有效姓名";
                _nameVeri.hidden = NO;
            }
            break;
        case 2:
            if(_dPositionField.text.length>0){
                if(_dPositionField.text.length<=64){
                    _positionVeri.hidden = YES;
                }else{
                    _positionVeri.hidden = NO;
                }
            }else{
                _positionVeri.text = @"请填写个人职位";
                _positionVeri.hidden = NO;
            }
            break;
        case 3:
            if(_dCompanyField.text.length>0){
                if(_dCompanyField.text.length<=128){
                    _companyVeri.hidden = YES;
                }else{
                    _companyVeri.hidden = NO;
                }
            }else{
                _companyVeri.text = @"请填写有效公司名";
                _companyVeri.hidden = NO;
            }
            break;
        case 4:
            if(_dEmailField.text.length>0){
                if(_dEmailField.text.length<=128){
                    _emailVeri.hidden = YES;
                }else{
                    _emailVeri.hidden = NO;
                }
            }else{
                _emailVeri.text = @"请填写有效邮箱";
                _emailVeri.hidden = NO;
            }
            break;
        case 5:
            if(_dWechatField.text.length>0){
                if(_dWechatField.text.length<=128){
                    _wechatVeri.hidden = YES;
                }else{
                    _wechatVeri.hidden = NO;
                }
            }
            break;
        case 6:
            if(_dAddressField.text.length>0){
                if(_dAddressField.text.length<=256){
                    _addressVeri.hidden = YES;
                }else{
                    _addressVeri.hidden = NO;
                }
            }
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y+textField.frame.size.height+216+120);
    if(offset <= 0){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
            self.finishBtn.hidden = YES;
            self.dismissButton.hidden = YES;
        }];
    }
    return YES;
}
@end
