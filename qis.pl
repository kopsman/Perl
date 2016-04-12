#!/usr/local/perls/perl-5.20.0/bin/perl

use WWW::Mechanize;
use LWP;
use HTML::TableExtract;
use Data::Dumper;

my $mech = WWW::Mechanize->new();

$mech->get("https://qisweb.hispro.de/tel/rds?state=user&type=0");
my $bn="93211";
my $pw="st0N!";

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
print "Info gefunden...\n\n\n\n\n\n\n";

#Finde Tabelle Methode 1
#$te = HTML::TableExtract->new( depth => 0, count => 1 );
#$te->parse($mech->content());
#foreach $ts ($te->tables) {
#   print "Table found at ", join(',', $ts->coords), ":\n";
#   foreach $row ($ts->rows) {
#      print "   ", join(',', @$row), "\n";
#   }
#}

#Finde Tabelle Methode 2

 use HTML::TableExtract;
 $te = HTML::TableExtract->new( headers => [qw(Prüfungstext Note)]  );
 $te->parse(  $mech->content( decoded_by_headers => 1 )  );

 # Examine all matching tables
#@ar = $te;
# print Dumper \@ar;

my @list;

foreach $ts ($te->tables) {
  print "Table (", join(',', $ts->coords), "):\n";
#  print "HIER1\n";
  foreach $zeile ($ts->rows) {
  	print "\n";
  	
     #print join(',', @$row), "\n";
     foreach $eintrag (@$zeile){
     	
     	$eintrag =~ s/\s//g; #Leerzeichen entfernen
     	print ":  ".$eintrag;
     	
     	push(@list, $eintrag);
     	
     	
     }
  }
}

print Dumper @list;
@list = @list[4 .. $#list];
splice @list, -2;

#print join("\n", @list[3..$#list]), $/;
print Dumper @list;


my %daten = @list;
print "Hash: \n\n\n\n\n";
print Dumper \%daten;


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
