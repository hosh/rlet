require 'spec_helper'

describe Let do
  class TestRecorder
    include Let

    let(:memoized_true)  { record.push(Time.now); true }
    let(:memoized_false) { record.push(Time.now); false }
    let(:memoized_nil)   { record.push(Time.now); nil }

    def record
      @_record ||= []
    end
  end

  let(:test_recorder) { TestRecorder.new }

  it 'should memoize true value correctly' do
    expect(test_recorder.record).to be_empty
    expect(test_recorder.memoized_true).to eql(true)
    expect(test_recorder.record.size).to eql(1)
    expect(test_recorder.memoized_true).to eql(true)
    expect(test_recorder.record.size).to eql(1)
  end

  it 'should memoize false value correctly' do
    expect(test_recorder.record).to be_empty
    expect(test_recorder.memoized_false).to eql(false)
    expect(test_recorder.record.size).to eql(1)
    expect(test_recorder.memoized_false).to eql(false)
    expect(test_recorder.record.size).to eql(1)
  end

  it 'should memoize nil value correctly' do
    expect(test_recorder.record).to be_empty
    expect(test_recorder.memoized_nil).to eql(nil)
    expect(test_recorder.record.size).to eql(1)
    expect(test_recorder.memoized_nil).to eql(nil)
    expect(test_recorder.record.size).to eql(1)
  end
end
