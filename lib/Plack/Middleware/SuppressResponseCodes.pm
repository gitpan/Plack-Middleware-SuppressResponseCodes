package Plack::Middleware::SuppressResponseCodes;
{
  $Plack::Middleware::SuppressResponseCodes::VERSION = '0.1';
}
#ABSTRACT: Return HTTP Status code 200 for errors on request

use strict;
use parent qw(Plack::Middleware);

sub call {
    my($self, $env) = @_;
    my $res = $self->app->($env);
    $self->response_cb($res, sub {
		if ( $res->[0] =~ /^[45]../ and
        	 $env->{QUERY_STRING} =~ /(?:^|&)suppress_response_codes(=([^&]+))?/ 
		     and !($1 and $2 =~ /^(0|false)$/) ) {
			$res->[0] = 200;
		}
	});
}

1;



__END__
=pod

=head1 NAME

Plack::Middleware::SuppressResponseCodes - Return HTTP Status code 200 for errors on request

=head1 VERSION

version 0.1

=head1 SYNOPSIS

    use Plack::Builder;

    builder {
	    enable 'SuppressResponseCodes'
	    $app
	};

=head1 DESCRIPTION

Plack::Middleware::SuppressResponseCodes sets the HTTP status code of a
response to 200 if the response is an error (status code 4xx or 5xx) and the
query parameter C<suppress_response_codes> is present with any value except
C<0> or C<false>. This behaviour is useful for clients that cannot handle HTTP
errors.  It has been implemented in popular APIs such as Twitter and Microsoft
Live.

=encoding utf8

=head1 AUTHOR

Jakob Voß <voss@gbv.de>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

