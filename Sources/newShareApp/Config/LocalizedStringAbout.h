//
//  LocalizedString.h
//  iAlarm
//
//  Created by li shiyong on 10-11-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



////////////////////////////////////////////////////////
//UI上的文本
#define KLabelSectionHeaderRateAndReview             NSLocalizedString(@"KLabelSectionHeaderRateAndReview", @"评分Section头的标签")
#define KLabelSectionHeaderVersion                   NSLocalizedString(@"KLabelSectionHeaderVersion",       @"版本Section头的标签")
#define KLabelSectionFooterVersion                   NSLocalizedString(@"KLabelSectionFooterVersion",       @"版本Section的脚")
#define KLabelSectionFBMyWell                        NSLocalizedString(@"KLabelSectionFBMyWell",            @"我的Facebook涂鸦墙Section头的标签")
#define KLabelSectionFBFriendsWall                   NSLocalizedString(@"KLabelSectionFBFriendsWall",       @"朋友们的Facebook涂鸦墙Section头的标签")

#define KLabelCellRateAndReview                      NSLocalizedString(@"KLabelCellRateAndReview",          @"评分cell的标签")
#define KLabelSectionHeaderShare                     NSLocalizedString(@"KLabelSectionHeaderShare",         @"分享Section的标签")
#define KLabelCellFacebook                           NSLocalizedString(@"KLabelCellFacebook",               @"Facebook cell的标签")
#define KLabelCellTwitter                            NSLocalizedString(@"KLabelCellTwitter",                @"Twitter cell的标签")
#define KLabelCellEmail                              NSLocalizedString(@"KLabelCellEmail",                  @"邮件 cell的标签")
#define KLabelCellMessages                           NSLocalizedString(@"KLabelCellMessages",               @"短信 cell的标签")
#define KLabelCellVersion                            NSLocalizedString(@"KLabelCellVersion",                @"版本cell的标签")
#define KLabelCellFBSendTo                           NSLocalizedString(@"KLabelCellFBSendTo",               @"Facebook:send to 的标签")
#define KLabelCellBuyFullVersion                     NSLocalizedString(@"KLabelCellBuyFullVersion",         @"购买完全版cell的标签")


#define KViewTitleAbout                              NSLocalizedString(@"KViewTitleAbout",                  @"关于视图标题")
#define KViewTitleFBNewFeed                          NSLocalizedString(@"KViewTitleFBNewFeed",              @"FB new feed视图标题")
#define KViewTitleTWNewTweet                         NSLocalizedString(@"KViewTitleTWNewTweet",             @"TW new Tweet视图标题")
#define KViewTitleAllFBFriends                       NSLocalizedString(@"KViewTitleAllFBFriends",           @"FB 所有朋友视图标题，所有的朋友")

#define KViewPromptCheckContacts                     NSLocalizedString(@"KViewPromptCheckContacts",         @"选择联系人视图的提示")
#define KTextPromptFBMore                            NSLocalizedString(@"KTextPromptFBMore",                @"还有xx个fb联系人的文本,还有 %d 个...")
#define KTextPromptFBLoginAsXX                       NSLocalizedString(@"KTextPromptFBLoginAsXX",           @"退出fb提示的文本,Login As XX (不是你？)")
#define KTextPromptSending                           NSLocalizedString(@"KTextPromptSending",               @"文本,Sending...")
#define KTextPromptXXFriends                         NSLocalizedString(@"KTextPromptXXFriends",             @"文本,xx 位朋友")
#define KTextPromptNextXXFriends                     NSLocalizedString(@"KTextPromptNextXXFriends",         @"文本,下xx位朋友")



#define kAlertBeforeLogoutFBInternetTitle            NSLocalizedString(@"kAlertBeforeLogoutFBInternetTitle",@"提示退出facebook登录状态的提示框的标题")

#define kBtnShare                                    NSLocalizedString(@"kBtnShare",                        @"Share按钮")
#define kBtnSend                                     NSLocalizedString(@"kBtnSend",                         @"Send按钮")
#define kBtnCancel                                   NSLocalizedString(@"kBtnCancel",                       @"Cancel按钮")

