//
//  MyTextAnnotationView.h
//  iOS-annotation-collision
//
//  Created by hanxiaoming on 2017/5/10.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

typedef NS_ENUM(NSInteger, MyTextAnnotationViewDirection)
{
    MyTextAnnotationViewDirectionNone  = 0,
    MyTextAnnotationViewDirectionLeft  = 1,
    MyTextAnnotationViewDirectionRight  = 2,
};


@interface MyTextAnnotationView : MAAnnotationView

@property (nonatomic, assign) MyTextAnnotationViewDirection direction;

///更新title
- (void)updateLabelWithTitle:(NSString *)title;

///右侧碰撞区域
- (CGRect)rightRect;

///左侧碰撞区域
- (CGRect)leftRect;

///当前显示碰撞区域
- (CGRect)showedRect;

@end
