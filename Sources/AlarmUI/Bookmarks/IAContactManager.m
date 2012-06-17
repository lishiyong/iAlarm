//
//  IAContactManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

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
#define kPersonImageOrigin                 (CGPoint){18.0, 15.0}
#define kPersonImageSize                   (CGSize) {kPersonImageWidth, kPersonImageHeight}
//#define kPersonImageFrame                  (CGRect) {kPersonImageOrigin, kPersonImageSize}

#define kPersonViewWidth                   320.0
#define kPersonViewHeight                  416.0
#define kPersonViewSize                    (CGSize) {kPersonViewWidth, kPersonViewHeight}

#define kMapViewShadowWidth                375.0
#define kMapViewShadowHeight               471.0
#define kMapViewShadowSize                 (CGSize) {kMapViewShadowWidth, kMapViewShadowHeight}
#define kMapViewShadowAnchorPoint          (CGPoint){(3+kPersonViewWidth/2)/kMapViewShadowWidth,(10+kPersonViewHeight/2)/kMapViewShadowHeight}
//阴影的左边缘:3，上边缘:10

#define kDegreesForTakeImage               1500.0


@interface IAContactManager (private) 

- (MKMapView *)_mapView;
- (UIBarButtonItem*)_cancelButtonItem;
- (ABUnknownPersonViewController*)_unknownPersonViewControllerWithIAPerson:(IAPerson*)thePerson;
- (ABPersonViewController*)_personViewControllerWithIAPerson:(IAPerson*)thePerson;

/**
 找到闹钟地址在联系人地址(多地址)中的索引
 **/
- (NSUInteger)_addressDictionaryIndexOfAlarm:(IAAlarm*)alarm forContactPerson:(ABRecordRef)contactPerson;

/**
 统一ABUnknownPersonViewController和ABPersonViewController的点属性的委托方法
 **/
- (void)_viewController:(UIViewController *)viewController personImage:(UIImage*)personImage;

@end

@implementation IAContactManager
@synthesize currentViewController = _currentViewController, animationKind = _animationKind; 


- (MKMapView *)_mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:(CGRect){{0, 0},kPersonViewSize}];
        _mapView.showsUserLocation = NO;
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
        _unknownPersonVC.alternateName = thePerson.personName;
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
        
        _personVC.allowsEditing = YES; //不能让编辑。编辑状态会把关闭按钮给冲掉的。//但没有编辑，高亮不好用
    }
    
    if (thePerson) {
        _personVC.displayedPerson = thePerson.ABPerson;
    }
    
    _personVC.title = KLabelAlarmPostion;
    return _personVC;
}

