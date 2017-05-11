# iOS-annotation-collision
演示annotation碰撞检测


### 前述

- [高德官方网站申请key](http://id.amap.com/?ref=http%3A%2F%2Fapi.amap.com%2Fkey%2F).
- 阅读[参考手册](http://api.amap.com/Public/reference/iOS%20API%20v2_3D/).
- 工程基于iOS 3D地图SDK实现
- 运行demo请先执行pod install --repo-update 安装依赖库，完成后打开.xcworkspace 文件

### 使用方法
旋转、缩放地图

### 核心类/接口
| 类    | 接口  | 说明   | 版本  |
| -----|:-----:|:-----:|:-----:|
| MyTextAnnotationView |  | 自定义显示文字annotationView | |
| ViewController | - (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated | 地图可视范围变化后回调 | |
| ViewController | - (void)processingCollisionDetection | 进行碰撞检测 |  |

### 核心实现
#### objective-c
```
//碰撞检测
- (void)processingCollisionDetection
{
    NSMutableArray *showedAnnos = [NSMutableArray array];
    
    for (MyTextAnnotation *myAnno1 in self.collisionAnnotations)
    {
        MyTextAnnotationView *view1 = (MyTextAnnotationView *)[self.mapView viewForAnnotation:myAnno1];
        
        if (view1 == nil)
        {
            continue;
        }
        
        BOOL isRightCollision = NO;
        BOOL isLeftCollision = NO;
        
        for (MyTextAnnotation *myAnno2 in showedAnnos)
        {
            MyTextAnnotationView *view2 = (MyTextAnnotationView *)[self.mapView viewForAnnotation:myAnno2];
            NSAssert(view2 != nil, @"view2 should not be nil");
            
            if (isRightCollision && isLeftCollision)
            {
                break;
            }
            
            if (!isRightCollision)
            {
                if (CGRectIntersectsRect(view1.rightRect, view2.showedRect))
                {
                    isRightCollision = YES;
                }
            }
            
            if (!isLeftCollision)
            {
                if (CGRectIntersectsRect(view1.leftRect, view2.showedRect))
                {
                    isLeftCollision = YES;
                }
            }
        } // end for
        if (!isRightCollision)
        {
            view1.direction = MyTextAnnotationViewDirectionRight;
            [showedAnnos addObject:myAnno1];
        }
        else if (!isLeftCollision)
        {
            view1.direction = MyTextAnnotationViewDirectionLeft;
            [showedAnnos addObject:myAnno1];
        }
        else
        {
            view1.direction = MyTextAnnotationViewDirectionNone;
        }
    }
}
```
#### swift
```
暂无
```
