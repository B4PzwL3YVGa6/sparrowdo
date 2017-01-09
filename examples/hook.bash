case=$(config case)
#
if test -z $case; then
  run_story packages
  run_story user
  run_story cpan
  run_story group
  run_story service
else
  run_story $case
fi
