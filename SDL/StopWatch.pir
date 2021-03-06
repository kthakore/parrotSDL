
# $Id: StopWatch.pir 40191 2009-07-21 12:56:20Z bacek $

=head1 NAME

SDL::StopWatch - A stopwatch using SDL::LCD

=head1 SYNOPSIS

    # create the stopwatch
    watch = new 'SDL::StopWatch', screen

    # set its position
    watch.'xpos'( 5 )
    watch.'ypos'( 5 )

    # start it
    watch.'start'()

=head1 DESCRIPTION

You can start, stop and reset this stopwatch. You do not need
to draw it while it is running, this is done by an internal
timer.

=head1 METHODS

An SDL::StopWatch object has the following methods:

=over 4

=cut
.loadlib 'math_ops'
.include "timer.pasm"
.include "iterator.pasm"
.namespace ['SDL::StopWatch']

.sub __onload :load
    .local pmc class
    class = get_class 'SDL::StopWatch'
    if_null class, create_class
    .return()

  create_class:
    load_bytecode "SDL/LCD.pir"
    class = get_class 'SDL::LCD'
    class = subclass class, 'SDL::StopWatch'
    addattribute class, 'time'
    addattribute class, 'precision'
    addattribute class, 'start'
    addattribute class, 'screen'
END:
.end

=item __init( screen )

Creates a StopWatch object.

The stopwatch will be drawn onto the specified screen.

=cut

.sub init :vtable :method
    .param pmc screen

    $P0 = new 'Float'
    $P0 = 0
    setattribute self, 'time', $P0

    $P0 = new 'Float'
    $P0 = 0.1
    setattribute self, 'precision', $P0

    $P0 = new 'Float'
    $P0 = 0
    setattribute self, 'start', $P0

    setattribute self, 'screen', screen

    self.'_digits'( 10 )
    self = "000:00:00"
.end

=item reset()

Resets the stopwatch.

=cut

.sub reset :method
    .local pmc total
    .local pmc precision
    .local pmc start

    # read the attributes
    total     = getattribute self, 'time'
    precision = getattribute self, 'precision'
    start     = getattribute self, 'start'

    total     = 0
    start     = 0
.end

=item start()

Starts the stopwatch.

=cut

.sub start :method
    .local pmc total
    .local pmc precision
    .local pmc start

    # read the attributes
    total     = getattribute self, 'time'
    precision = getattribute self, 'precision'
    start     = getattribute self, 'start'

    if start != 0 goto END

    total = 0
    time $N0
    start = $N0

    $P0 =  get_hll_global ["SDL::StopWatch::Timer"], "addWatch" 
    $P0( self )
END:
.end

=item stop()

Stops the stopwatch.

=cut

.sub stop :method
    .local pmc total
    .local pmc precision
    .local pmc start

    # read the attributes
    total     = getattribute self, 'time'
    precision = getattribute self, 'precision'
    start     = getattribute self, 'start'

    if start == 0 goto END

    time $N0
    $N1   = start
    $N0   = $N0 - $N1

    $N1   = total
    $N0  += $N1

    $N1   = precision
    $N0  /= $N1

    total = $N0
    start = 0

    $P0   = get_hll_global ["SDL::StopWatch::Timer"], "removeWatch" 
    $P0( self )
END:
.end

=item current_time()

Returns the measured time, multiplied by the
reciprocal of the precision value.

=cut

.sub current_time :method
    .local pmc total
    .local pmc precision
    .local pmc start
    .local int ret

    # read the attributes
    total     = getattribute self, 'time'
    precision = getattribute self, 'precision'
    start     = getattribute self, 'start'

    ret = total
    if start == 0 goto END

    time $N0
    $N1   = start
    $N0   = $N0 - $N1

    $N1   = total
    $N0  += $N1

    $N1   = precision
    $N0  /= $N1
    ret   = $N0

END:
    .return( ret )
.end

=item draw()

Updates the stopwatch and draws it.

It is drawn onto the screen consigned to the constructor.

=cut

.sub draw :method
    $I0 = self.'current_time'()

    cmod $I5, $I0, 10
    $I0 /= 10
    cmod $I4, $I0, 10
    $I0 /= 10
    cmod $I3, $I0, 6
    $I0 /= 6
    cmod $I2, $I0, 10
    $I0 /= 10
    cmod $I1, $I0, 6
    $I0 /= 6

    $S0 = $I0
    $S1 = $I1
    $S2 = $I2
    $S3 = $I3
    $S4 = $I4
    $S5 = $I5

    concat $S0, ":"
    concat $S0, $S1
    concat $S0, $S2
    concat $S0, ":"
    concat $S0, $S3
    concat $S0, $S4
    concat $S0, "."
    concat $S0, $S5

    self = $S0

    .local pmc screen
    screen = getattribute self, 'screen'
    $P0    = get_hll_global ["SDL::LCD"], "draw"

    $P0( screen )
.end

.namespace ["SDL::StopWatch::Timer"]

.sub __onload :load
    # XXX: an old array will be overwritten when loading this file again
    $P0 = new 'ResizablePMCArray'
    set_hll_global ["SDL::StopWatch::Timer"], "array", $P0

    $P0 = new 'FixedPMCArray'
    $P1 = get_hll_global ["SDL::StopWatch::Timer"], "tick"
    $P0 = 8
    $P0[0] = .PARROT_TIMER_NSEC
    $P0[1] = 0.1
    $P0[2] = .PARROT_TIMER_HANDLER
    $P0[3] = $P1
    $P0[4] = .PARROT_TIMER_REPEAT
    $P0[5] = -1
    $P0[6] = .PARROT_TIMER_RUNNING
    $P0[7] = 0

    $P0 = new 'Timer', $P0
    set_hll_global ["SDL::StopWatch::Timer"], "timer", $P0
.end

.sub tick
    .local pmc timer
    .local pmc array

    timer = get_hll_global ["SDL::StopWatch::Timer"], "timer"
    array = get_hll_global ["SDL::StopWatch::Timer"], "array"

    $I0 = array
    if $I0 == 0 goto DISABLE

    array = iter array
LOOP:
    unless array goto END
    $P0 = shift array

    $P0.'draw'()

    branch LOOP

DISABLE:
    timer[.PARROT_TIMER_RUNNING] = 0

END:
	.return()
.end

.sub addWatch
    .param pmc obj
    .local pmc timer
    .local pmc array

    timer = get_hll_global ["SDL::StopWatch::Timer"], "timer"
    array = get_hll_global ["SDL::StopWatch::Timer"], "array"

    push array, obj
    timer[.PARROT_TIMER_RUNNING] = 1
.end

.sub removeWatch
    .param pmc obj
    .local pmc timer
    .local pmc array

    timer = get_hll_global ["SDL::StopWatch::Timer"], "timer"
    array = get_hll_global ["SDL::StopWatch::Timer"], "array"

    # XXX: stops all watches ATM; just remove the timer from the array
    timer[.PARROT_TIMER_RUNNING] = 0
.end

=back

=head1 AUTHOR

Jens Rieks E<lt>parrot at jensbeimsurfen dot deE<gt> is the author
and maintainer.
Please send patches and suggestions to the Perl 6 Internals mailing list.

=head1 COPYRIGHT

Copyright (C) 2004-2008, Parrot Foundation.

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