- (NSUInteger)_indexAddressDictionaryOfAlarm:(IAAlarm*)alarm forContactPerson:(ABRecordRef)contactPerson{
    
    if (!alarm) return NSNotFound;
    if (!contactPerson) return NSNotFound;
    
    IAPerson *theIAPerson = [[[IAPerson alloc] initWithPerson:contactPerson] autorelease];
    NSDictionary *theAlarmAddressDic = alarm.placemark.addressDictionary;
    NSArray *theContactPersonAddressDics = theIAPerson.addressDictionaries;
    
    if (!theAlarmAddressDic || theAlarmAddressDic.count == 0) return NSNotFound;
    if (!theContactPersonAddressDics || theContactPersonAddressDics.count == 0) return NSNotFound;
    
    //dic -> string
    NSString *alarmAddress = [ABCreateStringWithAddressDictionary(theAlarmAddressDic,NO) stringByTrim];
    alarmAddress = [alarmAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    alarmAddress = [alarmAddress stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSUInteger index = [theContactPersonAddressDics indexOfObjectPassingTest:^BOOL(NSDictionary *aDic, NSUInteger idx, BOOL *stop) {
        
        //dic -> string
        NSString *anAddress = [ABCreateStringWithAddressDictionary(aDic,NO) stringByTrim];
        anAddress = [anAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
        anAddress = [anAddress stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        if ([anAddress isEqualToString:alarmAddress]){
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    return index;
}

- (void)_viewController:(UIViewController *)viewController personImage:(UIImage*)personImage{
    
    [_alarmPositionVC release];
    _alarmPositionVC = [[AlarmPositionMapViewController alloc] initWithNibName:@"AlarmPositionMapViewController" bundle:nil alarm:_alarm];
    
    _alarmPositionVC.delegate = self;
    [_alarmPositionVC view];
    
    
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
    
    _mapLayerSuperLayer =  [_alarmPositionVC.mapView.layer.superlayer retain];
    _mapLayer = [_alarmPositionVC.mapView.layer retain];
    _mapLayerPosition = _mapLayer.position;
    _mapLayerBounds = _mapLayer.bounds;    
    _mapLayer.position = YCRectCenter(_containerLayer.bounds);
    [_containerLayer addSublayer:_mapLayer];
    
    //personImage
    CALayer *personImageLayer = [CALayer layer];
    personImageLayer.contents = (id)personImage.CGImage;
    personImageLayer.bounds = (CGRect){{0,0},kPersonImageSize};
    personImageLayer.position = YCRectCenter(_containerLayer.bounds);
    personImageLayer.opacity = 0.0;
    [_containerLayer addSublayer:personImageLayer];
    
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    
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
    [CATransaction setAnimationDuration:0.35];
    
    CABasicAnimation *tranAnimation=[CABasicAnimation animationWithKeyPath: @"opacity"];
    tranAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];  //前慢后快
    tranAnimation.fromValue= [NSNumber numberWithFloat:1.0];
    tranAnimation.toValue= [NSNumber numberWithFloat:0.0];   
    tranAnimation.removedOnCompletion = YES;
    [personImageLayer addAnimation :tranAnimation forKey :@"MapShow" ];
    
    [CATransaction commit];
    
    //位置移动
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.95];
    
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

- (id)init{
    self = [super init];
    if (self) {
        //提前初始化好，省得打开时候响应的慢
        [self _unknownPersonViewControllerWithIAPerson:nil];
        [self _personViewControllerWithIAPerson:nil];
        _delayForWaitingStartLoadingMap = 0.75;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    return [self init];
}

- (void)dealloc{
    [_alarm release];
    [_cancelButtonItem release];
    [_unknownPersonVC release];
    [_personVC release];
    [_mapView release];
    [_imageTook release];
    [_alarmPositionVC release];
    [super dealloc];
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
    
    //找到闹钟地址在关联联系人地址组的索引
    IAPerson *contactPerson = [[[IAPerson alloc] initWithPersonId:theAlarm.personId] autorelease];
    NSUInteger index = [self _indexAddressDictionaryOfAlarm:theAlarm forContactPerson:contactPerson.ABPerson];
    
    UIViewController *vc = nil;
    IAPerson *alarmPerson = [[[IAPerson alloc] initWithAlarm:theAlarm image:nil] autorelease];
    if (NSNotFound == index) {//没关联，或地址被删除、修改了
        vc = [self _unknownPersonViewControllerWithIAPerson:alarmPerson];
    }else{
        vc = [self _personViewControllerWithIAPerson:contactPerson];
    }
    
    //
    [(UINavigationController*)_currentViewController pushViewController:vc animated:YES];
    
    //ABUnknownPersonViewController其实也支持这个函数
    if ([vc isKindOfClass:[ABUnknownPersonViewController class]]) {
        index = 0; //还没关联联系人时候，就一个地址
    }
    
    //高亮闹钟地址
    if ([vc respondsToSelector:@selector(setHighlightedItemForProperty:withIdentifier:)]) {
        [(ABPersonViewController*)vc setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:index];
    }
    
    //截图，放到最后，免得耽误上面的执行
    if ([vc isKindOfClass:[ABUnknownPersonViewController class]]) {
        
        CGSize size = CGSizeMake(64, 64);
        NSString *imageName = theAlarm.alarmRadiusType.alarmRadiusTypeImageName;
        imageName = [@"Shadow_" stringByAppendingString:imageName];
        UIImage *flagImage = [UIImage imageNamed:imageName];
        CGPoint imageCenter = {6,12};
        self._mapView.visibleMapRect = MKMapRectWorld;
        CLLocationCoordinate2D lbcoordinate = theAlarm.visualCoordinate;
        lbcoordinate = CLLocationCoordinate2DIsValid(lbcoordinate) ? lbcoordinate : _mapView.centerCoordinate;

        //先取一次图
        if (CLLocationCoordinate2DIsValid(theAlarm.visualCoordinate)) {
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(lbcoordinate, kDegreesForTakeImage, kDegreesForTakeImage);
            region = [self._mapView regionThatFits:region];
            if (!self._mapView.superview) 
                [_unknownPersonVC.view addSubview:self._mapView];//必须加到界面上，否则数据不加载
            [self._mapView setRegion:region];
        }else{
            self._mapView.visibleMapRect = MKMapRectWorld;
        }
        
        UIImage *theImage = [self._mapView takeImageWithoutOverlaySize:size overrideImage:flagImage leftBottomAtCoordinate:lbcoordinate imageCenter:imageCenter];
        [_imageTook release];
        _imageTook = [theImage retain];
        if (self._mapView.superview) 
            [self._mapView removeFromSuperview];
        
        IAPerson *personWithImage = [[[IAPerson alloc] initWithAlarm:theAlarm image:theImage] autorelease];
        _unknownPersonVC.displayedPerson = personWithImage.ABPerson;
         
        //再一次高亮闹钟地址
        if ([_unknownPersonVC respondsToSelector:@selector(setHighlightedItemForProperty:withIdentifier:)]) {
         [(ABPersonViewController*)_unknownPersonVC setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:0];
        }
        
        //////////////
        
        //把地图加载到界面
        if (CLLocationCoordinate2DIsValid(theAlarm.visualCoordinate)) {
            self._mapView.delegate = self;
            if (!self._mapView.superview) 
                [_unknownPersonVC.view addSubview:self._mapView];//必须加到界面上，否则数据不加载
            
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(lbcoordinate, kDegreesForTakeImage, kDegreesForTakeImage);
            region = [self._mapView regionThatFits:region];
            [self._mapView setRegion:region];
            
            //动画的目的是隐藏地图
            CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath: @"opacity"];
            animation.duration = 100;
            animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; 
            animation.fromValue= [NSNumber numberWithFloat:0.0];
            animation.toValue= [NSNumber numberWithFloat:0.0]; 
            animation.removedOnCompletion = NO;
            [self._mapView.layer addAnimation :animation forKey :@"hideMapView" ];
            
            _mapViewDidFinishLoadingMap = YES;
            _mapViewDidStartLoadingMap = NO;
            [self performBlock:^{
                _mapViewDidStartLoadingMap = YES;
                _delayForWaitingStartLoadingMap = 0.2; //第二次以后等的时间短
                //NSLog(@"performBlock 0");
            } afterDelay:_delayForWaitingStartLoadingMap];
            
            [self performBlock:^{
                _mapViewDidFinishLoadingMap = YES;
                //NSLog(@"performBlock 1");
            } afterDelay:5.0];
            
            
            while (!_mapViewDidFinishLoadingMap || !_mapViewDidStartLoadingMap) {
                //NSLog(@"while _mapViewDidFinishLoadingMap = %d _mapViewDidStartLoadingMap = %d",_mapViewDidFinishLoadingMap,_mapViewDidStartLoadingMap);
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            //NSLog(@"while _mapViewDidFinishLoadingMap = %d _mapViewDidStartLoadingMap = %d",_mapViewDidFinishLoadingMap,_mapViewDidStartLoadingMap);
            
            //
            UIImage *theImage = [self._mapView takeImageWithoutOverlaySize:size overrideImage:flagImage leftBottomAtCoordinate:lbcoordinate imageCenter:imageCenter];
            [_imageTook release];
            _imageTook = [theImage retain];
            [self._mapView removeFromSuperview];
            [self._mapView.layer removeAllAnimations];
            self._mapView.delegate = nil;//

            
            IAPerson *personWithImage = [[[IAPerson alloc] initWithAlarm:theAlarm image:theImage] autorelease];
            _unknownPersonVC.displayedPerson = personWithImage.ABPerson;
            
            //再一次高亮闹钟地址
            if ([_unknownPersonVC respondsToSelector:@selector(setHighlightedItemForProperty:withIdentifier:)]) {
                [(ABPersonViewController*)_unknownPersonVC setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:0];
            }
            
        }
        
    }

}


#pragma mark - ABUnknownPersonViewControllerDelegate

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person{
    if (person) {
        
        ABRecordID thePersonId = kABRecordInvalidID;
        NSString *thePersonName = nil;
        if (person) {
            thePersonId = ABRecordGetRecordID(person);
            thePersonName =  (__bridge_transfer NSString*)ABRecordCopyCompositeName(person);
            [thePersonName autorelease];
            
            thePersonName = [thePersonName stringByTrim];
            if (!thePersonName || thePersonName.length == 0)
                thePersonName = nil;
                
        }
        
        _alarm.personId = thePersonId;
        if (thePersonName)
            _alarm.positionTitle = thePersonName;
        
        
        //push的情况，先找到正主，偷着把正主保存了
        
        IAAlarm *alarmNotTemp = [IAAlarm findForAlarmId:_alarm.alarmId];
        alarmNotTemp.personId = thePersonId;
        if (thePersonName)
            alarmNotTemp.positionTitle = thePersonName;
        [alarmNotTemp saveFromSender:self];
        
        
        [(UINavigationController*) _currentViewController popToRootViewControllerAnimated:NO];
        
        
        //根据情况打开哪个
        UIViewController *vc = nil;
        NSUInteger index = [self _indexAddressDictionaryOfAlarm:_alarm forContactPerson:person];
        if (NSNotFound == index) {
            IAPerson *newPerson = [[[IAPerson alloc] initWithAlarm:_alarm image:_imageTook] autorelease];
            vc = [self _unknownPersonViewControllerWithIAPerson:newPerson];
        }else{
            IAPerson *contactPerson = [[[IAPerson alloc] initWithPerson:person] autorelease];
            vc = [self _personViewControllerWithIAPerson:contactPerson];
        }
        
        //弹出新的
        [(UINavigationController*) _currentViewController pushViewController:vc animated:NO];
        
        //高亮闹钟地址
        if (NSNotFound != index) {
            if ([vc respondsToSelector:@selector(setHighlightedItemForProperty:withIdentifier:)]) {
                [(ABPersonViewController*)vc setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:index];
            }
        }
        
    }
    
}



- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    IAPerson *thePerson = [[[IAPerson alloc] initWithPerson:person] autorelease];
    
    UIImage *personImage = thePerson.image;
    UIImage *emptyImage = [UIImage imageNamed:@"IAPersonNoImage.png"];
    
    thePerson.image = emptyImage;
    personViewController.displayedPerson = thePerson.ABPerson;
    
    //高亮闹钟地址
    if ([personViewController respondsToSelector:@selector(setHighlightedItemForProperty:withIdentifier:)]) {
        [(ABPersonViewController*)personViewController setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:0];
    }
        
    [self _viewController:personViewController personImage:personImage];
    
    
    return NO;
}

#pragma mark - CAAnimation Delegate Methods
- (void)animationDidStart:(CAAnimation *)theAnimation{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    if ([theAnimation.delegate respondsToSelector:@selector(animationKind)]) {
        if ([theAnimation.delegate animationKind] == 1) {
            
            _unknownPersonVC.title = nil;
            [(UINavigationController*) _currentViewController pushViewController:_alarmPositionVC animated:NO];
            
            //禁用隐式动画
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue
                             forKey:kCATransactionDisableActions];
            
            [_mapLayerSuperLayer addSublayer:_mapLayer];
            _mapLayer.position = _mapLayerPosition;
            _mapLayer.bounds = _mapLayerBounds;
            [_containerLayer removeFromSuperlayer];
            
            [CATransaction commit];
            

            [_containerLayer release];
            [_mapLayer release];
            [_mapLayerSuperLayer release];
            
            [_alarmPositionVC beginWork];
            
        }else if ([theAnimation.delegate animationKind] == 2){
            
        }
    }
     
}

- (void)alarmPositionMapViewControllerDidPressDoneButton:(AlarmPositionMapViewController*)alarmPositionMapViewController{
    _unknownPersonVC.title = KLabelAlarmPostion;
    _personVC.title = KLabelAlarmPostion;
    [(UINavigationController*) _currentViewController popViewControllerAnimated:NO];
    
    //释放地图view
    [_alarmPositionVC release];
    _alarmPositionVC = nil;
}


#pragma mark - ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue{
    
    if (kABPersonAddressProperty == property 
        &&  [self _indexAddressDictionaryOfAlarm:_alarm forContactPerson:person] == identifierForValue) {
        
        IAPerson *thePerson = [[[IAPerson alloc] initWithPerson:person] autorelease];
        UIImage *personImage = thePerson.image;
        UIImage *emptyImage = [UIImage imageNamed:@"IAPersonNoImage.png"];
        thePerson.image = emptyImage;
        personViewController.displayedPerson = thePerson.ABPerson;
        
        //高亮闹钟地址
        [(ABPersonViewController*)personViewController setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:identifierForValue];
        
        [self _viewController:personViewController personImage:personImage];
        
    }
    
    
    return NO;
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
    //NSLog(@"mapViewDidFailLoadingMap 3");
    _mapViewDidFinishLoadingMap = YES;
}

/*
- (BOOL)_viewController:(UIViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue{
    
}
 */



@end
