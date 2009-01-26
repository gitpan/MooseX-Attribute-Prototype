package MooseX::Attribute::Prototype;

	use 5.008;

	our $VERSION = '0.03';
	our $AUTHORITY = 'cpan:CTBROWN';
	
	use Moose;
	use Moose::Exporter;
	use MooseX::Attribute::Prototype::Meta;
	use Moose::Util::MetaRole;

	Moose::Exporter->setup_import_methods();	
		
    sub init_meta {
		
		my ( $caller, %options ) = @_;

        Moose::Util::MetaRole::apply_metaclass_roles(
			for_class		=> $options{for_class} ,
			metaclass_roles => [ 'MooseX::Attribute::Prototype::Meta' ] ,
        );   

    }


__END__

=pod 

=head1 NAME

MooseX::Attribute::Prototype - Borrow and Extend Moose Attrtibutes

=head1 VERSION

0.03 - Released 2009-01-25

=head1 SYNOPSIS

    package MyClass;
	use Moose;
	use MooseX::Attribute::Prototype;

	has 'my_attr' => (
		is 		  => 'rw' ,
		isa		  => 'Str' ,
		prototype => 'MyRole/MyAttr' ,
	);

=head1 DESCRIPTION

This module loads a metaclass role that supports attribute prototyping,
the practice of borrowing and (possibly) extending/overriding a 
predefined attributes.  It works much like extending a class. 

When you have a prototype in your attribute definition, you borrow 
the settings from the prototype.  In many situations, this 
is all you will need. But sometimes you want to tweak beahaviors and/or
defaults.  L<MooseX::Attribute::Prototype> allows the defaults to be 
overridden with those defined in the class. The resulting attribute 
specification is installed in the class.


=head1 How to use Attribute Prototypes

Prototypes are just any ole attributes in any ole L<Moose::Role>. To use 
them simply specify the C<prototype> in your attribute definitions:

	prototype => 'role/attribute' 

where c<role> is the name of the role and c<attribute> is the name of 
the attribute.  



=head1 WHY?

L<MooseX::Role::Parameterized> and L<MooseX::Types> abstract
the roles and types, respectively. But surprisinly, there is no similar 
functionality for attributes. Moose leans towards viewing attributes
as containers for data.  However, it also provides the ability to store 
full-blown objects. And as they become more complex the can become 
unweildy. In fact, the attribute specifications, can often become the 
majority of code for a given application. Why not seperate these 
attributes into horizontally-reusable roles?  

L<MooseX::Attribute::Prototype> takes a functional view of attributes -- 
slots that can contain anything -- and provides an easy interface for 
making these slots reusable.

=head2 Why Not Moose's Attribute Clone Mechanism?

Moose's attribute cloning does not allow you to change the name 
of the derived attribute. You can take the defaults of an attribute from 
a role and change it's default, but good luck in changing the name of the
attribute.   

=head2 Subclassing Benefit

L<Moose> makes subclassing easy through the c<extends> sugar. More 
often than not, however, Moose applications are an amalgam of 
objects including other Moose classes and other CPAN modules. In these 
cases, one often places the objects in the the attributes. 
L<MooseX::Attributes::Prototypes> allows for the Moosifying of these CPAN
classes in a reusable way.

=head1 SEE ALSO

L<MooseX::Attribute::Prototype::Meta>, 

L<MooseX::Attribute::Prototype::Object>,

L<MooseX::Attribute::Prototype::Collection>,

L<Moose>

L<MooseX::Role::Parameterized> 

L<MooseX::Types>


=head1 AUTHOR

Christopher Brown, C<< <ctbrown at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-attribute-prototype at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Attribute-Prototype>.  I will be notified, and then you'll
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

Copyright 2008 Christopher Brown and Open Data Group L<http://opendatagroup.com>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of MooseX::Attribute::PrototypeZZ
