//
//  TSWMyProjectsEditViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWMyProjectsEditViewController.h"
#import "SZTextView.h"
#import "TSWMyProject.h"
#import "TSWUpdateProject.h"

@interface TSWMyProjectsEditViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) SZTextView *infoView;
@property (nonatomic, strong) TSWMyProject *myProject;

@property (nonatomic, strong) TSWUpdateProject *updateProject;

@property (nonatomic, strong) UILabel *textVeri;
@property (nonatomic, strong) UILabel *infoVeri;
@end

@implementation TSWMyProjectsEditViewController
- (void)dealloc
{
    [_updateProject removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithMyProject:(TSWMyProject *)myProject {
    self = [super init];
    if (self) {
        self.myProject = myProject;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    
    self.view.backgroundColor = RGB(234, 234, 234);
    
    self.navigationBar.title = @"我的项目";
    self.navigationBar.titleView.textColor = RGB(90, 90, 90);
    self.navigationBar.backgroundView.backgroundColor = [UIColor whiteColor];
    
    if ([self.navigationController.viewControllers indexOfObject:self] == 0) {
        CGRect dismissButtonFrame = CGRectMake(00.0f, 0.0f, 21.0f, 44.0f);
        
        UIButton *dismissButton = [[UIButton alloc] initWithFrame:dismissButtonFrame];
        dismissButton.backgroundColor = [UIColor clearColor];
        [dismissButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [dismissButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        [dismissButton setImageEdgeInsets:UIEdgeInsetsMake(0,10.0f,0,0)];
        [dismissButton setTitle:@" " forState:UIControlStateNormal];
        [dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dismissButton setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
        [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationBar.leftButton = dismissButton;
    }
    
    UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height - self.navigationBarHeight)];
    
    UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 24.0f, width - 2*15.0f, 12.0f)];
    tLabel.textAlignment = NSTextAlignmentLeft;
    tLabel.textColor = RGB(90, 90, 90);
    tLabel.font = [UIFont systemFontOfSize:12.0f];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.text = @"项目名称:";
    [top addSubview:tLabel];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(tLabel.frame) + 10.0f, CGRectGetWidth(self.view.bounds) - 2*15.0f, 20.0f)];
    _textField.backgroundColor = [UIColor whiteColor];
    [self setTextFieldLeftPadding:_textField forWidth:5.0f];
    _textField.layer.cornerRadius = 4.0f;
//    _textField.delegate = self;
    _textField.keyboardAppearance = UIKeyboardAppearanceDefault;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.font = [UIFont systemFontOfSize:13.0f];
    _textField.placeholder = @"";
    _textField.text = _myProject.name;
    _textField.tag = 1;
    [top addSubview:_textField];
    _textVeri = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+(CGRectGetWidth(self.view.bounds) - 2*15.0f)/2, CGRectGetMaxY(tLabel.frame) + 10.0f, (CGRectGetWidth(self.view.bounds) - 2*15.0f)/2, 20.0f)];
    _textVeri.textAlignment = NSTextAlignmentRight;
    _textVeri.textColor = [UIColor redColor];
    _textVeri.font = [UIFont systemFontOfSize:13.0f];
    _textVeri.backgroundColor = [UIColor clearColor];
    _textVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _textVeri.text = @"超出有效长度";
    _textVeri.numberOfLines = 0;
    _textVeri.hidden = YES;
    [top addSubview:_textVeri];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(_textField.frame) + 10.0f, width - 2*15.0f, 12.0f)];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.textColor = RGB(90, 90, 90);
    infoLabel.font = [UIFont systemFontOfSize:13.0f];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.text = @"项目简介:";
    [top addSubview:infoLabel];
    
    _infoView = [[SZTextView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(infoLabel.frame) + 10.0f, CGRectGetWidth(self.view.bounds) - 2*15.0f, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(_textField.frame) - 260.0f)];
    _infoView.layer.cornerRadius = 4.0f;
    _infoView.delegate = self;
    _infoView.keyboardAppearance = UIKeyboardAppearanceDefault;
    _infoView.returnKeyType = UIReturnKeyDone;
    _infoView.font = [UIFont systemFontOfSize:13.0f];
    _infoView.placeholder = @"";
    _infoView.text = _myProject.summary;
    _infoView.tag = 2;
    [top addSubview:_infoView];
    _infoVeri = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(infoLabel.frame) + 10.0f+CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(_textField.frame) - 260.0f, CGRectGetWidth(self.view.bounds) - 2*15.0f, 20.0f)];
    _infoVeri.textAlignment = NSTextAlignmentRight;
    _infoVeri.textColor = [UIColor redColor];
    _infoVeri.font = [UIFont systemFontOfSize:13.0f];
    _infoVeri.backgroundColor = [UIColor clearColor];
    _infoVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _infoVeri.text = @"超出有效长度";
    _infoVeri.numberOfLines = 0;
    _infoVeri.hidden = YES;
    [top addSubview:_infoVeri];
    
    [self.view addSubview:top];
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, height - 60.0f, width, 60.0f)];
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitleColor:RGB(90, 90, 90) forState:UIControlStateNormal];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [sendBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    self.updateProject = [[TSWUpdateProject alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[UPDATE_PROJECT stringByAppendingString:@"/"] stringByAppendingString:_myProject.sid] stringByAppendingString:@"/edit"]];
    [self.updateProject addObserver:self
                     forKeyPath:kResourceLoadingStatusKeyPath
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _updateProject){
            if (_updateProject.isLoaded) {
                [self hideLoadingView];
                [self dismiss];
            }
            else if (_updateProject.error) {
                [self showErrorMessage:[_updateProject.error localizedFailureReason]];
            }
        }
    }
}

-(void)dismiss{
    //    [[self getAppdelegate] removeTrackingArrayLastObject];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)finish {
    // 更新项目详情
    if(_textField.text.length > 0)
    {
        if(_textField.text.length<=256){
            _textVeri.hidden = YES;
            if(_infoView.text.length>=0 && _infoView.text.length<=1024){
                    _infoVeri.hidden = YES;
                    [self showLoadingViewWithText:@"提交中..."];
                    [self.updateProject loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"sid":_myProject.sid,@"name":_textField.text,@"summary":_infoView.text}];
            }else if(_infoView.text.length>1024){
                _infoVeri.hidden = NO;
            }
        }else{
            _textVeri.hidden = NO;
        }
    }else{
        _textVeri.text = @"请填写项目名称";
        _textVeri.hidden = NO;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if(textView.tag ==1){
        if(_textField.text.length>0){
            if(_textField.text.length<=256){
                _textVeri.hidden = YES;
            }else{
                _textVeri.hidden = NO;
            }
        }else{
            _textVeri.text = @"请填写项目名称";
            _textVeri.hidden = NO;
        }
    }else{
        if(_infoView.text.length>0 && _infoView.text.length<=1024){
            _infoVeri.hidden = YES;
        }else{
            _infoVeri.hidden = NO;
        }
    }
    
    return YES;
}

-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
@end
