require File.dirname(__FILE__) + '/../test_helper'
require 'costody_controller'

# Re-raise errors caught by the controller.
class CostodyController; def rescue_action(e) raise e end; end

class CostodyControllerTest < Test::Unit::TestCase
  def setup
    @controller = CostodyController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