////////////////////////////////////////////////////////
//Alert提示
#define kAlertNeedInternetBodyAccessFacebook         NSLocalizedString(@"kAlertNeedInternetBodyAccessFacebook", @"需要打开internet连接访问Facebook的提示框的内容")
#define kAlertNeedInternetBodyAccessTwitter          NSLocalizedString(@"kAlertNeedInternetBodyAccessTwitter",  @"需要打开internet连接访问Twitter的提示框的内容")
#define kAlertNeedInternetTitleAccessFacebook        NSLocalizedString(@"kAlertNeedInternetTitleAccessFacebook",@"需要打开internet连接访问facebook的提示框的标题")
#define kAlertNeedInternetTitleAccessTwitter         NSLocalizedString(@"kAlertNeedInternetTitleAccessTwitter", @"需要打开internet连接访问Twitter的提示框的标题")

////////////////////////////////////////////////////////
//Alert提示 要求评分
#define kAlertConfirmRateTitle                       NSLocalizedString(@"kAlertConfirmRateTitle",               @"要求评分的提示框的标题")
#define kAlertConfirmRateBody                        NSLocalizedString(@"kAlertConfirmRateBody",                @"要求评分的提示框的内容")
#define kAlertConfirmRateBtnToRate                   NSLocalizedString(@"kAlertConfirmRateBtnToRate",           @"要求评分的提示框的 ‘去评分’按钮 ")
#define kAlertConfirmRateBtnNoThanks                 NSLocalizedString(@"kAlertConfirmRateBtnNoThanks",         @"要求评分的提示框的 ‘No,Thanks’按钮 ")
#define kAlertConfirmRateBtnNotToremind              NSLocalizedString(@"kAlertConfirmRateBtnNotToremind",      @"要求评分的提示框的 ‘Not to remind’按钮 ")





////////////////////////////////////////////////////////
//在App store上的link
#define KLinkAppStoreLite                            NSLocalizedString(@"KLinkAppStoreLite",                @"app store 的链接")
#define KLinkAppStoreFullVersion                     NSLocalizedString(@"KLinkAppStoreFullVersion",         @"app store 完全版本的的链接")

//在App store上的自定义link
#define KLinkCustomAppStoreLite                      NSLocalizedString(@"KLinkCustomAppStoreLite",          @"app store 的自定义链接")
#define KLinkCustomAppStoreFullVersion               NSLocalizedString(@"KLinkCustomAppStoreFullVersion",   @"app store 完全版本的的自定义链接")



#ifndef FULL_VERSION

#define KLinkAppStore                                KLinkAppStoreLite
#define KLinkCustomAppStore                          KLinkCustomAppStoreLite

#else

#define KLinkAppStore                                KLinkAppStoreFullVersion
#define KLinkCustomAppStore                          KLinkCustomAppStoreFullVersion


#endif






////////////////////////////////////////////////////////
//分享的内容
#define KShareContentTextGetTheApp                   NSLocalizedString(@"KShareContentTextGetTheApp",       @"共享内容 Get the app")

#define KShareContentTwitterMessage                  NSLocalizedString(@"KShareContentTwitterMessage",      @"共享内容 Twitter")
#define KShareContentMailMessage                     NSLocalizedString(@"KShareContentMailMessage",         @"共享内容 通用的")
#define KShareContentMailTitle                       NSLocalizedString(@"KShareContentMailTitle",           @"共享标题 通用的")

