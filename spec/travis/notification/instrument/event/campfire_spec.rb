require 'spec_helper'

describe Travis::Notification::Instrument::Event::Handler::Campfire do
  include Travis::Testing::Stubs

  let(:build)     { stub_build(:config => { :notifications => { :campfire => 'campfire_room' } }) }
  let(:handler)   { Travis::Event::Handler::Campfire.new('build:finished', build) }
  let(:publisher) { Travis::Notification::Publisher::Memory.new }
  let(:event)     { publisher.events[1] }

  before :each do
    Travis::Notification.publishers.replace([publisher])
    handler.stubs(:handle)
    handler.notify
  end

  it 'publishes a payload' do
    event.except(:payload).should == {
      :message => "travis.event.handler.campfire.notify:completed",
      :uuid => Travis.uuid
    }
    event[:payload].except(:payload).should == {
      :event => 'build:finished',
      :targets => ['campfire_room'],
      :msg => 'Travis::Event::Handler::Campfire#notify(build:finished) for #<Build id=1>',
      :repository => 'svenfuchs/minimal',
      :request_id => 1,
      :object_id => 1,
      :object_type => 'Build'
    }
    event[:payload][:payload].should_not be_nil
  end
end
