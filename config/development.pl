use File::Spec;
use File::Basename qw(dirname);
my $basedir = File::Spec->rel2abs(File::Spec->catdir(dirname(__FILE__), '..'));
+{
    'DBI' => [
        "dbi:mysql:dbname=mutuki",
        'root',
        '',
        +{
        }
    ],
    model => {
        'Wiki' => { 
            'storage' => 'MySQL',
        },     
        'Wiki::History' => { 
            'storage' => 'MySQL',
        },     
        'Wiki::Group' => { 
            'storage' => 'MySQL',
        },     
        'Wiki::Group::History' => { 
            'storage' => 'MySQL',
        },     
        'User' => { 
            'storage' => 'MySQL',
        },     
        'User::Group' => { 
            'storage' => 'MySQL',
        },     
        'User::Attribute::Group' => {
            'storage' => 'MySQL',
        },
        'Wiki::Group::Attribute::User::Group' => {
            'storage' => 'MySQL',
        },
    },
    'Validator::Lite' => {
        message_data => {
            message  => {},
            param    => {
                name    => '名前(id)',
                nickname => 'ニックネーム',
                passwd   => 'パスワード', 
                passwd1 => 'パスワード', 
                passwd2 => 'パスワード(確認)', 
                passwds => 'パスワード',
                same_name => '同じ名前(id)',
                name_or_passwd => '名前(id)かパスワード',
            },
            function => {
                'no_match'    => '[_1]が間違えています。',
                'exists'      => '[_1]はすでに存在します。',
                'length'      => '[_1]の長さが適切では有りません。',
                ascii         => '[_1]は半角英数のみです。',
                not_null      => '[_1]は必須入力です',
                duplication   => '[_1]の入力が一致していません。',
            },
        },
    },
    Crypt => 'Default',
    admin_group_id => 1,
};
