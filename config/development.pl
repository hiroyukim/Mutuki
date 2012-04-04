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
                name    => '名前',
                passwd1 => 'パスワード', 
                passwd2 => 'パスワード(確認)', 
                passwds => 'パスワード',
            },
            function => {
                'length'      => '[_1]の長さが適切では有りません。',
                ascii         => '[_1]は半角英数のみです。',
                not_null      => '[_1]は必須入力です',
                duplication   => '[_1]の入力が一致していません。',
            },
        },
    },
    Crypt => 'Default',
};
