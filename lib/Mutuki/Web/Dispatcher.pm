package Mutuki::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::RouterSimple;

connect '/'                 => 'Root#index';
connect '/group/show'       => 'Group#show';
connect '/group/add'        => 'Group#add';
connect '/group/edit'       => 'Group#edit';
connect '/group/delete'     => 'Group#delete';
connect '/group/wiki/list'  => 'Group#wiki_list';

connect '/wiki/show'       => 'Wiki#show';
connect '/wiki/add'        => 'Wiki#add';
connect '/wiki/edit'       => 'Wiki#edit';
connect '/wiki/delete'     => 'Wiki#delete';
connect '/wiki/wiki/list'  => 'Wiki#wiki_list';

1;
