#!./perl

# $RCSfile: pipe.t,v $$Revision: 1.1 $$Date: 1996/05/01 10:52:47 $

use IO::Pipe;

$| = 1;
print "1..6\n";

$pipe = new IO::Pipe;

$pid = fork();

if($pid)
 {
  $pipe->writer;
  print $pipe "Xk 1\n";
  print $pipe "oY 2\n";
  $pipe->close;
  wait;
 }
elsif(defined $pid)
 {
  $pipe->reader;
  $stdin = bless \*STDIN, "IO::Handle";
  $stdin->fdopen($pipe,"r");
  exec 'tr', 'YX', 'ko';
 }
else
 {
  die;
 }

$pipe = new IO::Pipe;
$pid = fork();

if($pid)
 {
  $pipe->reader;
  while(<$pipe>) {
      s/^not //;
      print;
  }
  $pipe->close;
  wait;
 }
elsif(defined $pid)
 {
  $pipe->writer;

  $stdout = bless \*STDOUT, "IO::Handle";
  $stdout->fdopen($pipe,"w");
  print STDOUT "not ok 3\n";
  exec 'echo', 'not ok 4';
 }
else
 {
  die;
 }

$pipe = new IO::Pipe;
$pipe->writer;

$SIG{'PIPE'} = 'broken_pipe';

sub broken_pipe {
    print "ok 5\n";
}

print $pipe "not ok 5\n";
$pipe->close;


print "ok 6\n";