/*
#define KShareContentTitle000                        NSLocalizedString(@"KShareContentTitle000",            @"共享内容 标题000")
#define KShareContentTitle001                        NSLocalizedString(@"KShareContentTitle001",            @"共享内容 标题001")
#define KShareContentTitle002                        NSLocalizedString(@"KShareContentTitle002",            @"共享内容 标题002")
#define KShareContentTitle003                        NSLocalizedString(@"KShareContentTitle003",            @"共享内容 标题003")
#define KShareContentTitle004                        NSLocalizedString(@"KShareContentTitle004",            @"共享内容 标题004")
#define KShareContentTitle005                        NSLocalizedString(@"KShareContentTitle005",            @"共享内容 标题005")
#define KShareContentTitle006                        NSLocalizedString(@"KShareContentTitle006",            @"共享内容 标题006")
#define KShareContentTitle007                        NSLocalizedString(@"KShareContentTitle007",            @"共享内容 标题007")
#define KShareContentTitle008                        NSLocalizedString(@"KShareContentTitle008",            @"共享内容 标题008")
#define KShareContentTitle009                        NSLocalizedString(@"KShareContentTitle009",            @"共享内容 标题009")

#define KShareContentBody000                         NSLocalizedString(@"KShareContentBody000",             @"共享内容 体000")
#define KShareContentBody001                         NSLocalizedString(@"KShareContentBody001",             @"共享内容 体001")
#define KShareContentBody002                         NSLocalizedString(@"KShareContentBody002",             @"共享内容 体002")
#define KShareContentBody003                         NSLocalizedString(@"KShareContentBody003",             @"共享内容 体003")
#define KShareContentBody004                         NSLocalizedString(@"KShareContentBody004",             @"共享内容 体004")
#define KShareContentBody005                         NSLocalizedString(@"KShareContentBody005",             @"共享内容 体005")
#define KShareContentBody006                         NSLocalizedString(@"KShareContentBody006",             @"共享内容 体006")
#define KShareContentBody007                         NSLocalizedString(@"KShareContentBody007",             @"共享内容 体007")
#define KShareContentBody008                         NSLocalizedString(@"KShareContentBody008",             @"共享内容 体008")
#define KShareContentBody009                         NSLocalizedString(@"KShareContentBody009",             @"共享内容 体009")

#define KShareContentImageName000                    NSLocalizedString(@"KShareContentImageName000",        @"共享内容 图片名称000")
#define KShareContentImageName001                    NSLocalizedString(@"KShareContentImageName001",        @"共享内容 图片名称001")
#define KShareContentImageName002                    NSLocalizedString(@"KShareContentImageName002",        @"共享内容 图片名称002")
#define KShareContentImageName003                    NSLocalizedString(@"KShareContentImageName003",        @"共享内容 图片名称003")
#define KShareContentImageName004                    NSLocalizedString(@"KShareContentImageName004",        @"共享内容 图片名称004")
#define KShareContentImageName005                    NSLocalizedString(@"KShareContentImageName005",        @"共享内容 图片名称005")
#define KShareContentImageName006                    NSLocalizedString(@"KShareContentImageName006",        @"共享内容 图片名称006")
#define KShareContentImageName007                    NSLocalizedString(@"KShareContentImageName007",        @"共享内容 图片名称007")
#define KShareContentImageName008                    NSLocalizedString(@"KShareContentImageName008",        @"共享内容 图片名称008")
#define KShareContentImageName009                    NSLocalizedString(@"KShareContentImageName009",        @"共享内容 图片名称009")

#define KShareContentImageLink000                    NSLocalizedString(@"KShareContentImageLink000",        @"共享内容 图片Link000")
#define KShareContentImageLink001                    NSLocalizedString(@"KShareContentImageLink001",        @"共享内容 图片Link001")
#define KShareContentImageLink002                    NSLocalizedString(@"KShareContentImageLink002",        @"共享内容 图片Link002")
#define KShareContentImageLink003                    NSLocalizedString(@"KShareContentImageLink003",        @"共享内容 图片Link003")
#define KShareContentImageLink004                    NSLocalizedString(@"KShareContentImageLink004",        @"共享内容 图片Link004")
#define KShareContentImageLink005                    NSLocalizedString(@"KShareContentImageLink005",        @"共享内容 图片Link005")
#define KShareContentImageLink006                    NSLocalizedString(@"KShareContentImageLink006",        @"共享内容 图片Link006")
#define KShareContentImageLink007                    NSLocalizedString(@"KShareContentImageLink007",        @"共享内容 图片Link007")
#define KShareContentImageLink008                    NSLocalizedString(@"KShareContentImageLink008",        @"共享内容 图片Link008")
#define KShareContentImageLink009                    NSLocalizedString(@"KShareContentImageLink009",        @"共享内容 图片Link009")
*/


#define KLabelCellFoundABug                      NSLocalizedStringFromTable(@"KLabelCellFoundABug", @"test" ,         @"found a bug cell的标签")



