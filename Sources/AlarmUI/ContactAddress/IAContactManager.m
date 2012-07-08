//
//  IAContactManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLocation.h"
#import "YCParam.h"
#import <QuartzCore/QuartzCore.h>
#import "AlarmPositionMapViewController.h"
#import <AddressBook/AddressBook.h>
#import "YCLib.h"
#import "IAPerson.h"
#import "IAAlarm.h"
#import "LocalizedString.h"
#import "IAContactManager.h"


#define kPersonImageWidth                  64.0
#define kPersonImageHeight                 64.0
#define kPersonImageOrigin                 (CGPoint){19.0, 15.0}
#define kPersonImageSize                   (CGSize) {kPersonImageWidth, kPersonImageHeight}
//#define kPersonImageFrame                  (CGRect) {kPersonImageOrigin, kPersonImageSize}

#define kPersonViewWidth                   320.0
#define kPersonViewHeight                  416.0
#define kPersonViewSize                    (CGSize) {kPersonViewWidth, kPersonViewHeight}

#define kMapViewShadowWidth                365.0
#define kMapViewShadowHeight               461.0
#define kMapViewShadowSize                 (CGSize) {kMapViewShadowWidth, kMapViewShadowHeight}
#define kMapViewShadowAnchorPoint          (CGPoint){(4+kPersonViewWidth/2)/kMapViewShadowWidth,(7+kPersonViewHeight/2)/kMapViewShadowHeight}
//阴影的左边缘:4，上边缘:6

#define kDegreesForTakeImage               1500.0


@interface IAContactManager (private) 

- (MKMapView *)_mapView;
- (UIBarButtonItem*)_cancelButtonItem;
- (ABUnknownPersonViewController*)_unknownPersonViewControllerWithIAPerson:(IAPerson*)thePerson;
- (ABPersonViewController*)_personViewControllerWithIAPerson:(IAPerson*)thePerson;
//更新视图
- (void)_updateViewController:(UIViewController*)viewController person:(IAPerson*)thePerson;

/**
 统一ABUnknownPersonViewController和ABPersonViewController的点属性的委托方法
 **/
- (void)_viewController:(UIViewController *)viewController personImage:(UIImage*)personImage;

@end

@implementation IAContactManager
@synthesize currentViewController = _currentViewController, animationKind = _animationKind; 

- (void)setCurrentViewController:(UIViewController *)currentViewController{
    //相当于 delegate，不用retain
    _currentViewController = currentViewController;
    
    _delayForWaitingStartLoadingMap = 1.0; //每次新打开一个闹钟都会重新设置这个。做了单例，就得这么用了
}


- (MKMapView *)_mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:(CGRect){{0, 0},kPersonViewSize}];
        _mapView.showsUserLocation = NO;
        _mapView.scrollEnabled = NO;
        _mapView.zoomEnabled = NO;
    }
    _mapView.layer.bounds = (CGRect){{0, 0},kPersonViewSize}; //免得抓图给弄坏了
    return _mapView;
}

- (id)_cancelButtonItem{
    if (!_cancelButtonItem) {
        _cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonItemPressed:)];
    }
    return _cancelButtonItem;
}

- (ABUnknownPersonViewController*)_unknownPersonViewControllerWithIAPerson:(IAPerson*)thePerson{
    
    if (!_unknownPersonVC) {
        _unknownPersonVC = [[ABUnknownPersonViewController alloc] init];
        _unknownPersonVC.unknownPersonViewDelegate = self;
    }
    
    if (thePerson) {
        _unknownPersonVC.alternateName = thePerson.organization ? thePerson.organization : thePerson.personName;//优先显示organization
        _unknownPersonVC.displayedPerson = thePerson.ABPerson;
        BOOL isAllowsAddingToAddressBook = (thePerson.addressDictionaries.count >0);
        _unknownPersonVC.allowsAddingToAddressBook = isAllowsAddingToAddressBook;
    }
    
     _unknownPersonVC.title = KLabelAlarmPostion;
    return _unknownPersonVC;
}

