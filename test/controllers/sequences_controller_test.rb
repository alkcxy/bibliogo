require 'test_helper'

class SequencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sequence = create(:sequence)
  end

  teardown do
    Sequence.delete_all
  end

  test "should get index" do
    get sequences_url
    assert_response :success
  end

  test "should get new" do
    get new_sequence_url
    assert_response :success
  end

  test "should create sequence" do
    assert_difference('Sequence.count') do
      post sequences_url, params: { sequence: { key: @sequence.key, value: @sequence.value } }
    end

    assert_redirected_to sequence_url(Sequence.last)
  end

  test "should show sequence" do
    get sequence_url(@sequence)
    assert_response :success
  end

end
