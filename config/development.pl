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
    'Mutuki' => {
        model => {
            Wiki => { 
                'storage' => 'MySQL',
            },     
            WikiHistory => { 
                'storage' => 'MySQL',
            },     
            WikiGroup => { 
                'storage' => 'MySQL',
            },     
            WikiGroupHistory => { 
                'storage' => 'MySQL',
            },     
            User => { 
                'storage' => 'MySQL',
            },     
            UserGroup => { 
                'storage' => 'MySQL',
            },     
        },
    },
};