- (ABPersonViewController*)_personViewControllerWithIAPerson:(IAPerson*)thePerson{
    
    if (!_personVC) {
        _personVC = [[ABPersonViewController alloc] init];
        _personVC.personViewDelegate = self;
        
        
        
        NSArray *displayedItems = [NSArray arrayWithObjects:
                                   [NSNumber numberWithInt:kABPersonPhoneProperty]
                                   ,[NSNumber numberWithInt:kABPersonAddressProperty]
                                   ,[NSNumber numberWithInt:kABPersonNoteProperty]
                                   ,nil];
        _personVC.displayedProperties = displayedItems;
        
        //_personVC.allowsEditing = YES; //不能让编辑。编辑状态会把关闭按钮给冲掉的。//但没有编辑，高亮不好用
    }
    
    if (thePerson) {
        _personVC.displayedPerson = thePerson.ABPerson;
    }
    _personVC.navigationItem.rightBarButtonItem = nil; //4.0系统竟然有个右取消按钮
    _personVC.title = KLabelAlarmPostion;
    return _personVC;
}

- (void)_updateViewController:(UIViewController*)viewController person:(IAPerson*)thePerson{
    //4.x必须要一个空人才行
    IAPerson *emptyPerson = [[[IAPerson alloc] initWithPersonId:kABRecordInvalidID organization:nil addressDictionary:nil] autorelease];
    
    if (viewController == _unknownPersonVC) {
        _unknownPersonVC.displayedPerson = emptyPerson.ABPerson;
        [self _unknownPersonViewControllerWithIAPerson:thePerson];
    }else if (viewController == _personVC){
        _personVC.displayedPerson = emptyPerson.ABPerson;
        [self _personViewControllerWithIAPerson:thePerson];
    }
}

