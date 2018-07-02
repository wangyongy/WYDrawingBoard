//
//  WYDrawView.h
//  WYPhotoEditor
//
//  Created by 王勇 on 2018/6/25.
//  Copyright © 2018年 王勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYDrawView : UIImageView

@property (nonatomic, strong) UIColor * lineColor;                          //线条颜色

@property(nonatomic,assign)CGFloat lineWidth;                               //线条宽度

@property(nonatomic,assign)BOOL isDrawing;                                  //是否正在绘制

@property(nonatomic,copy) void(^isDrawingBlock)(BOOL isDrawing);            //isDrawing值改变时的回调

@property (nonatomic, strong) NSMutableArray * pointArray;                  //画板上所有点的集合
/**
 初始化
 
 @param frame frame
 @param lineColorBlock 返回值为线条颜色的回调
 @param lineWidthBlock 返回值为线条宽度的回调
 @param isEraserBlock 返回值为是否是橡皮擦的回调
 @return drawView
 */
- (instancetype)initWithFrame:(CGRect)frame lineColorBlock:(UIColor *(^)(void))lineColorBlock lineWidthBlock:(CGFloat(^)(void))lineWidthBlock isEraserBlock:(BOOL(^)(void))isEraserBlock;
/**
 开始/结束绘制,默认是直接开始的
 
 @param start YES:开始  NO:结束
 */
- (void)startDrawing:(BOOL)start;

/**
 清除所有线段,并移除所有的point
 */
- (void)clearLines;
/**
 撤销上一步操作
 */
- (void)revoke;

/**
 显示绘制的图案
 */
- (void)showLines;
/**
 禁止绘图
 */
- (void)forbidDrawing;

@end

@interface WYDrawModel : NSObject

@property (nonatomic, strong) NSMutableArray *pointArray;                   //该操作下的所有点

@property (nonatomic, strong) UIColor * lineColor;

@property(nonatomic,assign) CGFloat lineWidth;

@property(nonatomic,assign) BOOL isEraser;                                  //是否是橡皮擦

- (instancetype)initWithLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth isEraser:(BOOL)isEraser;

@end

