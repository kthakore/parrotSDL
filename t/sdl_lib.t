#!./parrot
# Copyright (C) 2009, Parrot Foundation.

=head1 NAME

t/sdl_lib.t - test parrot to external SDL connection

=head1 SYNOPSIS

    % prove t/sdl_lib.t

=head1 DESCRIPTION

=cut

.const int TESTS = 12 

.sub 'main' :main
    .include 'test_more.pir'

    plan(TESTS)

    load_bytecode 'SDL.pbc'
    'ok'(1, 'loaded SDL')

    load_bytecode 'SDL/Constants.pbc'
    'ok'(1, 'loaded Constants')
    
    load_bytecode 'SDL/Rect.pbc'
    'ok'(1, 'loaded SDL/Rect')

    load_bytecode 'SDL/Surface.pbc'
    'ok'(1, 'loaded SDL/Surface')

    load_bytecode 'SDL/Color.pbc'
    'ok'(1, 'loaded SDL/Color')

    load_bytecode 'SDL/Event.pbc' 
    'ok'(1, 'loaded SDL/Event')

    load_bytecode 'SDL/EventHandler.pbc' 
    'ok'(1, 'loaded SDL/EventHandler')

    load_bytecode 'SDL/Image.pbc' 
    'ok'(1, 'loaded SDL/Image')

    load_bytecode 'SDL/Font.pbc' 
    'ok'(1, 'loaded SDL/Font')

    load_bytecode 'SDL/App.pbc' 
    'ok'(1, 'loaded SDL/App')

    load_bytecode 'SDL/Button.pbc' 
    'ok'(1, 'loaded SDL/Button')

#    load_bytecode 'SDL/LCD.pbc' 
#    'ok'(1, 'loaded SDL/LCD')

    load_bytecode 'SDL/Sprite.pbc'
    'ok'(1, 'loaded SDL/Sprite')



.end
# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