- (void)_viewController:(UIViewController *)viewController personImage:(UIImage*)personImage{
    
    [_alarmPositionVC release];
    _alarmPositionVC = [[AlarmPositionMapViewController alloc] initWithNibName:@"AlarmPositionMapViewController" bundle:nil alarm:_alarm];
    
    _alarmPositionVC.delegate = self;
    [_alarmPositionVC view];
    
    //重新定位照片
    CGRect personImageFrame = (CGRect) {kPersonImageOrigin, kPersonImageSize};
    if (viewController.view.subviews.count > 0) {
        //找到包含照片的tableview
        NSUInteger index = [viewController.view.subviews indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UITableView class]]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        UITableView *personTableView = nil;
        if (NSNotFound != index) {
            personTableView = [viewController.view.subviews objectAtIndex:index];
        }
        
        CGFloat offsetX = personTableView.contentOffset.x;
        CGFloat offsetY = personTableView.contentOffset.y;
        offsetY = (offsetY < 85 ) ? offsetY : 85;
        
        //根据tableview的offset重新定位照片
        if (personTableView) {
            personImageFrame = CGRectOffset(personImageFrame, -offsetX, -offsetY);
        }
    }
    
    //根
    CALayer *rootLayer = viewController.view.layer;
    
    //容器
    _containerLayer = [[CALayer layer] retain];
    _containerLayer.bounds = (CGRect){{0,0},kPersonImageSize};
    _containerLayer.position = YCRectCenter(rootLayer.bounds);
    _containerLayer.masksToBounds = NO;
    [rootLayer addSublayer:_containerLayer];
    
    //阴影
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.contents = (id)[UIImage imageNamed:@"IAMapAnimationShadow.png"].CGImage;
    shadowLayer.bounds = (CGRect){{0,0},kMapViewShadowSize};
    shadowLayer.position = YCRectCenter(_containerLayer.bounds);
    shadowLayer.anchorPoint = kMapViewShadowAnchorPoint;
    [_containerLayer addSublayer:shadowLayer];
    
    
    //地图
    CLLocationCoordinate2D lbcoordinate = _alarm.visualCoordinate;
    lbcoordinate = CLLocationCoordinate2DIsValid(lbcoordinate) ? lbcoordinate : _mapView.centerCoordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(lbcoordinate, kDegreesForTakeImage, kDegreesForTakeImage);
    region = [_alarmPositionVC.mapView regionThatFits:region];
    [_alarmPositionVC.mapView setRegion:region];
    
       //保存为了恢复
    _mapLayerSuperLayer =  [_alarmPositionVC.mapView.layer.superlayer retain];
    _mapLayerPosition = _alarmPositionVC.mapView.layer.position; 
    _mapLayerBounds = _alarmPositionVC.mapView.layer.bounds;  
    
    _mapLayer = [_alarmPositionVC.mapView.layer retain];
    _mapLayer.position = YCRectCenter(_containerLayer.bounds);
    [_containerLayer addSublayer:_mapLayer];
    
    //personImage
    CALayer *personImageLayer = [CALayer layer];
    personImageLayer.contents = (id)personImage.CGImage;
    personImageLayer.bounds = (CGRect){{0,0},kPersonImageSize};
    personImageLayer.position = YCRectCenter(_containerLayer.bounds);
    personImageLayer.opacity = 0.0;
    [_containerLayer addSublayer:personImageLayer];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents]; //停止用户响应
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.75];
    
    //地图放大
    CABasicAnimation *scaleAnimation=[CABasicAnimation animationWithKeyPath: @"bounds"];
    scaleAnimation.fromValue= [NSValue valueWithCGRect:(CGRect){{(kPersonViewWidth-kPersonImageWidth)/2,(kPersonViewHeight-kPersonImageHeight)/2},kPersonImageSize}];
    scaleAnimation.toValue= [NSValue valueWithCGRect:_mapLayerBounds];  
    scaleAnimation.timingFunction= [CAMediaTimingFunction functionWithControlPoints:0.7f:0.05f :0.8f:0.9f];//前极慢，后极快,后慢
    scaleAnimation.delegate = self;
    scaleAnimation.removedOnCompletion = YES;
    [_mapLayer addAnimation :scaleAnimation forKey :@"MapScale"]; 
    
    //地图阴影放大
    CABasicAnimation *scale1Animation=[CABasicAnimation animationWithKeyPath: @"bounds"];
    scale1Animation.fromValue= [NSValue valueWithCGRect:(CGRect){{0,0},
        {kMapViewShadowWidth/kPersonViewWidth * kPersonImageWidth, kMapViewShadowHeight/kPersonViewHeight * kPersonImageHeight}}];
    scale1Animation.toValue= [NSValue valueWithCGRect:(CGRect){{0,0},kMapViewShadowSize}];  
    scale1Animation.timingFunction= [CAMediaTimingFunction functionWithControlPoints:0.7f:0.05f :0.8f:0.9f];//前极慢，后极快,后慢
    scale1Animation.removedOnCompletion = YES;
    [shadowLayer addAnimation :scale1Animation forKey :@"ShadowScale"]; 
    
        //渐变 照片变成地图
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.25];
        
        CABasicAnimation *tranAnimation=[CABasicAnimation animationWithKeyPath: @"opacity"];
        tranAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];  //前慢后快
        tranAnimation.fromValue= [NSNumber numberWithFloat:1.0];
        tranAnimation.toValue= [NSNumber numberWithFloat:0.0];   
        tranAnimation.removedOnCompletion = YES;
        [personImageLayer addAnimation :tranAnimation forKey :@"MapShow" ];
        
        [CATransaction commit];
    
        //位置移动
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.7];
        
        CGPoint pmCenter = YCRectCenter(personImageFrame);
        CGMutablePathRef thePath = CGPathCreateMutable();
        CGPathMoveToPoint(thePath,NULL,pmCenter.x,pmCenter.y); //照片的位置 
        CGPathAddCurveToPoint(thePath,NULL ,
                              pmCenter.x,     pmCenter.y+100, 
                              pmCenter.x + 40,pmCenter.y+300, 
                              160,218);//优美的弧线
        
        CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnimation.path=thePath;
        moveAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3f:0.7f :0.5f:0.95f];//前快，后慢;
        moveAnimation.removedOnCompletion = YES;
        [_containerLayer addAnimation:moveAnimation forKey:@"ContainerMove"];
        
        [CATransaction commit];
    
    
    _animationKind = 1;
    [CATransaction commit];
}

