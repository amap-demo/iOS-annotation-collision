//
//  MyTextAnnotationView.m
//  iOS-annotation-collision
//
//  Created by hanxiaoming on 2017/5/10.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "MyTextAnnotationView.h"

#define kMaxLabelWidth          128
#define kMaxLabelHeight         64

@interface MyTextAnnotationView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MyTextAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _direction = MyTextAnnotationViewDirectionRight;
    }
    
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setDirection:_direction];
}

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    [self updateLabelWithTitle:annotation.title];
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.numberOfLines = 3;
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (void)setDirection:(MyTextAnnotationViewDirection)direction
{
    _direction = direction;
    if (_direction == MyTextAnnotationViewDirectionNone)
    {
        self.titleLabel.hidden = YES;
    }
    else
    {
        if (direction == MyTextAnnotationViewDirectionRight)
        {
            // right
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            
            self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.bounds), -fabs(CGRectGetHeight(self.bounds) / 2.0 - self.titleLabel.frame.size.height / 2.0), self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        }
        else if (direction == MyTextAnnotationViewDirectionLeft)
        {
            // left
            self.titleLabel.textAlignment = NSTextAlignmentRight;
            
            self.titleLabel.frame = CGRectMake(-self.titleLabel.frame.size.width, -fabs(CGRectGetHeight(self.bounds) / 2.0 - self.titleLabel.frame.size.height / 2.0), self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        }
        
        self.titleLabel.hidden = NO;
    }
}


- (void)updateLabelWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
    //    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: _titleLabel.font}];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(kMaxLabelWidth, kMaxLabelHeight) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil];
    
    
    self.titleLabel.frame = rect;
    
    //update frame
    [self setDirection:_direction];
}

- (CGRect)rightRect
{
    return CGRectMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame) - self.titleLabel.frame.size.height / 2.0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
}

- (CGRect)leftRect
{
    return CGRectMake(CGRectGetMinX(self.frame) - self.titleLabel.frame.size.width, CGRectGetMidY(self.frame) - self.titleLabel.frame.size.height / 2.0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
}

- (CGRect)showedRect
{
    CGRect result = CGRectZero;
    
    switch (_direction) {
        case MyTextAnnotationViewDirectionRight:
            result = self.rightRect;
            break;
        case MyTextAnnotationViewDirectionLeft:
            result = self.leftRect;
            break;
            
        case MyTextAnnotationViewDirectionNone:
        default:
            break;
    }
    
    return result;
}

#pragma mark -

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];

    if (!inside)
    {
        inside = [self.titleLabel pointInside:[self convertPoint:point toView:self.titleLabel] withEvent:event];
    }
    
    return inside;
}


@end







