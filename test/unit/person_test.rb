require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :people

  def test_should_create_person
    assert_difference Person, :count do
      person = create_person
      assert !person.new_record?, "#{person.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference Person, :count do
      u = create_person(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference Person, :count do
      u = create_person(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference Person, :count do
      u = create_person(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference Person, :count do
      u = create_person(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    people(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal people(:quentin), Person.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    people(:quentin).update_attributes(:login => 'quentin2')
    assert_equal people(:quentin), Person.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_person
    assert_equal people(:quentin), Person.authenticate('quentin', 'test')
  end

  def test_should_set_remember_token
    people(:quentin).remember_me
    assert_not_nil people(:quentin).remember_token
    assert_not_nil people(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    people(:quentin).remember_me
    assert_not_nil people(:quentin).remember_token
    people(:quentin).forget_me
    assert_nil people(:quentin).remember_token
  end

  protected
    def create_person(options = {})
      Person.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