- (void)dealloc{
    NSLog(@"IAContactManager dealloc");
    [_alarm release];
    [_cancelButtonItem release];
    [_unknownPersonVC release];
    [_personVC release];
    [_mapView release];
    [_personImageTook release];
    [_alarmPositionVC release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    return [self init];
}


- (void)cancelButtonItemPressed:(id)sender{
    
    if ([_currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [_currentViewController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [_currentViewController dismissModalViewControllerAnimated:YES];
    }
}

- (void)pushContactViewControllerWithAlarm:(IAAlarm*)theAlarm{
    
    
    [_alarm release];
    _alarm = [theAlarm retain];
    
    IAPerson *displayingPerson = nil;
    if (_alarm.person) {
        displayingPerson = [[[IAPerson alloc] initWithPersonId:_alarm.person.personId] autorelease];
    }
    NSUInteger index = [displayingPerson indexOfAddressDictionary:_alarm.placemark.addressDictionary];
    
    //根据情况选择视图
    UIViewController *vc = nil;
    if (!displayingPerson || index == NSNotFound) {
        displayingPerson = [[[IAPerson alloc] initWithAlarm:_alarm image:nil] autorelease];
        [displayingPerson prepareForUnknownPersonDisplay:_alarm image:nil];
        vc = [self _unknownPersonViewControllerWithIAPerson:displayingPerson];
    }else{
        [displayingPerson prepareForDisplay:_alarm image:nil];
        vc = [self _personViewControllerWithIAPerson:displayingPerson];
    }
    
    //打开的视图
    [(UINavigationController*)_currentViewController pushViewController:vc animated:YES];
        
    
    
    /////////////////////////////////////////////////////////
    //截图，放到最后
    NSString *imageName = _alarm.alarmRadiusType.alarmRadiusTypeImageName;
    imageName = [@"Shadow_" stringByAppendingString:imageName];
    UIImage *flagImage = [UIImage imageNamed:imageName];
    CGPoint imageCenter = {6,12};
    self._mapView.visibleMapRect = MKMapRectWorld;
    CLLocationCoordinate2D lbcoordinate = theAlarm.visualCoordinate;
    
    //使用最后一次加载地图的中心坐标
    if(!CLLocationCoordinate2DIsValid(lbcoordinate) && YCMKCoordinateRegionIsValid([YCParam paramSingleInstance].lastLoadMapRegion))        
        lbcoordinate = [YCParam paramSingleInstance].lastLoadMapRegion.center;
    
    //使用缺省坐标
    lbcoordinate = CLLocationCoordinate2DIsValid(lbcoordinate) ? lbcoordinate : kYCDefaultCoordinate;

    //先取一次图
    if (CLLocationCoordinate2DIsValid(lbcoordinate)) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(lbcoordinate, kDegreesForTakeImage, kDegreesForTakeImage);
        region = [self._mapView regionThatFits:region];
        if (!self._mapView.superview) 
            [vc.view addSubview:self._mapView];//必须加到界面上，否则数据不加载
        [self._mapView setRegion:region];
    }else{
        self._mapView.visibleMapRect = MKMapRectWorld;
    }
    
    UIImage *theImage = [self._mapView takeImageWithoutOverlaySize:kPersonImageSize overrideImage:flagImage leftBottomAtCoordinate:lbcoordinate imageCenter:imageCenter];
    [_personImageTook release];
    _personImageTook = [theImage retain];
    if (self._mapView.superview) 
        [self._mapView removeFromSuperview];
    
    
    [displayingPerson setImage:theImage];
    [self _updateViewController:vc person:displayingPerson];
    
    [self performBlock:^{
        vc.title = KLabelAlarmPostion;
        vc.navigationItem.rightBarButtonItem = nil;
        
        //高亮闹钟地址
        if ([vc respondsToSelector:@selector(setHighlightedItemForProperty:withIdentifier:)]) {
            [(ABPersonViewController*)vc setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:0];
        }
    } afterDelay:0.0];
    
    
    //////////////
    
    //把地图加载到界面
    if (CLLocationCoordinate2DIsValid(_alarm.visualCoordinate)) {
        self._mapView.delegate = self;
        if (!self._mapView.superview) 
            [vc.view addSubview:self._mapView];//必须加到界面上，否则数据不加载
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(lbcoordinate, kDegreesForTakeImage, kDegreesForTakeImage);
        region = [self._mapView regionThatFits:region];
        [self._mapView setRegion:region];
        
        //动画的目的是隐藏地图
        CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath: @"opacity"];
        animation.duration = 100;
        animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.4) {//5.0以上
            animation.fromValue= [NSNumber numberWithFloat:0.0];
        }else{
            animation.fromValue= [NSNumber numberWithFloat:0.05];// iOS 4.x 需要这样 
        }
        animation.toValue= [NSNumber numberWithFloat:0.0]; 
        animation.removedOnCompletion = YES;
        [self._mapView.layer addAnimation :animation forKey :@"hideMapView" ];
        
        
        _mapViewDidFinishLoadingMap = YES;
        _mapViewDidStartLoadingMap = NO;
        [self performBlock:^{
            _mapViewDidStartLoadingMap = YES;
            _delayForWaitingStartLoadingMap = 0.2; //第二次以后等的时间短
        } afterDelay:_delayForWaitingStartLoadingMap];
        
        [self performBlock:^{
            _mapViewDidFinishLoadingMap = YES;
        } afterDelay:5.0];
        
        //NSLog(@"前 while _mapViewDidFinishLoadingMap = %d _mapViewDidStartLoadingMap = %d",_mapViewDidFinishLoadingMap,_mapViewDidStartLoadingMap);
        while (!_mapViewDidFinishLoadingMap || !_mapViewDidStartLoadingMap) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            //NSLog(@"中 while _mapViewDidFinishLoadingMap = %d _mapViewDidStartLoadingMap = %d",_mapViewDidFinishLoadingMap,_mapViewDidStartLoadingMap);
        }
        
        //NSLog(@"后 while _mapViewDidFinishLoadingMap = %d _mapViewDidStartLoadingMap = %d",_mapViewDidFinishLoadingMap,_mapViewDidStartLoadingMap);
        
        //再取一次图
        UIImage *theImage = [self._mapView takeImageWithoutOverlaySize:kPersonImageSize overrideImage:flagImage leftBottomAtCoordinate:lbcoordinate imageCenter:imageCenter];
        [self._mapView removeFromSuperview];
        [self._mapView.layer removeAllAnimations];
        self._mapView.delegate = nil;//

        if (theImage) {
            
            [_personImageTook release];
            _personImageTook = [theImage retain];
            
            [displayingPerson setImage:theImage];
            [self _updateViewController:vc person:displayingPerson];
            
            [self performBlock:^{
                vc.title = KLabelAlarmPostion;
                vc.navigationItem.rightBarButtonItem = nil;
                
                //高亮闹钟地址
                if ([vc respondsToSelector:@selector(setHighlightedItemForProperty:withIdentifier:)]) {
                    [(ABPersonViewController*)vc setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:0];
                }
            } afterDelay:0.0];
            
        }
        
        
    }
    else {//坐标无效,打开地图
        [self performSelector:@selector(personImageDidPress) withObject:nil afterDelay:0.5];
    }
    
}

