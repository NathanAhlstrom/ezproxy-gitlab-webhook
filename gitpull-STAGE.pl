#!/bin/env perl

print "hi";

##
## Run a `git pull` and restart services if necessary.
##
## This script is run on-demand using GitLab webhooks "Push Event";
## 
## author: Cameron Moore
## 
## From ezproxy listserv: 
## thread: https://ls.suny.edu/read/messages?id=3498638
## response: https://ls.suny.edu/read/archive?id=3498779
##

use strict;
use warnings;

## VARS ######

my $EMAIL_RCPT = 'you@example.com';
my $LOCAL_DIR  = '/opt/ezproxy';
my $SERVICE    = 'ezproxy';

## Commands
my $GIT       = "git --git-dir=$LOCAL_DIR/.git --work-tree=$LOCAL_DIR";
my $GIT_LOG   = "log -1 --format=%H";
my $MAILX     = '/bin/mailx';
my $SYSTEMCTL = '/sbin/service';
my $UNAME     = '/bin/uname -n';

## MAIN ######

## figure out where we are running this script first.
my @UNAME     = `$UNAME`;
push(@UNAME, "\n");

## Before we run a pull, get the existing commit hash of config.txt
my $ORIG_HASH = `$GIT $GIT_LOG`;
chomp($ORIG_HASH);

## Do the pull
my @RESULTS = `$GIT pull https://username:secretGITLABusertokenhere\@gitlab.example.org/Library/ezproxy.git master 2>&1`;

## Check new commit hash of config.txt
my $CURR_HASH = `$GIT $GIT_LOG`;
chomp($CURR_HASH);

printf("MAILX = %s\nSYSTEMCTL = %s\n", $MAILX, $SYSTEMCTL);
printf("GIT = %s\nGIT_LOG = %s\n", $GIT, $GIT_LOG);
printf("ORIG_HASH = %s\nCURR_HASH = %s\n", $ORIG_HASH, $CURR_HASH);
printf("RESULTS = %s\n", @RESULTS);
printf("UNAME = %s\n", @UNAME);

if ($CURR_HASH ne $ORIG_HASH) {
  ## Insert log summary of changes committed.
  push(@RESULTS, "\n");
  push(@RESULTS, `$GIT log --stat $ORIG_HASH..$CURR_HASH`);
  push(@RESULTS, "\n");

  ## Restart services
  my $err = system("$SYSTEMCTL $SERVICE restart");
  if ($err == 0) {
    push(@RESULTS, "\n\nService $SERVICE Restarted.");
  } else {
    push(@RESULTS, "\n\nService $SERVICE FAILED TO RESTART. Exist status: $err.");
  }
}

## Send email
open MAIL, "| $MAILX -s 'EZProxy git pulled to commit $CURR_HASH' $EMAIL_RCPT";
print MAIL @RESULTS;
print MAIL @UNAME;
close MAIL;
