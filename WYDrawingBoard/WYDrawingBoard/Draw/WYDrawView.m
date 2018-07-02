//
//  WYDrawView.m
//  WYPhotoEditor
//
//  Created by 王勇 on 2018/6/25.
//  Copyright © 2018年 王勇. All rights reserved.
//

#import "WYDrawView.h"
#import "WYMain.h"
@interface WYDrawView ()
{
    UIColor *(^_lineColorBlock)(void);
    
    CGFloat (^_lineWidthBlock)(void);
    
    BOOL (^_isEraserBlock)(void);
    
    NSTimer * _showTimer;
}

@property(nonatomic,assign)BOOL isStart;

@end

@implementation WYDrawView

- (void)dealloc
{
    [_showTimer invalidate];
    
    _showTimer = nil;
}
- (instancetype)initWithFrame:(CGRect)frame lineColorBlock:(UIColor *(^)(void))lineColorBlock lineWidthBlock:(CGFloat(^)(void))lineWidthBlock isEraserBlock:(BOOL(^)(void))isEraserBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        
        self.userInteractionEnabled = YES;
        
        self.isStart = YES;
        
        _lineColorBlock = lineColorBlock;
        
        _lineWidthBlock = lineWidthBlock;
        
        _isEraserBlock = isEraserBlock;

        WS(weakSelf)
        
        UITapGestureRecognizer * tap = [UITapGestureRecognizer initWithBlockAction:^(UIGestureRecognizer *sender) {
            
            weakSelf.isDrawing = !weakSelf.isDrawing;
        }];
        
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (NSMutableArray *)pointArray
{
    if (!_pointArray) {
        
        _pointArray = [NSMutableArray array];
    }
    
    return _pointArray;
}
- (UIColor *)lineColor
{
    return _lineColorBlock() ? : [UIColor redColor];
}
- (CGFloat)lineWidth
{
    return _lineWidthBlock() ? : 2.0;
}
- (void)setIsDrawing:(BOOL)isDrawing
{
    _isDrawing = isDrawing;
    
    if (self.isDrawingBlock) {
        self.isDrawingBlock(_isDrawing);
    }
}
#pragma mark - public

- (void)startDrawing:(BOOL)start
{
    self.isStart = start;
}
- (void)clearLines
{
    self.image = nil;
    
    [self.pointArray removeAllObjects];

}
- (void)revoke
{
    if (!self.pointArray.count) return;
    
    [self.pointArray removeObject:self.pointArray.lastObject];
    
    self.image = nil;
    
    [self showLines];
}

- (void)showLines
{
    self.image = nil;
    
    if (!self.pointArray.count) return;
    
    CGPoint previousPoint;
    
    for (WYDrawModel * model in self.pointArray) {

        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self.image drawAtPoint:CGPointZero];
        
        CGContextSetLineWidth(context, model.lineWidth);
        
        CGContextSetStrokeColorWithColor(context, model.lineColor.CGColor);
        
        CGContextSetLineCap(context, kCGLineCapRound);
        
        if(model.isEraser){
            
            CGContextSetBlendMode(context, kCGBlendModeClear);
        }
        
        previousPoint = CGPointFromString(model.pointArray.firstObject);

        for (NSString * pointStr in model.pointArray) {
            
            CGPoint currentPoint = CGPointFromString(pointStr);
            
            CGContextMoveToPoint(context, previousPoint.x, previousPoint.y);
            
            CGContextAddQuadCurveToPoint(context, previousPoint.x, previousPoint.y, currentPoint.x, currentPoint.y);
            
            previousPoint = currentPoint;
            
        }
        
        CGContextStrokePath(context);
        
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
}
- (void)forbidDrawing
{
    self.isStart = NO;
}
#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isStart) return;
    
    [_showTimer setFireDate:[NSDate distantFuture]];

    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:self];
    
    WYDrawModel * model = [[WYDrawModel alloc] initWithLineColor:self.lineColor lineWidth:self.lineWidth isEraser:_isEraserBlock()];

    [model.pointArray addObject:NSStringFromCGPoint(currentPoint)];
    
    [self.pointArray addObject:model];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (!self.isStart) return;
    
    self.isDrawing = YES;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:self];
    
    CGPoint previousPoint = [touch previousLocationInView:self];
    
    WYDrawModel * model = [self.pointArray lastObject];
    
    [model.pointArray addObject:NSStringFromCGPoint(currentPoint)];
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.image drawAtPoint:CGPointZero];
    
    CGContextSetLineWidth(context, self.lineWidth);
    
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if(_isEraserBlock()){
        
        CGContextSetBlendMode(context, kCGBlendModeClear);
    }
    
    CGContextMoveToPoint(context, previousPoint.x, previousPoint.y);
    
    CGContextAddQuadCurveToPoint(context, previousPoint.x, previousPoint.y, currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(context);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isDrawing == NO) return;
    
    WS(weakSelf)

    _showTimer = [NSTimer homedScheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer *timer) {
        
        weakSelf.isDrawing = NO;
    }];
}
@end

@implementation WYDrawModel

- (instancetype)initWithLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth isEraser:(BOOL)isEraser
{
    self = [super init];
    
    if (self) {
        
        self.lineWidth = lineWidth;
        
        self.lineColor = lineColor;
        
        self.isEraser = isEraser;
        
        self.pointArray = [NSMutableArray array];
    }
    
    return self;
}

@end