#pragma mark - CAAnimation Delegate Methods
- (void)animationDidStart:(CAAnimation *)theAnimation{
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    
    
    if ([theAnimation.delegate respondsToSelector:@selector(animationKind)]) {
        
        //清理、恢复动画现场
        
        //[CATransaction begin];
        //[CATransaction setValue:(id)kCFBooleanTrue
        //                 forKey:kCATransactionDisableActions];
        
        [_mapLayer removeAllAnimations];
        [_mapLayerSuperLayer addSublayer:_mapLayer];
        _mapLayer.position = _mapLayerPosition;
        _mapLayer.bounds = _mapLayerBounds;
        
        [_containerLayer removeAllAnimations];
        [_containerLayer removeFromSuperlayer];  
        
        //[CATransaction commit];
        
                      
        [_containerLayer release]; _containerLayer = nil;
        [_mapLayer release]; _mapLayer = nil;
        [_mapLayerSuperLayer release]; _mapLayerSuperLayer = nil;
        
        
        if ([theAnimation.delegate animationKind] == 1) {
            [(UINavigationController*) _currentViewController pushViewController:_alarmPositionVC animated:NO];
            
            //清理动画现场也需要时间
            [[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:0.2];
            
        }else if ([theAnimation.delegate animationKind] == 2){
            
            //释放地图view
            NSLog(@"_alarmPositionVC.retainCount = %d",_alarmPositionVC.retainCount);
            [_alarmPositionVC release];
            _alarmPositionVC = nil;
            
            UIViewController *theVC = [(UINavigationController*) _currentViewController topViewController];
            
            //更新ABUnknownPersonViewController
            if (theVC == _unknownPersonVC) {
                IAPerson *displayingIAPerson = [[[IAPerson alloc] initWithAlarm:_alarm image:_personImageTook] autorelease];
                [displayingIAPerson prepareForUnknownPersonDisplay:_alarm image:_personImageTook];
                [self _updateViewController:theVC person:displayingIAPerson];
                //更新alarm中的person
                _alarm.person = displayingIAPerson;
            }
            
            //更新ABPersonViewController
            if (theVC == _personVC) {
                
                //更新alam 中的person 中的照片
                 _alarm.person.image = _personImageTook; 
                
                //界面显示
                IAPerson *displayingIAPerson = [[[IAPerson alloc] initWithPersonId:_alarm.person.personId] autorelease];
                [displayingIAPerson prepareForDisplay:_alarm image:_personImageTook];
                [self _updateViewController:theVC person:displayingIAPerson];
                //更新alarm中的person
                _alarm.person = displayingIAPerson;
            }
            
            //高亮闹钟地址
            if ([theVC respondsToSelector:@selector(setHighlightedItemForProperty:withIdentifier:)]) {
                [(ABPersonViewController*)theVC setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:0];
            }
            
            //不设置竟然给改成默认的了
            theVC.title = KLabelAlarmPostion;
            
            if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
        }
    }
    
}

#pragma mark - ABUnknownPersonViewControllerDelegate

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person{
    if (person) {
        
        //把person、地址索引保存到alarm
        ABRecordID personId = ABRecordGetRecordID(person);
        IAPerson *didResolveToPerson = [[[IAPerson alloc] initWithPersonId:personId] autorelease];
        _alarm.person = didResolveToPerson;
        _alarm.indexOfPersonAddresses = didResolveToPerson.addressDictionaries.count -1; //地址加到了最后一个
        
        //更新联系人，及相关视图
        [didResolveToPerson prepareForDisplay:_alarm image:_personImageTook];
        [self _updateViewController:_personVC person:didResolveToPerson];
        
        //弹出新的
        [(UINavigationController*) _currentViewController popViewControllerAnimated:NO];
        [(UINavigationController*) _currentViewController pushViewController:_personVC animated:NO];
        
        [_personVC setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:0];
        _personVC.navigationItem.rightBarButtonItem = nil;
        _personVC.title = KLabelAlarmPostion;
        
        //竟然需要这样,有时候也不行
        [self performBlock:^{
            [_personVC setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:0];
            _personVC.navigationItem.rightBarButtonItem = nil;
            _personVC.title = KLabelAlarmPostion;
            
        } afterDelay:0.2];
        
    }
    
}



- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    IAPerson *displayingPerson = [[[IAPerson alloc] initWithPerson:person] autorelease];
    UIImage *personImage = displayingPerson.image;
    [displayingPerson prepareForDisplay:_alarm image:[UIImage imageNamed:@"IAPersonNoImage.png"]];
    [self _updateViewController:_unknownPersonVC person:displayingPerson];
    
    //高亮闹钟地址
    if ([personViewController respondsToSelector:@selector(setHighlightedItemForProperty:withIdentifier:)]) {
        [(ABPersonViewController*)personViewController setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:0];
    }
    
    //动画
    [self _viewController:personViewController personImage:personImage];
    
    return NO;
}

