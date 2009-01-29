package MooseX::Attribute::Prototype::Object;

	use Moose;
	our $VERSION = '0.04';
	our $AUTHORITY = 'cpan:CTBROWN';



	has 'name' => ( 
		is			  => 'rw' , 
		isa			  => 'Str' ,
		required	  => 1 ,
		documentaion  => 'Name for atttribute prototype: [$role/$attribute]' ,
		trigger		  => 
			sub {
				my ( $self, $val, $meta ) = @_;

				$val =~ m/(.*)\/(.*)/;

				$self->role( $1 ) ;
				$self->attribute( $2 );
			}	
	);


	has 'role' => (
		is		 	  => 'rw' ,
		isa 	 	  => 'Str' ,
		required 	  => 0 ,
		lazy_build	  => 1 ,
		documentation => "Role name of the Prototype role" ,
	);

	  sub _build_role {

		$_[0]->name =~ m/(.*)\/(.*)/;
		return $1;

	  }
		

	has 'attribute' => ( 
		is 			  => 'rw' ,
		isa			  => 'Str' ,
		required	  => 0 ,
		lazy_build	  => 1 ,
		documentaion  => "Attribute name from prototype role." ,
	);

	  sub _build_attribute {

		  $_[0]->name =~ m/(.*)\/(.*)/;
		  return $1;

	  }


	has 'options' 	=> (
		is			  => 'rw' ,
		isa 		  => 'HashRef' ,
		required	  => 1 ,
		default 	  => sub { {} } ,
		documentation => "The options specifications for the attribute" ,
	);

	has 'referenced' => (
		is			  => 'rw' ,
		isa 		  => 'Bool' ,
		required	  => 1 ,
		default		  => 0 ,
		documentation => "Indicates if the attibute has been referenced as a prototype" , 
	);

	sub get_prototype_options {
		$_[0]->options;	
	} 


=pod

=head1 NAME 

MooseX::Attribute::Prototype::Object - Attribute Prototype Class

=head1 VERSION

0.04 - released 2009-01-26

=head1 SYNOPSIS
	
	use MooseX::Attribute::Prototype::Object;

	my $proto = MooseX::Attribute::Prototype::Object->new(
		name => 'foo/bar' ,
	);

=head1 DESCRIPTION

This module is use internally by L<MooseX::Attribute::Prototype> 
to manage the specifications for borrowed attributes.

This module provides an attribute prototype class,
L<MooseX::Attribute::Prototype::Object> that holds all of the user 
specification for an attribute without actually installing the 
attribute.  The prototype can later be accessed and used as defaults
for other attributes;  

=head1 Attributes

=head2 name (required)

The name for the attribute prototype in the form of C<role_name/attribute_name>.

=head2 role

The role in which the prototype attribute lives. This is automatically set. 

=head2 attribute

The name of the attribute for the prototype. This is automatically set.

=head2 options

The specifications for the attribute. This is automatically set.

=head2 referenced
	
=head1 SEE ALSO

L<MooseX::Attribute::Prototype>, 

L<MooseX::Attribute::Prototype::Object>,

L<MooseX::Attribute::Prototype::Collection>,

L<Moose>


=head1 AUTHOR

Christopher Brown, C<< <ctbrown at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-attribute at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Attribute-Prototpye>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::Attribute::Prototype

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Attribute-Prototype>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Attribute-Prototype>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Attribute-Prototype>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Attribute-Prototype>

=back


=head1 ACKNOWLEDGEMENTS

Though they would probably cringe to hear it, this effort would not have 
been possible without: 

Shawn Moore

David Rolsky

Thomas Doran

Stevan Little


=head1 COPYRIGHT & LICENSE

Copyright 2008 Christopher Brown and Open Data Group L<http://opendatagroup.com>, 
all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut	

1; # End of module MooseX::Attribute::Prototype::Object
