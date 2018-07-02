//
//  ViewController.m
//  WYPhotoEditor
//
//  Created by 王勇 on 2018/6/25.
//  Copyright © 2018年 王勇. All rights reserved.
//

#import "ViewController.h"
#import "WYMain.h"
#import "WYDrawingBoardView.h"
@interface ViewController ()
{
    WYDrawingBoardView * _drawingBoardView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStyleDone target:self action:@selector(replayButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearButtonAction:)];
    
    _drawingBoardView = [[WYDrawingBoardView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_drawingBoardView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - action
- (void)replayButtonAction:(UIButton *)sender
{

    WS(weakSelf)
    
    [UIAlertController showWithTitle:@"确定保存到手机相册?" message:@"" cancelTitle:@"取消" cancelHandler:nil confirmTitle:@"确定" confirmHandler:^{
        
        ST(strongSelf)
        
        if (strongSelf->_drawingBoardView.image) {
            
            UIImageWriteToSavedPhotosAlbum(strongSelf->_drawingBoardView.image, strongSelf,
                                           @selector(image:didFinishSavingWithError:contextInfo:),
                                           nil);
        }
    }];
}
- (void)clearButtonAction:(UIButton *)sender
{
    [_drawingBoardView clearLines];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
  
        [UIAlertController showWithTitle:@"已存入手机相册" message:nil cancelTitle:nil cancelHandler:nil confirmTitle:@"确定" confirmHandler:nil];
        
    }else{
        
        [UIAlertController showWithTitle:@"保存失败" message:[NSString stringWithFormat:@"请打开 设置-隐私-照片 对该应用设置为打开"] cancelTitle:nil cancelHandler:nil confirmTitle:@"确定" confirmHandler:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
