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
};
