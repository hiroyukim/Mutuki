package Mutuki::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::RouterSimple;

connect '/'                 => 'Root#index';
connect '/wiki/group/show'       => 'Wiki::Group#show';
connect '/wiki/group/add'        => 'Wiki::Group#add';
connect '/wiki/group/edit'       => 'Wiki::Group#edit';
connect '/wiki/group/delete'     => 'Wiki::Group#delete';
connect '/wiki/group/wiki/list'  => 'Wiki::Group::Wiki#list';

connect '/wiki/show'       => 'Wiki#show';
connect '/wiki/add'        => 'Wiki#add';
connect '/wiki/edit'       => 'Wiki#edit';
connect '/wiki/delete'     => 'Wiki#delete';
connect '/wiki/wiki/list'  => 'Wiki#wiki_list';

1;
