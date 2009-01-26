# Collection Class for prototypes;
# 	Key is role/prototype
#		
package MooseX::Attribute::Prototype::Collection;

	our $VERSION = '0.03';
	our $AUTHORITY = 'cpan:CTBROWN';

	use Moose;
	use MooseX::AttributeHelpers;


	has 'prototypes' => (
		is			  => 'rw' ,
		isa			  => 'HashRef[MooseX::Attribute::Prototype::Object]' ,
		default		  => sub { {} } ,
		documentation => 'Slot containing hash of attribute prototypes' ,
		metaclass 	  => 'Collection::Hash' ,
		provides	  => {
			set 	=> 'set' ,
			get 	=> 'get' , 
			count	=> 'count' , 	
			exists	=> 'exists' ,
			keys	=> 'keys' ,
		} ,
	);
			

  # This is a simplified interface for set where you pass a prototype instead
  # of a name => prototype.
	sub add_prototype {
		
		my ( $self, $prototype ) = @_;
		$self->set( $prototype->name, $prototype );

	} 


  # set the reference property of the attribute described by key
	sub set_referenced { 

		$_[0]->get( $_[1] )->referenced(1);

	}


1;	

=pod

=head1 NAME

MooseX::Attribute::Prototype::Collection - Container class for MooseX::Attribute::Prototype::Object

=head1 VERSION 

0.02

=head1 SYNOPSIS

	use MooseX::Attribute::Prototype::Collection
	$collection = MooseX::Attribute::Prototype::Collection->new();

  # Add a MooseX::Attribute::Prototype::Object
	$collection->add_prototype( $prototype );

  # Retrieve a prototype from the collections
	$collection->get( 'MyRole/attr' );
	
  # Check if a prototype exists
	$collection->exists( 'MyRole/attr' );

=head1 DESCRIPTION

This class is used internally by MooseX::Attribute::Prototype
it serves as a container for holding the prototype objects	


