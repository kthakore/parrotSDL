#!./parrot
# Copyright (C) 2009, Parrot Foundation.

=head1 NAME

t/sdl_lib.t - test parrot to external SDL connection

=head1 SYNOPSIS

    % prove t/sdl_lib.t

=head1 DESCRIPTION

=cut

.const int TESTS = 3 

.sub 'main' :main
    .include 'test_more.pir'

    plan(TESTS)

    load_bytecode 'SDL.pbc'
    'ok'(1, 'loaded SDL')

    load_bytecode 'SDL/Rect.pbc'
    'ok'(1, 'loaded SDL/Rect')

    load_bytecode 'SDL/Surface.pbc'
    'ok'(1, 'loaded SDL/Surface')


.end
# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

