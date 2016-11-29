##################################################################################
# The MIT License (MIT)                                                          #
#                                                                                #
# Copyright (c) 2016 Chris 'CJ' Jones                                            #
#                                                                                #
# Permission is hereby granted, free of charge, to any person obtaining a copy   #
# of this software and associated documentation files (the "Software"), to deal  #
# in the Software without restriction, including without limitation the rights   #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      #
# copies of the Software, and to permit persons to whom the Software is          #
# furnished to do so, subject to the following conditions:                       #
#                                                                                #
# The above copyright notice and this permission notice shall be included in all #
# copies or substantial portions of the Software.                                #
#                                                                                #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  #
# SOFTWARE.                                                                      #
##################################################################################
package less;

use Term::ReadKey;
use Time::HiRes qw(usleep);

use Data::Dumper;

my $filename = shift @ARGV;

my @lines;
my ($width, $height) = GetTerminalSize();

my $top = 0;
my $end = 0;

sub get_lines {
	my ($from, $to) = @_;
	my $fh;
	
	open($fh, "<", $filename);
	
	if ($from > $to) {
		die("From can not be greater than to");
	} else {
		for ($i = 0; $i < $to; $i++) {
			for ($j = 0; $j < $from; $j++) {
				# Do nothing
			}
			$lines[$i] = <$fh>;
			if ($lines[$i] eq undef) {
				$end = 1;
				last;
			}
		}
	}
}

sub render {
	for ($i = 0; $i < $height - 1; $i ++) {
		if ($i > scalar(@lines)) {
			last;
		}
		
		print $lines[$i + $top];
	}
	
	print "\n:";
	
	if (($end == 1) && ($top + $height > scalar(@lines) - 1)) {
		print "EOF";
	}
}

ReadMode 4;

while(1) {
	my $key;
	
	system("clear");
	
	if (defined($key = ReadKey(-1))) {
		if ($key eq "q") {
			#Quit
			last;
		} elsif (ord($key) eq 65) {
			#Up
			if ($top > 0) { 
				$top = $top - 1;
			}
		} elsif (ord($key) eq 66) {
			#Down
			if (($end == 1) && ($top + $height > scalar(@lines) - 1)) {
				#Do nothing.
			} else {
				$top = $top + 1;
			}
		}
	}
	
	get_lines(0, $top + $height - 1);
	
	render();
	
	usleep(500);
}

ReadMode 0;