#pragma mark - ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue{
    
    if ((kABPersonNoteProperty == property) ||
        (kABPersonKindProperty == property)|| 
        (kABPersonAddressProperty == property) 
        ) 
    {
        //更新界面
        ABRecordID displayedPersonId = ABRecordGetRecordID(person);
        IAPerson *displayedPerson = [[[IAPerson alloc] initWithPersonId:displayedPersonId] autorelease];
        [displayedPerson prepareForDisplay:_alarm image:[UIImage imageNamed:@"IAPersonNoImage.png"]];
        [self _updateViewController:_personVC person:displayedPerson];
            
        //高亮闹钟地址
        [(ABPersonViewController*)personViewController setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:0];
        
        //动画
        IAPerson *thePerson = [[[IAPerson alloc] initWithPerson:person] autorelease];
        UIImage *personImage = thePerson.image;
        [self _viewController:personViewController personImage:personImage];
        
    }
    
    
    return NO;
}

#pragma mark - AlarmPositionMapViewController Delegate Method

- (void)alarmPositionMapViewControllerDidPressDoneButton:(AlarmPositionMapViewController*)alarmPositionMapViewController{
    
    //在截图前做
    MKMapView *theMapView = _mapView;
    [theMapView setRegion:_alarmPositionVC.mapView.region];
    
    //截图,要在弹出视图前做
    CLLocationCoordinate2D lbcoordinate = _alarm.visualCoordinate;
    lbcoordinate = CLLocationCoordinate2DIsValid(lbcoordinate) ? lbcoordinate : theMapView.centerCoordinate;
    [_alarmPositionVC.mapView setCenterCoordinate:lbcoordinate];
    
    NSString *imageName = _alarm.alarmRadiusType.alarmRadiusTypeImageName;
    imageName = [@"Shadow_" stringByAppendingString:imageName];
    UIImage *flagImage = [UIImage imageNamed:imageName];
    CGPoint imageCenter = {6,12};
    
    UIImage *personImage = [_alarmPositionVC.mapView takeImageWithoutOverlaySize:kPersonImageSize overrideImage:flagImage leftBottomAtCoordinate:lbcoordinate imageCenter:imageCenter];
    [_personImageTook release];
    _personImageTook = [personImage retain];
    
    
    //停止用户响应,弹出视图
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents]; 
    [(UINavigationController*) _currentViewController popViewControllerAnimated:NO];
    
    //重新定位照片
    UIViewController *theViewController = [(UINavigationController*)_currentViewController topViewController];
    CGRect personImageFrame = (CGRect) {kPersonImageOrigin, kPersonImageSize};
    if (theViewController.view.subviews.count > 0) {
        //找到包含照片的tableview
        NSUInteger index = [theViewController.view.subviews indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UITableView class]]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        UITableView *personTableView = nil;
        if (NSNotFound != index) {
            personTableView = [theViewController.view.subviews objectAtIndex:index];
        }
        
        CGFloat offsetX = personTableView.contentOffset.x;
        CGFloat offsetY = personTableView.contentOffset.y;
        offsetY = (offsetY < 85 ) ? offsetY : 85;
        
        //根据tableview的offset重新定位照片
        if (personTableView) {
            personImageFrame = CGRectOffset(personImageFrame, -offsetX, -offsetY);
        }
    }

    
    //根
    CALayer *rootLayer = theViewController.view.layer;
    
    //容器
    _containerLayer = [[CALayer layer] retain];
    _containerLayer.bounds = (CGRect){{0,0},kPersonImageSize};
    _containerLayer.position = YCRectCenter(personImageFrame);
    _containerLayer.masksToBounds = NO;
    [rootLayer addSublayer:_containerLayer];
    
    //阴影
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.contents = (id)[UIImage imageNamed:@"IAMapAnimationShadow.png"].CGImage;
    shadowLayer.bounds = _containerLayer.bounds;
    shadowLayer.position = YCRectCenter(_containerLayer.bounds);
    shadowLayer.anchorPoint = kMapViewShadowAnchorPoint;
    [_containerLayer addSublayer:shadowLayer];
    
    
    //地图
         //保存为了恢复
    _mapLayerSuperLayer =  [theMapView.layer.superlayer retain];
    _mapLayerPosition = theMapView.layer.position; 
    _mapLayerBounds = theMapView.layer.bounds; 
    
    _mapLayer = [theMapView.layer retain];
    _mapLayer.position = YCRectCenter(_containerLayer.bounds);
    _mapLayer.bounds = _containerLayer.bounds;
    [_containerLayer addSublayer:_mapLayer];
    
    //personImage layer
    CALayer *personImageLayer = [CALayer layer];
    personImageLayer.contents = (id)personImage.CGImage;
    personImageLayer.bounds = (CGRect){{0,0},kPersonImageSize};
    personImageLayer.position = YCRectCenter(_containerLayer.bounds);
    personImageLayer.opacity = 1.0;
    [_containerLayer addSublayer:personImageLayer];
     
    
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.75];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.4];
    
        //地图缩小
        CABasicAnimation *scaleAnimation=[CABasicAnimation animationWithKeyPath: @"bounds"];
        scaleAnimation.toValue = [NSValue valueWithCGRect:(CGRect){{(kPersonViewWidth-kPersonImageWidth)/2,(kPersonViewHeight-kPersonImageHeight)/2},kPersonImageSize}];
        scaleAnimation.fromValue = [NSValue valueWithCGRect:_mapLayerBounds];
        scaleAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];//前极慢，后极快,后慢
        scaleAnimation.removedOnCompletion = YES;
        [_mapLayer addAnimation :scaleAnimation forKey :@"MapScale1"]; 
        
        //地图阴影缩小
        CABasicAnimation *scale1Animation=[CABasicAnimation animationWithKeyPath: @"bounds"];
        scale1Animation.toValue = [NSValue valueWithCGRect:(CGRect){{0,0},
            {kMapViewShadowWidth/kPersonViewWidth * kPersonImageWidth, kMapViewShadowHeight/kPersonViewHeight * kPersonImageHeight}}];
        scale1Animation.fromValue = [NSValue valueWithCGRect:(CGRect){{0,0},kMapViewShadowSize}];  
        scale1Animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];//前极慢，后极快,后慢
        scale1Animation.removedOnCompletion = YES;
        [shadowLayer addAnimation :scale1Animation forKey :@"ShadowScale"]; 
    
        [CATransaction commit];
    
    
    
    //渐变 地图变成照片
    CABasicAnimation *tranAnimation=[CABasicAnimation animationWithKeyPath: @"opacity"];
    tranAnimation.timingFunction= [CAMediaTimingFunction functionWithControlPoints:0.7f:0.05f :0.8f:0.9f];  //前慢后快
    tranAnimation.fromValue= [NSNumber numberWithFloat:0.0];
    tranAnimation.toValue= [NSNumber numberWithFloat:1.0];   
    tranAnimation.removedOnCompletion = YES;
    [personImageLayer addAnimation :tranAnimation forKey :@"PersonImageShow1" ];
    
    
    //位置移动
    CGPoint pmCenter = YCRectCenter(personImageFrame);    //照片位置
    CGPoint viewCenter = YCRectCenter(rootLayer.bounds);  //视图中心
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,viewCenter.x, viewCenter.y); 
    if (personImageFrame.origin.y > 0) {
        
        CGPathAddCurveToPoint(thePath,NULL ,
                              viewCenter.x + 20, viewCenter.y+40,
                              viewCenter.x - 50, viewCenter.y-140, 
                              pmCenter.x,pmCenter.y);  //右弧线
    }else{
        
        CGPathAddCurveToPoint(thePath,NULL ,
                      pmCenter.x + 40,pmCenter.y+300,
                      pmCenter.x,     pmCenter.y+100, 
                      pmCenter.x,pmCenter.y);  //左弧线
    }
   
    
    CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path=thePath;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.7f:0.05f :0.8f:0.9f];  //前慢后快
    moveAnimation.removedOnCompletion = YES;
    moveAnimation.delegate = self;
    [_containerLayer addAnimation:moveAnimation forKey:@"ContainerMove1"];
    
    _animationKind = 2;
    [CATransaction commit];
    
}

