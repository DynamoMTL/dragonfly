require 'spec_helper'

# Matchers
RSpec::Matchers.define :match_steps do |steps|
  match do |given|
    given.map{|step| step.class } == steps
  end
end

describe Dragonfly::Job do

  describe "Step types" do

    {
      Dragonfly::Job::Fetch => :fetch,
      Dragonfly::Job::Process => :process,
      Dragonfly::Job::Encode => :encode,
      Dragonfly::Job::Generate => :generate,
      Dragonfly::Job::FetchFile => :fetch_file,
      Dragonfly::Job::FetchUrl => :fetch_url
    }.each do |klass, step_name|
      it "should return the correct step name for #{klass}" do
        klass.step_name.should == step_name
      end
    end

    {
      Dragonfly::Job::Fetch => :f,
      Dragonfly::Job::Process => :p,
      Dragonfly::Job::Encode => :e,
      Dragonfly::Job::Generate => :g,
      Dragonfly::Job::FetchFile => :ff,
      Dragonfly::Job::FetchUrl => :fu
    }.each do |klass, abbreviation|
      it "should return the correct abbreviation for #{klass}" do
        klass.abbreviation.should == abbreviation
      end
    end

    describe "step_names" do
      it "should return the available step names" do
        Dragonfly::Job.step_names.should == [:fetch, :process, :encode, :generate, :fetch_file, :fetch_url]
      end
    end

  end

  describe "without temp_object" do

    before(:each) do
      @app = mock_app
      @job = Dragonfly::Job.new(@app)
    end

    it "should allow initializing with content" do
      job = Dragonfly::Job.new(@app, Dragonfly::TempObject.new('eggheads'))
      job.data.should == 'eggheads'
    end

    describe "fetch" do
      before(:each) do
        @job.fetch!('some_uid')
      end

      it { @job.steps.should match_steps([Dragonfly::Job::Fetch]) }

      it "should retrieve from the app's datastore when applied" do
        @app.datastore.should_receive(:retrieve).with('some_uid').and_return('HELLO')
        @job.data.should == 'HELLO'
      end

      it "should set extra data if returned from the datastore" do
        @app.datastore.should_receive(:retrieve).with('some_uid').and_return(['HELLO', {:name => 'test.txt', :meta => {1=>2}}])
        @job.data.should == 'HELLO'
        @job.name.should == 'test.txt'
        @job.meta.should == {1 => 2}
      end
    end

    describe "process" do
      it "should raise an error when applying" do
        @job.process!(:resize, '20x30')
        lambda{
          @job.apply
        }.should raise_error(Dragonfly::Job::NothingToProcess)
      end
    end

    describe "encode" do
      it "should raise an error when applying" do
        @job.encode!(:gif)
        lambda{
          @job.apply
        }.should raise_error(Dragonfly::Job::NothingToEncode)
      end
    end

    describe "analyse" do
      it "should raise an error" do
        lambda{
          @job.analyse(:width)
        }.should raise_error(Dragonfly::Job::NothingToAnalyse)
      end
    end

    describe "generate" do
      before(:each) do
        @job.generate!(:plasma, 20, 30)
      end

      it { @job.steps.should match_steps([Dragonfly::Job::Generate]) }

      it "should use the generator when applied" do
        @app.generator.should_receive(:generate).with(:plasma, 20, 30).and_return('hi')
        @job.data.should == 'hi'
      end

      it "should save extra data if the generator returns it" do
        @app.generator.should_receive(:generate).with(:plasma, 20, 30).and_return(['hi', {:name => 'plasma.png', :format => :png, :meta => {:a => :b}}])
        @job.data.should == 'hi'
        @job.name.should == 'plasma.png'
        @job.format.should == :png
        @job.meta.should == {:a => :b}
      end
    end

    describe "fetch_file" do
      before(:each) do
        @job.fetch_file!(File.dirname(__FILE__) + '/../../samples/egg.png')
      end

      it { @job.steps.should match_steps([Dragonfly::Job::FetchFile]) }

      it "should fetch the specified file when applied" do
        @job.size.should == 62664
      end

    end

    describe "fetch_url" do
      before(:each) do
        stub_request(:get, 'http://some.place.com').to_return(:body => 'result!')
        stub_request(:get, 'https://some.place.com').to_return(:body => 'secure result!')
      end

      it {
        @job.fetch_url!('some.url')
        @job.steps.should match_steps([Dragonfly::Job::FetchUrl])
      }

      it "should fetch the specified url when applied" do
        @job.fetch_url!('http://some.place.com')
        @job.data.should == "result!"
      end

      it "should default to http" do
        @job.fetch_url!('some.place.com')
        @job.data.should == "result!"
      end

      it "should also work with https" do
        @job.fetch_url!('https://some.place.com')
        @job.data.should == "secure result!"
      end

    end

  end

  describe "with temp_object already there" do

    before(:each) do
      @app = mock_app
      @temp_object = Dragonfly::TempObject.new('HELLO')
      @job = Dragonfly::Job.new(@app, @temp_object, :name => 'hello.txt', :meta => {:a => :b}, :format => :txt)
    end

    describe "apply" do
      it "should return itself" do
        @job.apply.should == @job
      end
    end

    describe "process" do
      before(:each) do
        @job.process!(:resize, '20x30')
      end

      it { @job.steps.should match_steps([Dragonfly::Job::Process]) }

      it "should use the processor when applied" do
        @app.processor.should_receive(:process).with(@temp_object, :resize, '20x30').and_return('hi')
        @job.data.should == 'hi'
      end

      it "should maintain the meta attributes" do
        @app.processor.should_receive(:process).with(@temp_object, :resize, '20x30').and_return('hi')
        @job.data.should == 'hi'
        @job.name.should == 'hello.txt'
        @job.meta.should == {:a => :b}
        @job.format.should == :txt
      end

      it "should allow returning an array with extra attributes from the processor" do
        @app.processor.should_receive(:process).with(@temp_object, :resize, '20x30').and_return(['hi', {:name => 'hello_20x30.txt', :meta => {:eggs => 'asdf'}}])
        @job.data.should == 'hi'
        @job.name.should == 'hello_20x30.txt'
        @job.meta.should == {:a => :b, :eggs => 'asdf'}
        @job.format.should == :txt
      end
    end

    describe "encode" do
      before(:each) do
        @job.encode!(:gif, :bitrate => 'mumma')
      end

      it { @job.steps.should match_steps([Dragonfly::Job::Encode]) }

      it "should use the encoder when applied" do
        @app.encoder.should_receive(:encode).with(@temp_object, :gif, :bitrate => 'mumma').and_return('alo')
        @job.data.should == 'alo'
      end

      it "should maintain the temp object attributes (except format)" do
        @app.encoder.should_receive(:encode).with(@temp_object, :gif, :bitrate => 'mumma').and_return('alo')
        @job.data.should == 'alo'
        @job.name.should == 'hello.txt'
        @job.meta.should == {:a => :b}
      end

      it "should update the format" do
        @app.encoder.should_receive(:encode).with(@temp_object, :gif, :bitrate => 'mumma').and_return('alo')
        @job.apply.format.should == :gif
      end

      it "should update the format even when not applied" do
        @app.encoder.should_not_receive(:encode)
        @job.format.should == :gif
      end

      it "should allow returning an array with extra attributes form the encoder" do
        @app.encoder.should_receive(:encode).with(@temp_object, :gif, :bitrate => 'mumma').and_return(['alo', {:name => 'doobie', :meta => {:eggs => 'fish'}}])
        @job.data.should == 'alo'
        @job.name.should == 'doobie'
        @job.meta.should == {:a => :b, :eggs => 'fish'}
      end

      it "not allow overriding the format" do
        @app.encoder.should_receive(:encode).with(@temp_object, :gif, :bitrate => 'mumma').and_return(['alo', {:format => :png}])
        @job.apply.format.should == :gif
      end
    end
  end

  describe "analysis" do
    before(:each) do
      @app = test_app
      @job = @app.new_job('HELLO')
      @app.analyser.add(:num_letters){|temp_object, letter| temp_object.data.count(letter) }
    end
    it "should return correctly when calling analyse" do
      @job.analyse(:num_letters, 'L').should == 2
    end
    it "should have mixed in the analyser method" do
      @job.num_letters('L').should == 2
    end
    it "should return nil from analyse if calling any old method" do
      @job.analyse(:robin_van_persie).should be_nil
    end
    it "should not allow calling any old method" do
      lambda{
        @job.robin_van_persie
      }.should raise_error(NoMethodError)
    end
    it "should work correctly with chained jobs, applying before analysing" do
      @app.processor.add(:double){|temp_object| temp_object.data * 2 }
      @job.process(:double).num_letters('L').should == 4
    end
  end

  describe "defining extra steps after applying" do
    before(:each) do
      @app = mock_app
      @job = Dragonfly::Job.new(@app)
      @job.temp_object = Dragonfly::TempObject.new("hello")
      @job.process! :resize
      @job.apply
      @job.encode! :micky
    end
    it "should not call apply on already applied steps" do
      @job.steps[0].should_not_receive(:apply)
      @job.apply
    end
    it "should call apply on not yet applied steps" do
      @job.steps[1].should_receive(:apply)
      @job.apply
    end
    it "should return all steps" do
      @job.steps.should match_steps([
        Dragonfly::Job::Process,
        Dragonfly::Job::Encode
      ])
    end
    it "should return applied steps" do
      @job.applied_steps.should match_steps([
        Dragonfly::Job::Process
      ])
    end
    it "should return the pending steps" do
      @job.pending_steps.should match_steps([
        Dragonfly::Job::Encode
      ])
    end
    it "should not call apply on any steps when already applied" do
      @job.apply
      @job.steps[0].should_not_receive(:apply)
      @job.steps[1].should_not_receive(:apply)
      @job.apply
    end
  end

  describe "chaining" do

    before(:each) do
      @app = mock_app
      @job = Dragonfly::Job.new(@app)
    end

    it "should return itself if bang is used" do
      @job.fetch!('some_uid').should == @job
    end

    it "should return a new job if bang is not used" do
      @job.fetch('some_uid').should_not == @job
    end

    describe "when a chained job is defined" do
      before(:each) do
        @job.fetch!('some_uid')
        @job2 = @job.process(:resize, '30x30')
      end

      it "should return the correct steps for the original job" do
        @job.applied_steps.should match_steps([
        ])
        @job.pending_steps.should match_steps([
          Dragonfly::Job::Fetch
        ])
      end

      it "should return the correct data for the original job" do
        @job.data.should == 'SOME_DATA'
      end

      it "should return the correct steps for the new job" do
        @job2.applied_steps.should match_steps([
        ])
        @job2.pending_steps.should match_steps([
          Dragonfly::Job::Fetch,
          Dragonfly::Job::Process
        ])
      end

      it "should return the correct data for the new job" do
        @job2.data.should == 'SOME_PROCESSED_DATA'
      end

      it "should not affect the other one when one is applied" do
        @job.apply
        @job.applied_steps.should match_steps([
          Dragonfly::Job::Fetch
        ])
        @job.pending_steps.should match_steps([
        ])
        @job.temp_object.data.should == 'SOME_DATA'
        @job2.applied_steps.should match_steps([
        ])
        @job2.pending_steps.should match_steps([
          Dragonfly::Job::Fetch,
          Dragonfly::Job::Process
        ])
        @job2.temp_object.should be_nil
      end
    end

  end

  describe "to_a" do
    before(:each) do
      @app = mock_app
    end
    it "should represent all the steps in array form" do
      job = Dragonfly::Job.new(@app)
      job.fetch! 'some_uid'
      job.generate! :plasma # you wouldn't really call this after fetch but still works
      job.process! :resize, '30x40'
      job.encode! :gif, :bitrate => 20
      job.to_a.should == [
        [:f, 'some_uid'],
        [:g, :plasma],
        [:p, :resize, '30x40'],
        [:e, :gif, {:bitrate => 20}]
      ]
    end
  end

  describe "from_a" do

    before(:each) do
      @app = test_app
    end

    describe "a well-defined array" do
      before(:each) do
        @job = Dragonfly::Job.from_a([
          [:f, 'some_uid'],
          [:g, :plasma],
          [:p, :resize, '30x40'],
          [:e, :gif, {:bitrate => 20}]
        ], @app)
      end
      it "should have the correct step types" do
        @job.steps.should match_steps([
          Dragonfly::Job::Fetch,
          Dragonfly::Job::Generate,
          Dragonfly::Job::Process,
          Dragonfly::Job::Encode
        ])
      end
      it "should have the correct args" do
        @job.steps[0].args.should == ['some_uid']
        @job.steps[1].args.should == [:plasma]
        @job.steps[2].args.should == [:resize, '30x40']
        @job.steps[3].args.should == [:gif, {:bitrate => 20}]
      end
      it "should have no applied steps" do
        @job.applied_steps.should be_empty
      end
      it "should have all steps pending" do
        @job.steps.should == @job.pending_steps
      end
    end

    [
      :f,
      [:f],
      [[]],
      [[:egg]]
    ].each do |object|
      it "should raise an error if the object passed in is #{object.inspect}" do
        lambda {
          Dragonfly::Job.from_a(object, @app)
        }.should raise_error(Dragonfly::Job::InvalidArray)
      end
    end

    it "should initialize an empty job if the array is empty" do
      job = Dragonfly::Job.from_a([], @app)
      job.steps.should be_empty
    end
  end

  describe "serialization" do
    before(:each) do
      @app = test_app
      @job = Dragonfly::Job.new(@app).fetch('uid').process(:resize_and_crop, :width => 270, :height => 92, :gravity => 'n')
    end
    it "should serialize itself" do
      @job.serialize.should =~ /^\w{1,}$/
    end
    it "should deserialize to the same as the original" do
      new_job = Dragonfly::Job.deserialize(@job.serialize, @app)
      new_job.to_a.should == @job.to_a
    end
    it "should correctly deserialize a string serialized with ruby 1.8.7" do
      job = Dragonfly::Job.deserialize('BAhbB1sHOgZmSSIIdWlkBjoGRVRbCDoGcDoUcmVzaXplX2FuZF9jcm9wewg6CndpZHRoaQIOAToLaGVpZ2h0aWE6DGdyYXZpdHlJIgZuBjsGVA', @app)
      job.to_a.should == @job.to_a
    end
    it "should correctly deserialize a string serialized with ruby 1.9.2" do
      job = Dragonfly::Job.deserialize('BAhbB1sHOgZmIgh1aWRbCDoGcDoUcmVzaXplX2FuZF9jcm9wewg6CndpZHRoaQIOAToLaGVpZ2h0aWE6DGdyYXZpdHkiBm4', @app)
      job.to_a.should == @job.to_a
    end
  end

  describe "to_app" do
    before(:each) do
      @app = test_app
      @job = Dragonfly::Job.new(@app)
    end
    it "should return an endpoint" do
      endpoint = @job.to_app
      endpoint.should be_a(Dragonfly::JobEndpoint)
      endpoint.job.should == @job
    end
  end

  describe "url" do
    before(:each) do
      @app = mock_app(:url_for => 'hello')
      @job = Dragonfly::Job.new(@app)
    end
    it "should return a url" do
      @job.generate!(:plasma)
      @job.url.should == 'hello'
    end
    it "should return nil if there are no steps" do
      @job.url.should be_nil
    end
  end

  describe "to_fetched_job" do
    it "should maintain the same temp_object and be already applied" do
      app = mock_app
      job = Dragonfly::Job.new(app, Dragonfly::TempObject.new("HELLO"))
      new_job = job.to_fetched_job('some_uid')
      new_job.data.should == 'HELLO'
      new_job.to_a.should == [
        [:f, 'some_uid']
      ]
      new_job.pending_steps.should be_empty
    end
  end

  describe "to_unique_s" do
    it "should use the arrays of args to create the string" do
      job = test_app.fetch('uid').process(:gug, 4, :some => 'arg', :and => 'more')
      job.to_unique_s.should == 'fuidpgug4andmoresomearg'
    end
  end

  describe "sha" do
    before(:each) do
      @app = test_app
      @job = @app.fetch('eggs')
    end
    
    it "should be of the correct format" do
      @job.sha.should =~ /^\w{8}$/
    end
    
    it "should be the same for the same job steps" do
      @app.fetch('eggs').sha.should == @job.sha
    end
    
    it "should be different for different jobs" do
      @app.fetch('figs').sha.should_not == @job.sha
    end
  end

  describe "validate_sha!" do
    before(:each) do
      @app = test_app
      @job = @app.fetch('eggs')
    end
    it "should raise an error if nothing is given" do
      lambda{
        @job.validate_sha!(nil)
      }.should raise_error(Dragonfly::Job::NoSHAGiven)
    end
    it "should raise an error if the wrong SHA is given" do
      lambda{
        @job.validate_sha!('asdf')
      }.should raise_error(Dragonfly::Job::IncorrectSHA)
    end
    it "should return self if ok" do
      @job.validate_sha!(@job.sha).should == @job
    end
  end

  describe "setting the name" do
    before(:each) do
      @app = test_app
      @job = @app.new_job("HELLO", :name => 'not.me')
    end
    it "should allow setting the name" do
      @job.name = 'wassup.doc'
      @job.name.should == 'wassup.doc'
    end
  end

  describe "setting the meta" do
    before(:each) do
      @app = test_app
      @job = @app.new_job("HiThere", :meta => {:five => 'beans'})
    end
    it "should allow setting the meta" do
      @job.meta = {:doogie => 'ladders'}
      @job.meta.should == {:doogie => 'ladders'}
    end
    it "should allow updating the meta" do
      @job.meta[:doogie] = 'ladders'
      @job.meta.should == {:five => 'beans', :doogie => 'ladders'}
    end
  end

  describe "b64_data" do
    before(:each) do
      @app = test_app
    end
    it "should return a string using the data:URI schema" do
      job = @app.new_job("HELLO", :name => 'text.txt')
      job.b64_data.should == "data:text/plain;base64,SEVMTE8=\n"
    end
  end

  describe "querying stuff without applying steps" do
    before(:each) do
      @app = test_app
    end
    
    describe "fetch_step" do
      it "should return nil if it doesn't exist" do
        @app.generate(:ponies).process(:jam).fetch_step.should be_nil
      end
      it "should return the fetch step otherwise" do
        step = @app.fetch('hello').process(:cheese).fetch_step
        step.should be_a(Dragonfly::Job::Fetch)
        step.uid.should == 'hello'
      end
    end
    describe "fetched uid" do
      describe "when there's no fetch step" do
        before(:each) do
          @job = @app.new_job("AGG")
        end
        it "should return nil for uid" do
          @job.uid.should be_nil
        end
        it "should return nil for uid_basename" do
          @job.uid_basename.should be_nil
        end
        it "should return nil for uid_extname" do
          @job.uid_extname.should be_nil
        end
      end
      describe "when there is a fetch step" do
        before(:each) do
          @job = @app.fetch('gungedin/innit.blud')
        end
        it "should return the uid" do
          @job.uid.should == 'gungedin/innit.blud'
        end
        it "should return the uid_basename" do
          @job.uid_basename.should == 'innit'
        end
        it "should return the uid_extname" do
          @job.uid_extname.should == '.blud'
        end
      end
    end

    describe "fetch_file_step" do
      it "should return nil if it doesn't exist" do
        @app.generate(:ponies).process(:jam).fetch_file_step.should be_nil
      end
      it "should return the fetch_file step otherwise" do
        step = @app.fetch_file('/my/file.png').process(:cheese).fetch_file_step
        step.should be_a(Dragonfly::Job::FetchFile)
        step.path.should == '/my/file.png'
      end
    end

    describe "fetch_url_step" do
      it "should return nil if it doesn't exist" do
        @app.generate(:ponies).fetch_url_step.should be_nil
      end
      it "should return the fetch_url step otherwise" do
        step = @app.fetch_url('egg.heads').process(:cheese).fetch_url_step
        step.should be_a(Dragonfly::Job::FetchUrl)
        step.url.should == 'http://egg.heads'
      end
    end

    describe "generate_step" do
      it "should return nil if it doesn't exist" do
        @app.fetch('many/ponies').process(:jam).generate_step.should be_nil
      end
      it "should return the generate step otherwise" do
        step = @app.generate(:ponies).process(:cheese).generate_step
        step.should be_a(Dragonfly::Job::Generate)
        step.args.should == [:ponies]
      end
    end
    
    describe "process_steps" do
      it "should return the processing steps" do
        job = @app.fetch('many/ponies').process(:jam).process(:eggs).encode(:gif)
        job.process_steps.should match_steps([
          Dragonfly::Job::Process,
          Dragonfly::Job::Process
        ])
      end
    end

    describe "encode_step" do
      it "should return nil if it doesn't exist" do
        @app.generate(:ponies).encode_step.should be_nil
      end
      it "should return the last encode step otherwise" do
        step = @app.fetch('hello').encode(:smells).encode(:cheese).encode_step
        step.should be_a(Dragonfly::Job::Encode)
        step.format.should == :cheese
      end
    end
    describe "encoded_format" do
      it "should return nil if there's no encode step" do
        @app.new_job('asdf').encoded_format.should be_nil
      end
      it "should return the last encoded format if it exists" do
        @app.fetch('gungedin').encode(:a).encode(:b).encoded_format.should == :b
      end
    end
    describe "encoded_extname" do
      it "should return nil if there's no encode step" do
        @app.new_job('asdf').encoded_extname.should be_nil
      end
      it "should return the last encoded format as an extname if it exists" do
        @app.fetch('gungedin').encode(:a).encode(:b).encoded_extname.should == '.b'
      end
    end
  end

  describe "name" do
    before(:each) do
      @app = test_app
    end
    it "should default to nil" do
      job = @app.new_job('HELLO')
      job.name.should be_nil
    end
    it "should set allow setting on initialize" do
      job = @app.new_job('HELLO', :name => 'monkey.egg')
      job.name.should == 'monkey.egg'
    end
    it "should allow setting" do
      job = @app.new_job('HELLO')
      job.name = "jonny.briggs"
      job.name.should == 'jonny.briggs'
    end
    
    describe "ext" do
      before(:each) do
        @job = @app.new_job('asdf')
      end
      it "should use the correct extension from name" do
        @job.name = 'hello.there.mate'
        @job.ext.should == 'mate'
      end
      it "should be nil if name has none" do
        @job.name = 'hello'
        @job.ext.should be_nil
      end
      it "should be nil if name is nil" do
        @job.name = nil
        @job.ext.should be_nil
      end
    end

    describe "basename" do
      before(:each) do
        @job = @app.new_job('asdf')
      end
      it "should use the correct basename from name" do
        @job.name = 'hello.there.mate'
        @job.basename.should == 'hello.there'
      end
      it "should be the name if it has no ext" do
        @job.name = 'hello'
        @job.basename.should == 'hello'
      end
      it "should be nil if name is nil" do
        @job.name = nil
        @job.basename.should be_nil
      end
    end
  end

  describe "meta" do
    before(:each) do
      @app = test_app
      @job = @app.new_job
    end
    it "should default meta to an empty hash" do
      @job.meta.should == {}
    end
    it "should allow setting" do
      @job.meta = {:a => :b}
      @job.meta.should == {:a => :b}
    end
    it "should not allow setting as anything other than a hash" do
      lambda{
        @job.meta = 3
      }.should raise_error(ArgumentError)
    end
    it "should allow setting on initialize" do
      job = @app.new_job('asdf', :meta => {:b => :c})
      job.meta.should == {:b => :c}
    end
    it "should not allow setting as anything other than a hash on initialize" do
      lambda{
        @app.new_job('asdf', :meta => 'eggs')
      }.should raise_error(ArgumentError)
    end
  end

  describe "format" do
    before(:each) do
      @app = test_app
    end
    it "should default to nil" do
      job = @app.new_job("HELLO")
      job.format.should be_nil
    end
    it "should use the initialized format if it exists" do
      job = @app.new_job("HELLO", :format => :txt)
      job.format.should == :txt
    end
    it "should allow setting the format" do
      job = @app.new_job("HELLO")
      job.format = :txt
      job.format.should == :txt
    end
    it "should use the analyser format if it exists" do
      @app.analyser.add :format do |temp_object|
        :egg
      end
      job = @app.new_job("HELLO")
      job.format.should == :egg
    end
    it "should prefer the set format if both exist" do
      @app.analyser.add :format do |temp_object|
        :egg
      end
      job = @app.new_job("HELLO", :format => :txt)
      job.format.should == :txt
    end
  end

  describe "update_attributes" do
    before(:each) do
      @app = test_app
      @job = @app.new_job('asdf',
        :name => 'dog.leg',
        :format => :txt,
        :meta => {:tub => :monkey, :door => :soldier}
      )
    end
    it "should set the name" do
      @job.update_attributes(:name => 'egg.nog')
      @job.name.should == 'egg.nog'
      @job.format.should == :txt
      @job.meta.should == {:tub => :monkey, :door => :soldier}
    end
    it "should set the format" do
      @job.update_attributes(:format => :dub)
      @job.name.should == 'dog.leg'
      @job.format.should == :dub
      @job.meta.should == {:tub => :monkey, :door => :soldier}
    end
    it "should merge the meta" do
      @job.update_attributes(:meta => {:dub => :door, :tub => :head})
      @job.name.should == 'dog.leg'
      @job.format.should == :txt
      @job.meta.should == {:tub => :head, :door => :soldier, :dub => :door}
    end
  end

  describe "mime_type" do
    before(:each) do
      @app = test_app
      @app.analyser.add :format do |temp_object|
        :png
      end
      @app.analyser.add :mime_type do |temp_object|
        'image/jpeg'
      end
      @app.encoder.add do |temp_object|
        'ENCODED DATA YO'
      end
    end

    it "should return the correct mime_type if the format is given" do
      @job = @app.new_job("HIMATE", :format => :tiff, :name => 'test.pdf')
      @job.mime_type.should == 'image/tiff'
    end

    it "should use the file extension if it has no format" do
      @job = @app.new_job("HIMATE", :name => 'test.pdf')
      @job.mime_type.should == 'application/pdf'
    end

    it "should not use the file extension if it's been switched off (fall back to mime_type analyser)" do
      @app.infer_mime_type_from_file_ext = false
      @job = @app.new_job("HIMATE", :name => 'test.pdf')
      @job.mime_type.should == 'image/jpeg'
    end

    it "should fall back to the mime_type analyser if the temp_object has no ext" do
      @job = @app.new_job("HIMATE", :name => 'test')
      @job.mime_type.should == 'image/jpeg'
    end

    describe "when the temp_object has no name" do

      before(:each) do
        @job = @app.new_job("HIMATE")
      end

      it "should fall back to the mime_type analyser" do
        @job.mime_type.should == 'image/jpeg'
      end

      it "should fall back to the format analyser if the mime_type analyser doesn't exist" do
        @app.analyser.functions.delete(:mime_type)
        @job.mime_type.should == 'image/png'
      end

      it "should fall back to the app's fallback mime_type if no mime_type/format analyser exists" do
        @app.analyser.functions.delete(:mime_type)
        @app.analyser.functions.delete(:format)
        @job.mime_type.should == 'application/octet-stream'
      end

    end

  end

end
