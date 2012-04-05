use strict;
use warnings;
use Test::More;
use Mutuki::Plugin::Auth::Default;

subtest '_is_redirect_login' => sub {
    cmp_ok( Mutuki::Plugin::Auth::Default->_is_redirect_login('/'),          '==', 1 ,'ログイン画面以外でメンバーじゃない');
    cmp_ok( Mutuki::Plugin::Auth::Default->_is_redirect_login('/login/'),    '==', 0 ,'login画面でメンバーじゃない');
    cmp_ok( Mutuki::Plugin::Auth::Default->_is_redirect_login('/login/',{}), '==', 0 ,'login画面でメンバー');
};

subtest '_is_redirect_has_no_user_attribute_groups' => sub {
    cmp_ok( Mutuki::Plugin::Auth::Default->_is_redirect_has_no_user_attribute_groups('/'),          '==', 0 ,'TOPでユーザーはどこにも所属してない');
    cmp_ok( Mutuki::Plugin::Auth::Default->_is_redirect_has_no_user_attribute_groups('/login/'),    '==', 1 ,'TOP以外でユーザーはどこにも所属してない');
    cmp_ok( Mutuki::Plugin::Auth::Default->_is_redirect_has_no_user_attribute_groups('/login/',{}), '==', 0 ,'TOP以外でユーザーがどこかに所属している');
};

subtest '_is_user_belongs_to_admin_user_group_in_admin' => sub {
    cmp_ok( Mutuki::Plugin::Auth::Default->_is_user_belongs_to_admin_user_group_in_admin('/admin/',1,{ 1 => 1 }), '==', 1 ,'/adminいかでユーザーはアドミングループに所属している');
    cmp_ok( Mutuki::Plugin::Auth::Default->_is_user_belongs_to_admin_user_group_in_admin('/admin/',1,{ 2 => 1 }), '==', 0 ,'/admin/以下でユーザーはアドミングループに所属してない');
    cmp_ok( Mutuki::Plugin::Auth::Default->_is_user_belongs_to_admin_user_group_in_admin('/',      1,{ 1 => 1 }), '==', 0 ,'/以下でユーザーはアドミングループに所属している');
};

done_testing();
