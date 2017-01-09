case=$(config case)

if test -z $case; then
  run_story case case packages
  run_story case case user
  run_story case case cpan
  run_story case case group
  run_story case case service
  run_story case case directory
else
  run_story case case $case
fi
