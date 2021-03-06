package Mutuki::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::RouterSimple;
use Mutuki::Plugin::Web::Dispatcher::AutoLoad;

connect '/login/'                => { controller => 'Login',       action => 'index'  };
connect '/login/do'              => { controller => 'Login',       action => 'do'     };
connect '/logout/do'             => { controller => 'Logout',      action => 'do'     };

connect '/'                      => { controller => 'Root',        action => 'index'  };
connect '/wiki/group/show'       => { controller => 'Wiki::Group', action => 'show'   };
connect '/wiki/group/edit'       => { controller => 'Wiki::Group', action => 'edit'   };

connect '/wiki/show'       => { controller => 'Wiki', action => 'show'   };
connect '/wiki/add'        => { controller => 'Wiki', action => 'add'    };
connect '/wiki/edit'       => { controller => 'Wiki', action => 'edit'   };
connect '/wiki/delete'     => { controller => 'Wiki', action => 'delete' };
connect '/wiki/list'       => { controller => 'Wiki', action => 'list'   };
connect '/wiki/history'    => { controller => 'Wiki', action => 'history'   };


connect '/admin/'                => { controller => 'Admin',       action => 'index'  };
connect '/admin/user/'           => { controller => 'Admin::User', action => 'index'  };
connect '/admin/user/show'       => { controller => 'Admin::User', action => 'show'   };
connect '/admin/user/add'        => { controller => 'Admin::User', action => 'add'    };
connect '/admin/user/edit'       => { controller => 'Admin::User', action => 'edit'   };
connect '/admin/user/delete'     => { controller => 'Admin::User', action => 'delete' };

connect '/admin/user/group/'           => { controller => 'Admin::User::Group', action => 'index'  };
connect '/admin/user/group/show'       => { controller => 'Admin::User::Group', action => 'show'   };
connect '/admin/user/group/add'        => { controller => 'Admin::User::Group', action => 'add'    };
connect '/admin/user/group/edit'       => { controller => 'Admin::User::Group', action => 'edit'   };
connect '/admin/user/group/delete'     => { controller => 'Admin::User::Group', action => 'delete' };

connect '/admin/user/attribute/group/add'   => { controller => 'Admin::User::Attribute::Group', action => 'add'    };
connect '/admin/user/attribute/group/delete'   => { controller => 'Admin::User::Attribute::Group', action => 'delete'    };

connect '/admin/wiki/group/'           => { controller => 'Admin::Wiki::Group', action => 'index'  };
connect '/admin/wiki/group/show'       => { controller => 'Admin::Wiki::Group', action => 'show'   };
connect '/admin/wiki/group/add'       => { controller => 'Admin::Wiki::Group', action => 'add'   };

connect '/admin/wiki/group/attribute/user/group/edit'        => { controller => 'Admin::Wiki::Group::Attribute::User::Group', action => 'edit'         };
connect '/admin/wiki/group/attribute/user/group/edit_thanks' => { controller => 'Admin::Wiki::Group::Attribute::User::Group', action => 'edit_thanks'  };

1;
