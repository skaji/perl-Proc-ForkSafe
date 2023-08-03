[![Actions Status](https://github.com/skaji/perl-Proc-ForkSafe/actions/workflows/test.yml/badge.svg)](https://github.com/skaji/perl-Proc-ForkSafe/actions)

# NAME

Proc::ForkSafe - help make objects fork safe

# SYNOPSIS

    use Proc::ForkSafe;

    package MyPersistentTCPClient {
      sub new {
        ...
      }
      sub request {
        ...
      }
    }

    my $client = Proc::ForkSafe->wrap(sub { MyPersistentTCPClient->new });
    my $res = $client->call(request => @some_argv);

    my $pid = fork // die;
    if ($pid == 0) {
      # in child process, $client will be reinitialized
      my $res2 = $client->call(request => @some_argv);
      ...
      exit;
    }
    waitpid $pid, 0;

# DESCRIPTION

Proc::ForkSafe helps make objects fork safe.

# COPYRIGHT AND LICENSE

Copyright 2023 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
