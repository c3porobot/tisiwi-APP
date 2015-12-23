//
//  TSWFeedbackController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWFeedbackController.h"

#import "SZTextView.h"
#import "TSWFeedback.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWValidateRules.h"
#import "ZButton.h"



@interface TSWFeedbackController () <UITextFieldDelegate, UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) TSWFeedback *feedback;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) SZTextView *textView;

@property (nonatomic, strong) UILabel *textVeri;

@end

@implementation TSWFeedbackController
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    
    self.view.backgroundColor = RGB(234, 234, 234);
    self.navigationBar.title = @"意见反馈";
    [self addLeftNavigatorButton];
    
    UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height - self.navigationBarHeight)];
    
    UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 24.0f, width - 2*15.0f, 12.0f)];
    tLabel.textAlignment = NSTextAlignmentLeft;
    tLabel.textColor = RGB(90, 90, 90);
    tLabel.font = [UIFont systemFontOfSize:12.0f];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.text = @"反馈描述:";
    [top addSubview:tLabel];
    
    _textView = [[SZTextView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(tLabel.frame) + 10.0f, CGRectGetWidth(self.view.bounds) - 2*15.0f, CGRectGetHeight(self.view.bounds) - 260.0f)];
    _textView.layer.cornerRadius = 4.0f;
    _textView.delegate = self;
    _textView.keyboardAppearance = UIKeyboardAppearanceDefault;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.font = [UIFont systemFontOfSize:12.0f];
    _textView.placeholder = @"";
    [top addSubview:_textView];
    _textVeri = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+(CGRectGetWidth(self.view.bounds) - 2*15.0f)/2, CGRectGetMaxY(tLabel.frame) + 10.0f, (CGRectGetWidth(self.view.bounds) - 2*15.0f)/2, CGRectGetHeight(self.view.bounds) - 260.0f)];
    _textVeri.textAlignment = NSTextAlignmentRight;
    _textVeri.textColor = [UIColor redColor];
    _textVeri.font = [UIFont systemFontOfSize:12.0f];
    _textVeri.backgroundColor = [UIColor clearColor];
    _textVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _textVeri.text = @"超出有效长度";
    _textVeri.numberOfLines = 0;
    _textVeri.hidden = YES;
    [top addSubview:_textVeri];
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, height - 60.0f, width, 60.0f)];
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitleColor:RGB(90, 90, 90) forState:UIControlStateNormal];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [sendBtn addTarget:self action:@selector(sendFeedback) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:top];
    
    [self.view addSubview:sendBtn];
    
    self.feedback = [[TSWFeedback alloc] initWithBaseURL:TSW_API_BASE_URL path:TSW_FEEDBACK];
    
    [self.feedback addObserver:self
                    forKeyPath:kResourceLoadingStatusKeyPath
                       options:NSKeyValueObservingOptionNew
                       context:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_feedback removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _feedback) {
            if (_feedback.isLoaded) {
                [self hideLoadingView];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲的反馈，服务小伙伴会尽快处理，感谢支持!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.tag = 1;
                [alert show];
            }
            else if (_feedback.error) {
                [self showErrorMessage:[_feedback.error localizedFailureReason]];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1){
        if (buttonIndex == 0) {
            _textView.text = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if(alertView.tag == 2){
        if(buttonIndex == 1) {
            _textView.text = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)sendFeedback
{
    if(_textView.text.length>0){
        if(_textView.text.length<=256){
            _textVeri.hidden = YES;
            [self showLoadingViewWithText:@"提交中..."];
            [self.feedback loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"content":_textView.text}];
        }else{
            _textVeri.hidden = NO;
        }
    }else{
        _textVeri.text = @"请填写反馈描述";
        _textVeri.hidden = NO;
    }
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else {
        return YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if(textView.tag ==1){
        if(_textView.text.length>0){
            if(_textView.text.length<=256){
                _textVeri.hidden = YES;
            }else{
                _textVeri.hidden = NO;
            }
        }else{
            _textVeri.text = @"请填写反馈描述";
            _textVeri.hidden = NO;
        }
    }
    
    return YES;
}

- (void)addLeftNavigatorButton
{
    [self.navigationBar.leftButton removeFromSuperview];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 44.0f, 21.0f+30.0, self.navigationBarHeight)];
    [leftButton setImage:[UIImage imageNamed:@"back_icon_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back_icon_highlighted"] forState:UIControlStateHighlighted];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 23)];
    [leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftButton = leftButton;
}

-(void)leftButtonTapped:(UIButton *)sender{
    // 放弃信息反馈应出现提示框”亲,要放弃反馈吗?””确定””取消”
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲,要放弃反馈吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 2;
    [alert show];
}

@end
