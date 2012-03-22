package Mutuki::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::RouterSimple;
use Mutuki::Plugin::Web::Dispatcher::AutoLoad;

connect '/'                      => { controller => 'Root',        action => 'index'  };
connect '/wiki/group/show'       => { controller => 'Wiki::Group', action => 'show'   };
connect '/wiki/group/add'        => { controller => 'Wiki::Group', action => 'add'    };
connect '/wiki/group/edit'       => { controller => 'Wiki::Group', action => 'edit'   };
connect '/wiki/group/delete'     => { controller => 'Wiki::Group', action => 'delete' };
#connect '/wiki/group/wiki/list'  => 'Wiki::Group::Wiki#list';

connect '/wiki/show'       => { controller => 'Wiki', action => 'show'   };
connect '/wiki/add'        => { controller => 'Wiki', action => 'add'    };
connect '/wiki/edit'       => { controller => 'Wiki', action => 'edit'   };
connect '/wiki/delete'     => { controller => 'Wiki', action => 'delete' };
connect '/wiki/list'       => { controller => 'Wiki', action => 'list'   };

1;
