//
//  ImagesCarouselo.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/13.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#define Duration 3
#define AlphaChangeDuration 1

#import "ImagesCarousel.h"

@interface ImagesCarousel()
{
    NSTimer *_timer;
    NSInteger _currentIndex;
    UIPageControl *_pageControl;
    CGPoint _startPoint;
    UIImageView *_imageView;
    NSArray *_images;
    BOOL _canPan;
    BOOL _moveToPrevious;

}
@end
@implementation ImagesCarousel
static ImagesCarousel *singleton = nil;
+ (ImagesCarousel *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc]init];
    });
    return singleton;
}

- (void) startCarouselWithImages:(NSArray *)images andImageView:(UIImageView *)imageView
{
    [self stopCarousel];
    _images = images;
    _imageView = imageView;
    imageView.image = images[0];
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = images.count;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor blackColor];

    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    pageControl.currentPage = 0;
    _pageControl = pageControl;
    [imageView addSubview:pageControl];
    NSLayoutConstraint *leadingCon = [NSLayoutConstraint constraintWithItem:pageControl attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *trailingCon = [NSLayoutConstraint constraintWithItem:pageControl attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *bottomCon = [NSLayoutConstraint constraintWithItem:pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *heightCon = [NSLayoutConstraint constraintWithItem:pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    [imageView addConstraints:@[leadingCon,trailingCon,bottomCon,heightCon]];
    
    imageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    _canPan = YES;
    imageView.gestureRecognizers = @[panGesture];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:Duration target:self selector:@selector(showNextImage:) userInfo:nil repeats:YES];
    
    
}

- (void) stopCarousel
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _currentIndex = 0;
}
//MARK:Helper
- (void) showNextImage:(NSTimer *)timer
{
    if (!_moveToPrevious) {
        _currentIndex ++;
        if (0 == _currentIndex % _images.count) {
            _currentIndex = 0;
        }
        _pageControl.currentPage = _currentIndex;
        _imageView.image = _images[_currentIndex];
        _imageView.alpha = 0;
        [UIView animateWithDuration:AlphaChangeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _imageView.alpha = 1;
        } completion:nil];
        
    }else{
        
        _moveToPrevious = NO;
        _currentIndex --;
        if (0 > _currentIndex) {
            _currentIndex = _images.count - 1;
        }
        _pageControl.currentPage = _currentIndex;
        _imageView.image = _images[_currentIndex];
        _imageView.alpha = 0;
        [UIView animateWithDuration:AlphaChangeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _imageView.alpha = 1;
        } completion:nil];
         
    }
    
    
}
//MARK:UIGestureRecognizerHandler
- (void) handleGesture:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            _timer.fireDate = [NSDate distantFuture];
            _startPoint = [panGesture locationInView:_imageView];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (_canPan) {
                CGPoint currentPoint = [panGesture locationInView:_pageControl];
                if (10 < currentPoint.x - _startPoint.x) {
                    _moveToPrevious = YES;
                    _canPan = NO;
                    _timer.fireDate = [NSDate date];
                    
                }else if(-10 > currentPoint.x - _startPoint.x){
                    _moveToPrevious = NO;
                    _canPan = NO;
                    _timer.fireDate = [NSDate date];
                }

            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            if (_canPan) {
                _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:Duration];
            }
            _canPan = YES;
            
        }
        default:
            break;
    }

    

}
@end
