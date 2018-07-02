//
//  WYDrawingBoardView.m
//  WYDrawingBoard
//
//  Created by 王勇 on 2018/7/2.
//  Copyright © 2018年 王勇. All rights reserved.
//

#import "WYDrawingBoardView.h"
#import "WYSelectView.h"
#import "WYDrawView.h"
#import "WYMain.h"
@implementation WYDrawingBoardView
{
    WYSelectView * _selectView;
    
    WYDrawView * _drawView;
}

#pragma mark - public
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
    }
    return self;
}
- (UIImage *)image
{
    return _drawView.image;
}
- (void)clearLines
{
    [_drawView clearLines];
}
#pragma mark - private
- (void)setupViews
{
    
    WS(weakSelf)
    
    _selectView = [[WYSelectView alloc] initWithFrame:CGRectMake(0, self.Height - 150, self.Width, 150)];
    
    _selectView.revokeBlock = ^{
        
        ST(strongSelf)
        
        [strongSelf -> _drawView revoke];
    };
    
    _drawView = [[WYDrawView alloc] initWithFrame:self.bounds lineColorBlock:^UIColor *{
        
        ST(strongSelf)
        
        return strongSelf->_selectView.currentColor;
        
    } lineWidthBlock:^CGFloat{
        
        ST(strongSelf)
        
        return strongSelf->_selectView.lineWidth;
        
    } isEraserBlock:^BOOL{
        
        ST(strongSelf)
        
        return strongSelf->_selectView.isEraser;
        
    }];
    
    _drawView.backgroundColor = [UIColor whiteColor];
    
    _drawView.isDrawingBlock = ^(BOOL isDrawing) {
        
        ST(strongSelf)
        
        if (strongSelf->_selectView.alpha == 1) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                strongSelf->_selectView.alpha = !isDrawing;
            }];
            
        }else if (strongSelf->_selectView.alpha == 0){
            
            [UIView animateWithDuration:0.5 animations:^{
                
                strongSelf->_selectView.alpha = !isDrawing;
            }];
        }
    };
    
    [self addSubview:_drawView];
    
    [self addSubview:_selectView];
    
}

@end
