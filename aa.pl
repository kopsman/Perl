#!/usr/local/perls/perl-5.20.0/bin/perl
use Data::Dumper;

my @Sachen = ("Mathe   ",1.3,"Physik  ", 1.0);

splice  @Sachen, -1;

print Dumper @Sachen;

#foreach (@Sachen) {
#  $_ =~ s/\s//g;
#  print "$_\n";
#}

#my @array = (1, 2, 3, 'four');
#    my $reference = @array;
#    print $reference."\n";

%hash = @Sachen;
print Dumer \%hash;   

    
#$eingabe = "feldname1=wert1&feldname2=wert2&feldname3=wert3";
#@inp = split(/$/, $eingabe);
#%hash;
#foreach(@inp) {
#($var1, $var2) = split(/=/, $_);
#$hash{$var1} = $var2;
#}

#while(@array=each(%hash))
#{
# print "Wert: $array[0]    ";
# print "Schluessel: $array[1]\n";
#}


print Dumper \%hash;