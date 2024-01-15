require_relative 'test_helper'

class LlmUtilTest < Minitest::Test
  def test_it_is_a_module
    assert_kind_of Module, LlmUtil
  end

  def test_that_it_has_a_version_number
    refute_nil ::LlmUtil::VERSION
  end
end
