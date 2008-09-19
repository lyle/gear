require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/custodians_controller'

# Re-raise errors caught by the controller.
class Admin::CustodiansController; def rescue_action(e) raise e end; end

class Admin::CustodiansControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::CustodiansController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
