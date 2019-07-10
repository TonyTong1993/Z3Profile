//
//  ProfileModifyPasswordView.m
//  OutWork
//
//  Created by ZZHT on 2018/5/24.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "ProfileModifyPasswordView.h"

@implementation ProfileModifyPasswordView


- (IBAction)modifyPwdAction:(id)sender {
    if (![self check]) return;
    if (_delegate && [_delegate respondsToSelector:@selector(modifyPwdView:didClickedSubmitBtnWithNewPwd:oldPwd:)]) {
        [_delegate modifyPwdView:self didClickedSubmitBtnWithNewPwd:self.confirmPwdField.text oldPwd:self.orignalPwdField.text];
    }
}

- (BOOL)check {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSString *oldPwd = [self.orignalPwdField.text stringByTrimmingCharactersInSet:set];
    NSString *newPwd = [self.lastPwdField.text stringByTrimmingCharactersInSet:set];
    NSString *confirmPwd = [self.confirmPwdField.text stringByTrimmingCharactersInSet:set];
    if ([StringUtil isEmpty:oldPwd]) {
        [MBProgressHUD showError:LocalizedString(@"toast_orignal_password_is_empty")];
        return false;
    }
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_USER_PASSWORD];
    if (![password isEqualToString:oldPwd]) {
        [MBProgressHUD showError:LocalizedString(@"toast_orignal_password_not_equal")];
        return false;
    }
    
    if ([StringUtil isEmpty:newPwd]) {
        [MBProgressHUD showError:LocalizedString(@"toast_new_password_is_empty")];
        return false;
    }
    
    if ([StringUtil isEmpty:confirmPwd]) {
        [MBProgressHUD showError:LocalizedString(@"toast_confirm_password_is_empty")];
        return false;
    }
    
    if ( ![confirmPwd isEqualToString:newPwd]) {
        [MBProgressHUD showError:LocalizedString(@"toast_confirm_password_is_error")];
        return false;
    }
    
    return true;
}
@end
