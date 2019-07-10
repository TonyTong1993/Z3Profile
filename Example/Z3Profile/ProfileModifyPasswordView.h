//
//  ProfileModifyPasswordView.h
//  OutWork
//
//  Created by ZZHT on 2018/5/24.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileModifyPasswordViewDelegate<NSObject>
- (void)modifyPwdView:(UIView *)view didClickedSubmitBtnWithNewPwd:(NSString *)password oldPwd:(NSString *)oldPwd;
@end
@interface ProfileModifyPasswordView : UIView
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *orignalPwdField;
@property (weak, nonatomic) IBOutlet UITextField *lastPwdField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdField;
@property (weak, nonatomic) id<ProfileModifyPasswordViewDelegate> delegate;
@end
