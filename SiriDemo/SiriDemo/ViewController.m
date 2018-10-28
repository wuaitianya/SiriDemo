//
//  ViewController.m
//  SiriDemo
//
//  Created by 雾霭天涯 on 2018/10/27.
//  Copyright © 2018 雾霭天涯. All rights reserved.
//

#import "ViewController.h"
#import <Intents/Intents.h>
#import <IntentsUI/IntentsUI.h>
#import "SiriDemoIntent.h"
// 设置Custom Intents”图中右边箭头指的“Class Name”
@interface ViewController ()<INUIAddVoiceShortcutButtonDelegate,INUIAddVoiceShortcutViewControllerDelegate,INUIEditVoiceShortcutViewControllerDelegate>

@property (nonatomic, strong) SiriDemoIntent API_AVAILABLE(ios(12.0)) *intent;
@property (nonatomic, strong) INUIAddVoiceShortcutButton API_AVAILABLE(ios(12.0)) *shortcutButton;
@property (nonatomic,assign) BOOL addedShortcut;

@property (nonatomic,strong)UIButton* tempBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* 系统自带按钮 是一个Siri图片和 add to siri 英文
     if (@available(iOS 12.0, *)) {
     _shortcutButton = [[INUIAddVoiceShortcutButton alloc] initWithStyle:INUIAddVoiceShortcutButtonStyleWhiteOutline];
     _shortcutButton.shortcut = [[INShortcut alloc] initWithIntent:self.intent];
     _shortcutButton.translatesAutoresizingMaskIntoConstraints = false;
     _shortcutButton.delegate = self;
     [self.view addSubview:_shortcutButton];
     }
     */
    //自定义按钮
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(100, 100, 100, 50);
    [tempBtn setTitle:@"添加Siri" forState:UIControlStateNormal];
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [tempBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    tempBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [tempBtn addTarget:self action:@selector(shortcutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.tempBtn = tempBtn;
    [self.view addSubview:tempBtn];
}
- (void)shortcutButtonClicked:(UIButton *)sender
{
    if (@available(iOS 12.0, *)) {
        [[INVoiceShortcutCenter sharedCenter] getAllVoiceShortcutsWithCompletion:^(NSArray<INVoiceShortcut *> * _Nullable voiceShortcuts, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL tempAddedShortcut = NO;
                for (INVoiceShortcut *voiceShortcut in voiceShortcuts) {
                    if ([voiceShortcut.shortcut.intent isKindOfClass:[SiriDemoIntent class]]) {
                        tempAddedShortcut = YES;
                        break;
                    }
                }
                self.addedShortcut = tempAddedShortcut;
                if (self.addedShortcut) {
                    INUIEditVoiceShortcutViewController *editVoiceShortcutViewController = [[INUIEditVoiceShortcutViewController alloc] initWithVoiceShortcut:voiceShortcuts[0]];
                    editVoiceShortcutViewController.delegate = self;
                    [self presentViewController:editVoiceShortcutViewController animated:YES completion:nil];
                } else {
                    INShortcut *shortcut = [[INShortcut alloc] initWithIntent:self.intent];
                    INUIAddVoiceShortcutViewController *addVoiceShortcutViewController = [[INUIAddVoiceShortcutViewController alloc] initWithShortcut:shortcut];
                    addVoiceShortcutViewController.delegate = self;
                    [self presentViewController:addVoiceShortcutViewController animated:YES completion:nil];
                }
            });
        }];
    }
}


- (SiriDemoIntent *)intent API_AVAILABLE(ios(12.0)){
    if (!_intent) {
        _intent = [[SiriDemoIntent alloc] init];
        _intent.suggestedInvocationPhrase = @"启动SiriDemo";   //在Siri语音设置时显示的建议设置唤起文字
    }
    return _intent;
}


#pragma mark - INUIAddVoiceShortcutButtonDelegate
- (void)presentAddVoiceShortcutViewController:(INUIAddVoiceShortcutViewController *)addVoiceShortcutViewController forAddVoiceShortcutButton:(INUIAddVoiceShortcutButton *)addVoiceShortcutButton API_AVAILABLE(ios(12.0)){
    addVoiceShortcutViewController.delegate = self;
    [self presentViewController:addVoiceShortcutViewController animated:YES completion:nil];
}

- (void)presentEditVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)editVoiceShortcutViewController forAddVoiceShortcutButton:(INUIAddVoiceShortcutButton *)addVoiceShortcutButton API_AVAILABLE(ios(12.0)){
    editVoiceShortcutViewController.delegate = self;
    [self presentViewController:editVoiceShortcutViewController animated:YES completion:nil];
}

#pragma mark - INUIAddVoiceShortcutViewControllerDelegate
- (void)addVoiceShortcutViewController:(INUIAddVoiceShortcutViewController *)controller didFinishWithVoiceShortcut:(INVoiceShortcut *)voiceShortcut error:(NSError *)error
API_AVAILABLE(ios(12.0)){
    if(error == nil){
        [self.tempBtn setTitle:@"添加成功" forState:UIControlStateNormal];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)addVoiceShortcutViewControllerDidCancel:(INUIAddVoiceShortcutViewController *)controller API_AVAILABLE(ios(12.0)){
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - INUIEditVoiceShortcutViewControllerDelegate
- (void)editVoiceShortcutViewControllerDidCancel:(INUIEditVoiceShortcutViewController *)controller API_AVAILABLE(ios(12.0)){
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)editVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)controller didUpdateVoiceShortcut:(INVoiceShortcut *)voiceShortcut error:(NSError *)error API_AVAILABLE(ios(12.0)){
    if(error == nil){
        [self.tempBtn setTitle:@"修改成功" forState:UIControlStateNormal];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)editVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)controller didDeleteVoiceShortcutWithIdentifier:(NSUUID *)deletedVoiceShortcutIdentifier API_AVAILABLE(ios(12.0)){
    [self.tempBtn setTitle:@"Siri" forState:UIControlStateNormal];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)addMenuItemShortcuts
{
    //如果没有在APP内添加Siri，用此方法可以在设置-Siri搜索建议中找到该APP 并添加
    if (@available(iOS 12.0, *)){
        SiriDemoIntent *intent = [[SiriDemoIntent alloc] init];
        intent.suggestedInvocationPhrase = NSLocalizedString(@"SIRI_SHORTCUT_CORRECT_WORK", nil);
        [[INVoiceShortcutCenter sharedCenter] setShortcutSuggestions:@[[[INShortcut alloc] initWithIntent:intent]]];
    }
}


@end
