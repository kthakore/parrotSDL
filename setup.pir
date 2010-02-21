#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    .const 'Sub' demo = 'demo'
    register_step('demo', demo)

    $P0 = new 'Hash'
    $P0['name'] = 'parrotSDL'
    $P0['abstract'] = 'SDL binding for Parrot'
    $P0['authority'] = 'http://github.com/kthakore'
    $P0['description'] = 'This is the SDL library bridge for Parrot VM.'
    $P5 = split ',', 'sdl,SDL,sdl'
    $P0['keywords'] = $P5
    $P0['license_type'] = 'Artistic License 2.0'
    $P0['license_uri'] = 'http://www.perlfoundation.org/artistic_license_2_0'
    $P0['copyright_holder'] = 'Parrot Foundation'
    $P0['checkout_uri'] = 'git://github.com/kthakore/parrotSDL.git'
    $P0['browser_uri'] = 'http://github.com/kthakore/parrotSDL'
    $P0['project_uri'] = 'http://github.com/kthakore/parrotSDL'

    # build
    $P1 = new 'Hash'
    $P1['SDL.pbc'] = 'SDL.pir'
    $P1['SDL/Rect.pbc'] = 'SDL/Rect.pir'
    $P1['SDL/Surface.pbc'] = 'SDL/Surface.pir'
    $P1['SDL/Color.pbc'] = 'SDL/Color.pir'
    $P0['pbc_pir'] = $P1

    # test
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0

    # install
    $P2 = split ' ', 'SDL.pbc'
    $P0['inst_lib'] = $P2

    .tailcall setup(args :flat, $P0 :flat :named)
.end

.sub 'demo' :anon
    .param pmc kv :slurpy :named
    run_step('build', kv :flat :named)

    .local string cmd
    cmd = get_parrot()
    cmd .= " demo/sdl/blue_rect.pir"
    system(cmd)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
