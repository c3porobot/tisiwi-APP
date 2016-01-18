//
//  TSWLoginViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWLoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "TSWCheckPhoneExist.h"
#import "TSWSendLoginVeriCode.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWProfileViewController.h"
#import "TSWHomeRootController.h"
#import "TSWValidate.h"
#import "TSWAccountLogin.h"

@interface TSWLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) TSWAccountLogin *accountLogin;
@property (nonatomic, strong) TSWCheckPhoneExist *checkPhoneExist; //手机验证
@property (nonatomic, strong) TSWSendLoginVeriCode *loginVeriCode; //发送手机登陆
@property (nonatomic, strong) CXNavigationBarController *controller;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UIButton *yanBtn;
@property (nonatomic, strong) UITextField *verifyCodeField;
@property (nonatomic, strong) TSWValidate *validate; //验证
@property (nonatomic, strong) UIButton *loginBtn;    //登陆
@end

@implementation TSWLoginViewController

- (void)dealloc
{
    [_loginVeriCode removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_checkPhoneExist removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_accountLogin removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_validate removeObserver:self forKeyPath:@"surplusTime"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.title = @"登录";
    self.view.backgroundColor = RGB(235, 235, 235);
    self.navigationBar.bottomLineView.hidden = YES;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    [self.view addSubview:_scrollView];
    
    UIView *loginView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 30.0f, width, 2*48.0f+0.5f)];
    loginView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:loginView];
    
    // 手机号
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(30.0f, 0, width - 2*30.0f - 74.0f, 48.0f)];
    _phoneField.borderStyle = UITextBorderStyleNone;
    _phoneField.font = [UIFont systemFontOfSize:15.0f];
    [_phoneField setTextColor:RGB(132, 132, 132)];
    _phoneField.placeholder = @"手机号";
    _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.backgroundColor = [UIColor whiteColor];
    _phoneField.autocapitalizationType = NO;
    [loginView addSubview:_phoneField];
    
    // 校验按钮
    _yanBtn = [[UIButton alloc]initWithFrame:CGRectMake(width-30.0f-74.0f, 13.0f, 74.0f, 24.0f)];