#pragma mark - MKMapViewDelegate

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    //NSLog(@"mapViewWillStartLoadingMap 1");
    _mapViewDidFinishLoadingMap = NO;
    _mapViewDidStartLoadingMap = YES;
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    //NSLog(@"mapViewDidFinishLoadingMap 2");
    _mapViewDidFinishLoadingMap = YES;
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    //NSLog(@"mapViewDidFinishLoadingMap 3");
    _mapViewDidFinishLoadingMap = YES;
}

#pragma mark - 

- (void)personImageDidPress{
    UIViewController *vc = [(UINavigationController*) _currentViewController topViewController];
    if (vc == _unknownPersonVC) {
        [self unknownPersonViewController:_unknownPersonVC shouldPerformDefaultActionForPerson:_unknownPersonVC.displayedPerson property:kABPersonKindProperty identifier:0]; //没有image属性，用kABPersonKindProperty代替
    }else if (vc == _personVC){
        [self personViewController:_personVC shouldPerformDefaultActionForPerson:_personVC.displayedPerson property:kABPersonKindProperty identifier:0]; //没有image属性，用kABPersonKindProperty代替
    }
}


#pragma mark - mothed for single 

static id single = nil;
+ (IAContactManager*)sharedManager{
    if (single == nil) {
        single = [[super allocWithZone:NULL] init];
    }
    return single;
}

- (id)init{
    self = [super init];
    if (self) {
        //提前初始化好，省得打开时候响应的慢
        [self _unknownPersonViewControllerWithIAPerson:nil];
        [self _personViewControllerWithIAPerson:nil];
        _currentViewController = nil;
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}


@end
