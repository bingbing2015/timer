//
//  ViewController.m
//  倒计时
//
//  Created by Linjiasong_Mac on 15-5-28.
//  Copyright (c) 2015年 Linjiasong_Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *myBtn;
@property (strong, nonatomic) IBOutlet UIButton *muButton;


@property (nonatomic,strong) NSTimer * countDownTimer;
@property (nonatomic,assign) NSInteger secondsCountDown;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  //1、NSTimer
  self.secondsCountDown = 5;
  self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(actionBtn) userInfo:nil repeats:YES];
  
  //2、GCD
  __block int timeout=10; //倒计时时间
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
  dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
  dispatch_source_set_event_handler(_timer, ^{
    if(timeout<=0){ //倒计时结束，关闭
      dispatch_source_cancel(_timer);
      dispatch_async(dispatch_get_main_queue(), ^{
        //设置界面的按钮显示 根据自己需求设置
        [self.muButton setTitle:@"倒计时完成" forState:UIControlStateNormal];
      });
    }else{
//      int minutes = timeout / 60;
//      int seconds = timeout % 60;
//      NSString *strTime = [NSString stringWithFormat:@"%d分%.2d秒后重新获取验证码",minutes, seconds];
      dispatch_async(dispatch_get_main_queue(), ^{
        //设置界面的按钮显示 根据自己需求设置
        [self.muButton setTitle:[NSString stringWithFormat:@"%d",timeout] forState:UIControlStateNormal];
      });
      timeout--;
      
    }
  });
  dispatch_resume(_timer);
}

- (void)actionBtn{
  if (self.secondsCountDown > 0) {
    self.secondsCountDown--;
    [self.myBtn setTitle:[NSString stringWithFormat:@"%ld",self.secondsCountDown] forState:UIControlStateNormal];
  }
  else{
    [self.myBtn setTitle:@"倒计时success" forState:UIControlStateNormal];
    [self.countDownTimer invalidate];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
