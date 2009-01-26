package MooseX::Attribute::Prototype::Meta;

	our $VERSION = '0.03';
	our $AUTHORITY = 'cpan:CTBROWN';

	use Moose::Role;
	use MooseX::Attribute::Prototype::Object;
	use MooseX::Attribute::Prototype::Collection;
	use MooseX::AttributeHelpers;


  # This keeps the queue of the roles to keep track which roles the prototype
  # attribtutes come from.   
	has prototype_queue => (
		metaclass	=> 'Collection::Array' ,
		is			=> 'rw' ,
		isa			=> 'ArrayRef[Str]' ,
		default		=> sub { [] } ,
		required	=> 1 ,
		provides	=> {
			'unshift' => 'queue_role' ,
			'shift'   => 'dequeue_role' ,
			'get'	  => 'get_role' ,
			'count'	  => 'queue_size' ,
		} ,
	);

	
	has 'prototypes' => (
                is              => 'rw' ,
                isa             => 'MooseX::Attribute::Prototype::Collection' ,
                default         => sub { MooseX::Attribute::Prototype::Collection->new() } ,
                required        => 1 ,
				documentation   => 'Slot for holding the prototypes definitions' ,
                handles => [ 
					'add_prototype' , 
					'get_prototype' , 
					'count_prototypes' , 
					'get_prototype_keys' ,
				] ,
    );


	around 'add_attribute' => sub {
		
		my ( $add_attribute, $self, $name, @options ) = @_;

		my %opts;
		if ( scalar @options % 2 == 0 ) {
			%opts = @options;
		} else { #if ( scalar @options == 1 ) {
			%opts = %{ $options[0] };
		}


      # CASE: prototype used in attribute specification.  	 
	  #   If specified with 'prototype' we need to first load that roll 
      #   into the prototypes slot. Borrow those attributes and 
	  
        if ( $opts{ prototype } ) {

			# $self->flag( $self->flag + 1 ); # Indicates that all attributes until 
			#			      # the flag are unset should be diverted into
			#					# the prototype slot
			
			my $role_name = _role_from_prototype( $opts{ prototype } );
	  
		    $self->queue_role( $role_name );  # Keeps track of the 


		  # Dynamic loading of classes.
			Class::MOP::load_class( $role_name );			
			my $role = Moose::Meta::Role->initialize( $role_name );
			$role->apply( $self );


		  # Now, let's construct the new opt string from the prototype.
			my $proto = $self->prototypes->get( $opts{ prototype } ) 
				|| confess( $opts{ prototype } . " does not exist" );

		  # Clobber the prototype options with those specified in the 
		  # class  		
			my %new_opts = ( %{ $proto->options }, %opts );
 
		  # Now. let's install the attribute, finally!
			$self->$add_attribute( $name, %new_opts );	

		  # Mark the prototype as referenced
			$self->prototypes->set_referenced( $opts{ prototype } );


		  # We are done borrowing
			$self->dequeue_role;  # We are done with the prototype roll now. 
			# $self->flag( $self->flag - 1 );     # Set the flag.


 		} elsif ( $self->queue_size > 0 ) { 
		
		  # We were not using a prototype, but the flag is set 
          # -  divert the install to the prototypes.
			
			$self->get_role(0); # role_name.  We do not remove this from the queue since
								# each role can provide multiple attributes.

			$self->prototypes->add_prototype( 
				MooseX::Attribute::Prototype::Object->new( 
					name => $self->get_role(0) . "/" . $name ,
					options => \%opts 
				)
			);
 
		} else {

		  # PLAIN OLD ATTRIBUTE
		  $self->$add_attribute( $name, @options );

		} 

	}; 



# These should be exported from MooseX::Attribute::Prototype::Object
	sub _role_from_prototype {

		$_[0] =~ m/(.*)\/(.*)/;
		return $1;

	}


	sub _attribute_from_prototype {

		$_[0] =~ m/(.*)\/(.*)/;
		return $2;

	}


	no Moose::Role;



=pod

=head1 NAME 

MooseX::Meta::Prototype::Meta - Metaclass Role for Attribute Prototypes

=head1 VERSION 

0.03 - Released 2009-01-25

=head1 SYNOPSIS

Please see L<MooseX::Attribute::Prototype>.

=head1 DESCRIPTION

This metaclass role, when injected into an objects metaclass provides
the ability to borrow and extend Moose attributes.

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


1; # End of module MooseX::Attribute::Prototype::Meta
