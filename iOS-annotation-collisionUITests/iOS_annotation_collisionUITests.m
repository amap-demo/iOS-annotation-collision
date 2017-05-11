//
//  iOS_annotation_collisionUITests.m
//  iOS-annotation-collisionUITests
//
//  Created by hanxiaoming on 2017/5/11.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface iOS_annotation_collisionUITests : XCTestCase

@end

@implementation iOS_annotation_collisionUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    XCUIElement *mapElement = [[XCUIApplication alloc] init].otherElements[@"maannotationcontainer"];
    
    [mapElement twoFingerTap];
    [mapElement twoFingerTap];
    
    [mapElement doubleTap];
    
    [mapElement rotate:M_PI_4 withVelocity:3];
    
    [mapElement rotate:M_PI_4 withVelocity:3];
    
    [mapElement doubleTap];
    
    sleep(1);
}

@end
