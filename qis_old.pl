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
my $pw="B0st0N!";

BEGIN {$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;}

#Formular ausfüllen
$mech->field('asdf', $bn);
$mech->field('fdsa', $pw);
$mech->submit();

# 3. Link, der mit 'download' beschriftet ist
$mech->follow_link( text_regex => qr/fungsverwaltung/i, n => 1 );
print "Prüfungsverwaltung gefunden...\n";

$mech->follow_link( text_regex => qr/Notenspiegel/i, n => 1 );
print "Notenspiegel gefunden...\n";

# 1. Link, dessen URL 'download' enthält.
$mech->follow_link(text_regex => qr/Abschluss MA Master of Engineering anzeigen/i);
print "'Info'-Feld gefunden...\n\n\n\n";

$te = HTML::TableExtract->new( headers => [qw(Prüfungstext Note)]  );
$te->parse(  $mech->content( decoded_by_headers => 1 )  );

 # Examine all matching tables
#@ar = $te;
# print Dumper \@ar;

my @list;

foreach my $ts ($te->tables) {
#  print "Table (", join(',', $ts->coords), "):\n";
#  print "HIER1\n";
  foreach my $zeile ($ts->rows) {
#  	print "\n";
  	
     #print join(',', @$row), "\n";
     foreach my $eintrag (@$zeile){
     	
     	$eintrag =~ s/\s//g; #Leerzeichen entfernen
#     	print ":  ".$eintrag;
     	
     	push(@list, $eintrag);
     	
     }
  }
}

#print Dumper @list;
@list = @list[4 .. $#list];
splice @list, -2;



#print join("\n", @list[3..$#list]), $/;

open (DATEI, ">D:/Data/Unterlagen/STUDIUM/Perl/qis_.txt") or die $!;
   #print DATEI map { "$_ => $daten{$_}\n" } keys %daten;
   #print DATEI @Keys;
	foreach (@list){
		print DATEI "$_ \n";	
	}
close (DATEI);


my %daten = @list;


#Anzahl der Hasheinträge aus dem Online Formular
my $numOnline = keys(%daten);
print "Einträge Online (Hash): $numOnline \n";

#Zur initialen Befüllung...
my @Keys = keys(%daten);
open (DATEI, ">D:/Data/Unterlagen/STUDIUM/Perl/qis_old.txt") or die $!;
   #print DATEI map { "$_ => $daten{$_}\n" } keys %daten;
   #print DATEI @Keys;
	foreach (@Keys){
		print DATEI "$_ \n";	
	}
close (DATEI);


#TEST ->neues Modul on Hand hinzufügen!!!
#$daten{'Test_Eintrag'} = "5,0";
$numOnline = keys(%daten);
print "Einträge Online (Hash): $numOnline \n";

#print "\n\n";
#@Keys = keys(%daten);
#	foreach (@Keys){
#		print "$_\n";	
#	}

#print "Hash: \n\n\n\n\n";
#print Dumper \%daten;
#print "Anzahl Einträge: $numOnline \n";
#print "@list";
#print $daten{"IT-Projektmanagement"};

#sub del_double{
#my %all=();
#@all{@_}=1;
#return (keys %all);
#}

#@l2=&del_double(@l);


# Exists Prüfung
#foreach (@Keys){
#	print "Exists: $_ - $daten{$_}\n" if exists $daten{$_};	
#}


############### Noten aus txt-file lesen
#open (DATEI, "/Users/manni/Documents/qis_old.txt") or die $!;
open (DATEI, "D:/Data/Unterlagen/STUDIUM/Perl/qis_old.txt") or die $!;
	my @old_daten = <DATEI>;
	close (DATEI);
my $numFile = $#old_daten+1;
print "\n\n";
print "Einträge Datei - ","$#old_daten"+1,"\n";
#	foreach (@old_daten){
#		print "$_";	
#	}
##################################################

#print "Einträge aus Online - "+"$#Keys"+1,"\n";
#foreach (@Keys){
#	print "$_ \n";	
#}




if ($numFile != $numOnline) {
	
	######  PushBullet

# API-Key von PushBullet
	my $apikey = "o.4t7FEwSvxj8f6qmGDpSvIH0V9bafbFXv";
	
	my $pb = WWW::PushBullet->new({apikey => $apikey});

# Nachricht an Device versenden
	$pb->push_note(
		{
			#device_id => $device_id,
			title     => 'Noten im QIS',
#			body      => keys(%daten)
			body      => ''
#			body => map { "$_ => $daten{$_}\n" } keys %daten
		}
	);
	
	
	foreach ( keys %daten )  {
		$pb->push_note(
			{
				#device_id => $device_id,
				title     => $_,
	#			body      => keys(%daten)
				body      => $daten{$_}
	#			body => map { "$_ => $daten{$_}\n" } keys %daten
			}
	);
		
	}
	
	
}



# Noten in txt-file schreiben
#open (DATEI, ">/Users/manni/Documents/qis_old.txt") or die $!;
#open (DATEI, ">D:/Data/Unterlagen/STUDIUM/Perl/qis_old.txt") or die $!;
#   #print DATEI map { "$_ => $daten{$_}\n" } keys %daten;
#   #print DATEI @Keys;
#	foreach (@Keys){
#		print DATEI "$_ \n";	
#	}
#close (DATEI);




######  PushBullet

# API-Key von PushBullet
#my $apikey = "o.4t7FEwSvxj8f6qmGDpSvIH0V9bafbFXv";

#my $pb = WWW::PushBullet->new({apikey => $apikey});

# Nachricht an Device versenden
#$pb->push_note(
#{
#	device_id => $device_id,
#	title     => 'Noten im QIS: '+keys(%daten),
#	body      => keys(%daten)
#	body => map { "$_ => $daten{$_}\n" } keys %daten
#}
#);











#leerzeichen entfernen: $line =~ s/\s//g;
#title="Leistungen für Abschluss MA Master of Engineering anzeigen"

# Links finden und anzeigen
#my @links = $mech->links();
#foreach my $link (@links) {
#	print $link->url() , "\n";
#	print $link->url_abs()  , "\n"; 
#	print $link->text()  , "\n";
#	print  "\n\n\n";
#}

# Formulare auf der Seite ermitteln
#my @formulare = $mech->forms();
#foreach my $formular ( @formulare ) {
# $formular ist ein Object der Klasse HTML::Form
#print $formular->dump(), "\n";
#}

#Kompletten HTML-Content anzeigen
#my $content = $mech->content(decoded_by_headers => 1);
# print $content;