//    _yanBtn.backgroundColor = RGB(33, 158, 217);
    [_yanBtn setBackgroundImage:[UIImage imageNamed:@"login_bti_n"]forState:UIControlStateNormal];
    [_yanBtn setBackgroundImage:[UIImage imageNamed:@"login_bti_h"]forState:UIControlStateHighlighted];
    [_yanBtn setBackgroundImage:[UIImage imageNamed:@"login_bti_d"]forState:UIControlStateDisabled];
    [_yanBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [_yanBtn setTitle:@"验证" forState:UIControlStateNormal];
    _yanBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_yanBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview: _yanBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(30.0f, 48.0f, width - 2*30.0f, 0.5f)];
    lineView.backgroundColor = RGB(206, 206, 206);
    [loginView addSubview:lineView];
    
    // 验证码
    _verifyCodeField = [[UITextField alloc]initWithFrame:CGRectMake(30.0f, 48.5f, width - 2*30.0f, 48.0f)];
    _verifyCodeField.borderStyle = UITextBorderStyleNone;
    _verifyCodeField.font = [UIFont systemFontOfSize:15.0f];
    [_verifyCodeField setTextColor:RGB(132, 132, 132)];
    _verifyCodeField.placeholder = @"验证码";
    _verifyCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _verifyCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyCodeField.backgroundColor = [UIColor whiteColor];
    _verifyCodeField.autocapitalizationType = NO;
    [loginView addSubview:_verifyCodeField];
    
    // 登录按钮
    _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, 30.0f+2*48.0f+0.5f+20.0f, width-2*10.0f, 48.0f)];
    _loginBtn.backgroundColor = RGB(199, 199, 199);
    _loginBtn.layer.cornerRadius = 4.0f;
    [_loginBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [_loginBtn setTitle:@"确 定" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview: _loginBtn];
    
    self.accountLogin = [[TSWAccountLogin alloc] initWithBaseURL:TSW_API_BASE_URL path:ACCOUNT_LOGIN];
    
    [self.accountLogin addObserver:self
                        forKeyPath:kResourceLoadingStatusKeyPath
                           options:NSKeyValueObservingOptionNew
                           context:nil];
    
    self.checkPhoneExist = [[TSWCheckPhoneExist alloc] initWithBaseURL:TSW_API_BASE_URL path:CHECK_PHONE_EXIST];
    
    [self.checkPhoneExist addObserver:self
                           forKeyPath:kResourceLoadingStatusKeyPath
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    
    self.loginVeriCode = [[TSWSendLoginVeriCode alloc] initWithBaseURL:TSW_API_BASE_URL path:LOGIN_VERI_CODE];
    
    [self.loginVeriCode addObserver:self
                         forKeyPath:kResourceLoadingStatusKeyPath
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    
    [self setValidate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setValidate
{
    _validate = [TSWValidate new];
    _validate.timeout = 60;
    _validate.code = @"";
    
    if (!self.validate.isStartTime) {
        //        [self.validate startTime];
    }
    else {
        if (self.validate.surplusTime <= 0) {
            _yanBtn.backgroundColor = RGB(33, 158, 217);
            [_yanBtn setTitle:@"重发" forState:UIControlStateNormal];
            [_yanBtn setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
            _yanBtn.userInteractionEnabled = YES;
            
        }
    }
    
    [_validate addObserver:self
                    forKeyPath:@"surplusTime"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
}


#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _checkPhoneExist) {
            if (_checkPhoneExist.isLoaded) {
                [self hideLoadingView];
                [self.loginVeriCode loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"phone": _phoneField.text}];
            }
            else if (_checkPhoneExist.error) {
                [self showErrorMessage:[_checkPhoneExist.error localizedFailureReason]];
            }
        }else if(object == _loginVeriCode){
            if (_loginVeriCode.isLoaded) {
                [self hideLoadingView];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码已发送，请注意查收" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                
                // 倒计时开始
                if (!_validate.isStartTime) {
                    [_validate startTime];
                }
                
                // TODO:先直接让登录按钮可用
                [self enableLoginBtn];
                
                // TODO:拿真机测试是否有用
                [_verifyCodeField becomeFirstResponder];
            }
            else if (_loginVeriCode.error) {
                [self showErrorMessage:[_loginVeriCode.error localizedFailureReason]];
            }
        }else if (object == _accountLogin) {
            if (_accountLogin.isLoaded) {
                [self hideLoadingView];
                
                [GVUserDefaults standardUserDefaults].token = _accountLogin.token;
                [GVUserDefaults standardUserDefaults].member = _accountLogin.member;
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotificationName object:nil];
                
                [self refresh];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
            else if (_accountLogin.error) {
                [self showErrorMessage:[_accountLogin.error localizedFailureReason]];
            }
        }
    }else if([keyPath isEqualToString:@"surplusTime"]){
        if (object == _validate) {
            if (_validate.surplusTime > 0) {
                int seconds = self.validate.surplusTime % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                _yanBtn.backgroundColor = RGB(169, 169, 169);
                [_yanBtn setTitle:[NSString stringWithFormat:@"重发(%@)",strTime] forState:UIControlStateNormal];
                [_yanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _yanBtn.userInteractionEnabled = NO;
                [_yanBtn setEnabled:NO];
            }
            else {
                _yanBtn.backgroundColor = RGB(33, 158, 217);
                [_yanBtn setTitle:@"重发" forState:UIControlStateNormal];
                [_yanBtn setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
                _yanBtn.userInteractionEnabled = YES;
                [_yanBtn setEnabled:YES];
            }
        }
    }
}

-(void) enableLoginBtn{
    _loginBtn.backgroundColor = RGB(33, 158, 217);
    _yanBtn.userInteractionEnabled = YES;
}

-(void) disableLoginBtn{
    _loginBtn.backgroundColor = RGB(199, 199, 199);
    _yanBtn.userInteractionEnabled = NO;
}

-(void)refresh{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshData)]) {
        [self.delegate refreshData];
    }
}

-(void) sendCode{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if(_phoneField.text.length > 0){
        if([regextestmobile evaluateWithObject:_phoneField.text] == YES){
            [self showLoadingView];
            [self.checkPhoneExist loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"phone": _phoneField.text}];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的11位数字手机号!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，去tisiwi.com提交你的项目，就有加入湾仔码头的机会哦!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
}

#pragma mark 登录操作
-(void)login{
    if(_verifyCodeField.text.length > 0){
        if(_verifyCodeField.text.length == 6){
            [self showLoadingViewWithText:@"登录中..."];
            [self.accountLogin loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"phone":_phoneField.text, @"veriCode":_verifyCodeField.text}];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的6位数字验证码!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，请输入正确的6位数字校验码!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
}

#pragma mark - UIButton
- (void)dismiss:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
