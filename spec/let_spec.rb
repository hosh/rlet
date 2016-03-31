require 'spec_helper'

describe Let do
  class TestRecorder
    include Let

    let(:memoized_true)  { record.push(Time.now); true }
    let(:memoized_false) { record.push(Time.now); false }
    let(:memoized_nil)   { record.push(Time.now); nil }

    letp(:protected_let)  { true }

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

  context 'using letp' do
    it 'should protect the defined method' do
      expect(test_recorder.public_methods).not_to include(:protected_let)
      expect(test_recorder.class.protected_instance_methods).to include(:protected_let)
      expect(test_recorder.send(:protected_let)).to eql(true)
    end

  end
end
