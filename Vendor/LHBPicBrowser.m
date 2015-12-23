//
//  LHBPicBrowser.m
//  tianshiwan
//
//  Created by 刘鸿博 on 15/12/11.
//  Copyright © 2015年 tianshiwan. All rights reserved.
//

#import "LHBPicBrowser.h"

static CGRect oldframe;

@implementation LHBPicBrowser
+(void)showImage:(UIImageView *)avatarImageView{
    
    UIImage *image=avatarImageView.image;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake( 0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.tag = 100;
    backgroundView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    imageView.tag = 101;
    
    [backgroundView addSubview:imageView];
    
    [window addSubview:backgroundView];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [imageView addGestureRecognizer:pinch];
   
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [imageView addGestureRecognizer:pan];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
   [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
    imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2,
    [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
    backgroundView.alpha = 1;
         
     }
     completion:^(BOOL finished) {
         
         
         
     }];
    //[pinch addObserver:pan forKeyPath:@"scale" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}



+ (void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView *backgroundView=tap.view;
    
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
         
    imageView.frame =oldframe;
         
    backgroundView.alpha=0;
         
     }
     completion:^(BOOL finished) {
    [backgroundView removeFromSuperview];
         
     }];
    
}

+ (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    //创建一个消息对象
    //仿射变换 -- 缩放视图.
    //以上一次缩放之后的状态为基准, 宽高按scale比例缩放.
    if (pinch.scale > (oldframe.size.width/pinch.view.frame.size.width) *1.1 ) {
        pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
        //将之前的缩进量置1, 因为缩放比例是连乘的.
        //[pinch setScale:1];
        pinch.scale = 1.0;
    }
}
+ (void)handlePan:(UIPanGestureRecognizer *)gesture {
    
    //1.获取平移的增量.
    CGPoint increment = [gesture translationInView:gesture.view];//在哪一个视图上移动 gesture.view
    //2.改变视图的位置. --- 仿射变换(让视图上的每个点发生变化).
    //Translate -- 平移
    //tx:横轴位移的距离 ty:纵轴移动的距离
//    UIImageView *backgroudView = [gesture.view viewWithTag:100];
//    UIImageView *imageView = [gesture.view viewWithTag:101];
    
    gesture.view.transform = CGAffineTransformTranslate(gesture.view.transform, increment.x * 0.5, increment.y * 0.5);
    
    //3.因为系统计算的增量是相对于第一次的增量,增量增加,我们只需要将之前增量置0即可.
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

@end
