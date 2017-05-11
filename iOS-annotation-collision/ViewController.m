//
//  ViewController.m
//  iOS-annotation-collision
//
//  Created by hanxiaoming on 2017/5/10.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "MyTextAnnotation.h"
#import "MyTextAnnotationView.h"

@interface ViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

// 需要进行碰撞检测的annotation，需要按rank参数排序。由于效率问题，数量不应该太多。
@property (nonatomic, strong) NSArray<MyTextAnnotation *> *collisionAnnotations;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.allowsAnnotationViewSorting = NO;
    
    [self.view addSubview:self.mapView];

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initAnnotations
{
    CLLocationCoordinate2D coordinates[9] = {
        {39.992520, 116.336170},
        {39.998293, 116.352343},
        {40.004087, 116.348904},
        {40.001442, 116.353915},
        {39.989105, 116.353915},
        {39.989098, 116.360200},
        {39.998439, 116.360201},
        {39.979590, 116.324219},
        {39.978234, 116.352792}};
    
    NSMutableArray<MyTextAnnotation *> *arr = [NSMutableArray array];
    for (int i = 0; i < 9; ++i)
    {
        MyTextAnnotation *a = [[MyTextAnnotation alloc] init];
        a.coordinate = coordinates[i];
        a.title      = [NSString stringWithFormat:@"hellohellohello anno :%d", i];
        
        a.rank = rand() % 6;
        
        [arr addObject:a];
    }
    
    arr[0].title = @"爱上打算的爱上打算的爱上打算的爱上打算的爱上打算的爱上打算的";
    arr[1].title = @"卡卡";
    
    
    
    self.collisionAnnotations = [arr sortedArrayUsingComparator:^NSComparisonResult(MyTextAnnotation *  _Nonnull obj1, MyTextAnnotation *  _Nonnull obj2) {
        return obj1.rank < obj2.rank;
    }];
    
    [self.mapView addAnnotations:self.collisionAnnotations];
    [self.mapView showAnnotations:self.collisionAnnotations edgePadding:UIEdgeInsetsMake(50, 100, 100, 100) animated:YES];
}

#pragma mark - 

- (void)mapInitComplete:(MAMapView *)mapView
{
    [self initAnnotations];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MyTextAnnotationView *annotationView = (MyTextAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if(!annotationView) {
            annotationView = [[MyTextAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"marker_blue"];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    NSLog(@"onClick-%@", view.annotation.title);
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //进行碰撞检测
    [self processingCollisionDetection];
}

#pragma mark - 碰撞检测

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

@end
