use v6;
use Test;

shell("perl6 -c bin/sparrowdo");

plan 1;

ok 1, 'sparrowdo client syntax check';

