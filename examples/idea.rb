


# ActiveSpec
user = User.new(:username => 'luke')
spec = SizeSpecification.new(6, :username)
spec.satisfied_by? user

spec = CompositeSpecification.new
spec.add_specification(SizeSpecification.new(6, :username))
spec.add_specification(CollectionSpecification.new(18..30, :age))
spec.add_specification(ConfirmationSpecification.new(:password))
spec.satisfied_by?(User.new)
#=> false

# Rubylog
user = User.new(:username => 'luke')
U.username_valid.if U.size_of(:username,6)
user.username_valid?

# ActiveSpec
spec = CollectionSpecification.new(1..10, :age)
# or validates_inclusion_of :age, :in => 1..10
spec_two = NotSpecification.new(CollectionSpecification.new(1..10, :age))
# or validates_exclusion_of :age, :in => 1..10

# Rubylog
U.age_valid.if ~ U.is_included(:age, 1..10)

# ActiveSpec
spec = ProcSpecification.new(proc{ |object|
  # do something with object
  # and return true or false
})
spec.satisfied_by? some_object

U.everything_valid.if {|u|
  # do something w/ u and return true/false
}

# ActiveSpec
class UserSpecification < ActiveSpec::Base
	requires_presence_of :username, :password
	requires_size 6, :password
	requires_confirmation_of :password
	requires_inclusion_in 18..30, :age
end
UserSpecification.satisfied_by?(some_user)

# Rubylog
UserValidationTheory = Rubylog::Theory.new do
protected
  U.invalid.if (U.username=N) & N.blank
  U.invalid.if (U.password=P) & P.size=K & K.is_not 6
  U.invalid.if (U.password_confirmation=C) & (U.password=P) & (K.is_not P)
  U.invalid.if (U.age=A) & ~:include[18..30, A]
public
  U.valid_user.if ~U.invalid
end

User.include_theory UserValidationTheory
some_user.valid_user?


# ActiveSpec
specification :valid_user do
  requires_presence_of :username, :password
  requires_confirmation_of :password
  must_satisfy :another_specification
end

ValidUserSpecification.satisfied_by?(some_user)

# Rubylog
# app/theories/valid_user_theory.rb
theory :valid_user do
  U.valid_user.if ~U.invalid
protected
  U.invalid.if (U.username=N) & N.blank
  U.invalid.if (U.password=P) & P.size=K & K.is_not 6
  U.invalid.if (U.password_confirmation=C) & (U.password=P) & (K.is_not P)
  U.invalid.if (U.age=A) & ~:include[18..30, A]
end

User.include_theory :valid_user
some_user.valid_user?





# ActiveSpec
class User
  must_satisfy :valid_user_specification

  # optional :if argument takes a symbol or a block
  # and can be used for conditional evaluation of
  # specifications
  must_satisfy :activated_user_specification, :if => :activated?
end

user = User.new
user.satisfies_specs?
# evaluates ValidUserSpecification
user.activated = true
user.satisfies_specs?
# evaluates both specifications


# Rubylog
class User
  include_theory :valid_user, :activated_user
  def satisfies_specs?
    !bad?
  end
end

theory :valid_user do
  U.bad.if ~U.valid_user
protected
  #...
end

theory :activated_user do
  U.bad.if U.activated.and ~U.valid_activated_user
protected
  # ...
end















