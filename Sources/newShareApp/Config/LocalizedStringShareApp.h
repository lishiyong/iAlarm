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
#define KLabelCellFBSendTo                           NSLocalizedStringFromTable(@"KLabelCellFBSendTo",            @"ShareApp",    @"Facebook:send to 的标签")
#define KLabelSectionFBMyWell                        NSLocalizedStringFromTable(@"KLabelSectionFBMyWell",         @"ShareApp",    @"我的Facebook涂鸦墙Section头的标签")
#define KLabelSectionFBFriendsWall                   NSLocalizedStringFromTable(@"KLabelSectionFBFriendsWall",    @"ShareApp",    @"朋友们的Facebook涂鸦墙Section头的标签")

#define KViewTitleFBNewFeed                          NSLocalizedStringFromTable(@"KViewTitleFBNewFeed",           @"ShareApp",    @"FB new feed视图标题")
#define KViewTitleTWNewTweet                         NSLocalizedStringFromTable(@"KViewTitleTWNewTweet",          @"ShareApp",    @"TW new Tweet视图标题")
#define KViewTitleAllFBFriends                       NSLocalizedStringFromTable(@"KViewTitleAllFBFriends",        @"ShareApp",    @"FB 所有朋友视图标题，所有的朋友")

#define KViewPromptCheckContacts                     NSLocalizedStringFromTable(@"KViewPromptCheckContacts",      @"ShareApp",    @"选择联系人视图的提示")
#define KTextPromptFBMore                            NSLocalizedStringFromTable(@"KTextPromptFBMore",             @"ShareApp",    @"还有xx个fb联系人的文本,还有 %d 个...")
#define KTextPromptFBLoginAsXX                       NSLocalizedStringFromTable(@"KTextPromptFBLoginAsXX",        @"ShareApp",    @"退出fb提示的文本,Login As XX (不是你？)")
#define KTextPromptSending                           NSLocalizedStringFromTable(@"KTextPromptSending",            @"ShareApp",    @"文本,Sending...")
#define KTextPromptXXFriends                         NSLocalizedStringFromTable(@"KTextPromptXXFriends",          @"ShareApp",    @"文本,xx 位朋友")
#define KTextPromptNextXXFriends                     NSLocalizedStringFromTable(@"KTextPromptNextXXFriends",      @"ShareApp",    @"文本,下xx位朋友")

#define KSheetBtnFacebook                            NSLocalizedStringFromTable(@"KSheetBtnFacebook",             @"ShareApp",    @"Facebook sheet上按钮")
#define KSheetBtnTwitter                             NSLocalizedStringFromTable(@"KSheetBtnTwitter",              @"ShareApp",    @"Twitter sheet上按钮")
#define KSheetBtnEMail                               NSLocalizedStringFromTable(@"KSheetBtnEMail",                @"ShareApp",    @"Email sheet上按钮")
#define KSheetBtnMessages                            NSLocalizedStringFromTable(@"KSheetBtnMessages",             @"ShareApp",    @"短信 sheet上按钮")

#define kBtnShare                                    NSLocalizedStringFromTable(@"kBtnShare",                     @"ShareApp",    @"Share按钮")
#define kBtnSend                                     NSLocalizedStringFromTable(@"kBtnSend",                      @"ShareApp",    @"Send按钮")
#define kBtnCancel                                   NSLocalizedStringFromTable(@"kBtnCancel",                    @"ShareApp",    @"Cancel按钮")

////////////////////////////////////////////////////////
//Alert提示
#define kAlertNeedInternetBodyAccessFacebook         NSLocalizedStringFromTable(@"kAlertNeedInternetBodyAccessFacebook", @"ShareApp", @"需要打开internet连接访问Facebook的提示框的内容")
#define kAlertNeedInternetBodyAccessTwitter          NSLocalizedStringFromTable(@"kAlertNeedInternetBodyAccessTwitter",  @"ShareApp", @"需要打开internet连接访问Twitter的提示框的内容")
#define kAlertNeedInternetTitleAccessFacebook        NSLocalizedStringFromTable(@"kAlertNeedInternetTitleAccessFacebook",@"ShareApp", @"需要打开internet连接访问facebook的提示框的标题")
#define kAlertNeedInternetTitleAccessTwitter         NSLocalizedStringFromTable(@"kAlertNeedInternetTitleAccessTwitter", @"ShareApp", @"需要打开internet连接访问Twitter的提示框的标题")
#define kAlertBeforeLogoutFBInternetTitle            NSLocalizedStringFromTable(@"kAlertBeforeLogoutFBInternetTitle",    @"ShareApp", @"提示退出facebook登录状态的提示框的标题")

////////////////////////////////////////////////////////
//在App store上的link
#define KLinkAppStoreLite                            NSLocalizedStringFromTable(@"KLinkAppStoreLite",               @"ShareApp",      @"app store 的链接")
#define KLinkAppStoreFullVersion                     NSLocalizedStringFromTable(@"KLinkAppStoreFullVersion",        @"ShareApp",      @"app store 完全版本的的链接")

//在App store上的自定义link
#define KLinkCustomAppStoreLite                      NSLocalizedStringFromTable(@"KLinkCustomAppStoreLite",         @"ShareApp",      @"app store 的自定义链接")
#define KLinkCustomAppStoreFullVersion               NSLocalizedStringFromTable(@"KLinkCustomAppStoreFullVersion",  @"ShareApp",      @"app store 完全版本的的自定义链接")

////////////////////////////////////////////////////////
//分享的内容
#define KShareContentTextGetTheApp                   NSLocalizedStringFromTable(@"KShareContentTextGetTheApp",      @"ShareApp",      @"共享内容 Get the app")

#define KShareContentTwitterMessage                  NSLocalizedStringFromTable(@"KShareContentTwitterMessage",     @"ShareApp",      @"共享内容 Twitter")
#define KShareContentMailMessage                     NSLocalizedStringFromTable(@"KShareContentMailMessage",        @"ShareApp",      @"共享内容 通用的")
#define KShareContentMailTitle                       NSLocalizedStringFromTable(@"KShareContentMailTitle",          @"ShareApp",      @"共享标题 通用的")

////////////////////////////////////////////////////////
//
#ifndef FULL_VERSION

#define KLinkAppStore                                KLinkAppStoreLite
#define KLinkCustomAppStore                          KLinkCustomAppStoreLite

#else

#define KLinkAppStore                                KLinkAppStoreFullVersion
#define KLinkCustomAppStore                          KLinkCustomAppStoreFullVersion

#endif


