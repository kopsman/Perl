#!/usr/local/perls/perl-5.20.0/bin/perl

#use strict;
use warnings;
use WWW::Mechanize;
use LWP::UserAgent;
use HTML::TableExtract;
use Data::Dumper;
use WWW::PushBullet;
    

my $mech = WWW::Mechanize->new();

$mech->get("https://qisweb.hispro.de/tel/rds?state=user&type=0");
my $bn="93211";
my $pw="B0s";

BEGIN {$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;}

#Formular ausfüllen
$mech->field('asdf', $bn);
$mech->field('fdsa', $pw);
$mech->submit();
#asdfasdf

# 3. Link, der mit 'download' beschriftet ist
$mech->follow_link( text_regex => qr/fungsverwaltung/i, n => 1 );
print "Prüfungsverwaltung gefunden...\n";

$mech->follow_link( text_regex => qr/Notenspiegel/i, n => 1 );
print "Notenspiegel gefunden...\n";

# 1. Link, dessen URL 'download' enthält.
$mech->follow_link(text_regex => qr/Abschluss MA Master of Engineering anzeigen/i);
print "'Info'-Feld gefunden...\n";

$te = HTML::TableExtract->new( headers => [qw(Prüfungstext Note)]  );
$te->parse(  $mech->content( decoded_by_headers => 1 )  );


my @list;

foreach my $ts ($te->tables) {

  foreach my $zeile ($ts->rows) {

     foreach my $eintrag (@$zeile) {
     	
     	$eintrag =~ s/\s//g; #Leerzeichen entfernen
     	
     	push(@list, $eintrag);
     	
     }
  }
}

###### Bereinigung des Arrays
@list = @list[4 .. $#list];
splice @list, -2;

my %daten = @list;


#Anzahl der Hasheinträge aus dem Online Formular
my $numOnline = keys(%daten);
print "Einträge Online (Hash): $numOnline \n";

	#Zur initialen Befüllung...
	#my @Keys = keys(%daten);
	#open (DATEI, ">D:/Data/Unterlagen/STUDIUM/Perl/qis_old.txt") or die $!;
	#	foreach (@Keys){
	#		print DATEI "$_ \n";	
	#	}
	#close (DATEI);


	#TEST ->neues Modul on Hand hinzufügen!!!
	#$daten{'Test_Eintrag'} = "5,0";
	#$numOnline = keys(%daten);
	#print "Einträge Online (Hash): $numOnline \n";


############### Noten aus txt-file lesen
#open (DATEI, "/Users/manni/Documents/qis_old.txt") or die $!;
open (DATEI, "D:/Data/Unterlagen/STUDIUM/Perl/qis_old.txt") or die $!;
	my @old_daten = <DATEI>;
	close (DATEI);
my $numFile = $#old_daten+1; # +1 weil Array bei 0 beginnt

print "Einträge Datei - ","$#old_daten"+1,"\n";
#	foreach (@old_daten){
#		print "$_";	
#	}
##################################################

if ($numFile != $numOnline) {
	
###############  PushBullet

# API-Key von PushBullet
	my $apikey = "o.4t7FEwSvxj8f6qmGDpSvIH0V9bafbFXv";
	
	my $pb = WWW::PushBullet->new({apikey => $apikey});

# Nachricht an Device versenden
	$pb->push_note(
		{
			#device_id => $device_id,
			title     => 'Noten im QIS',
			body      => ''
		}
	);
	
	
	foreach ( keys %daten )  {
		$pb->push_note(
			{
				#device_id => $device_id,
				title     => $_,
				body      => $daten{$_}
			}
		);
		
	}
		
}


###############  PushBullet# Noten in txt-file schreiben
my @Keys = keys(%daten);
open (DATEI, ">D:/Data/Unterlagen/STUDIUM/Perl/qis_old.txt") or die $!;
	foreach (@Keys){
		print DATEI "$_ \n";	
	}
close (DATEI);

# Noten in txt-file schreiben
#open (DATEI, ">/Users/manni/Documents/qis_old.txt") or die $!;
#open (DATEI, ">D:/Data/Unterlagen/STUDIUM/Perl/qis_old.txt") or die $!;
#   #print DATEI map { "$_ => $daten{$_}\n" } keys %daten;
#   #print DATEI @Keys;
#	foreach (@Keys){
#		print DATEI "$_ \n";	
#	}
#close (DATEI);










