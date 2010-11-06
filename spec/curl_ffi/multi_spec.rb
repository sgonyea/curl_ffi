require File.expand_path("../spec_helper", File.dirname(__FILE__))

describe CurlFFI::Multi do
  describe "CurlFFI::Multi.new" do
    it "should return a new CurlFFI::Easy object" do
      CurlFFI::Multi.new.should be_a(CurlFFI::Multi)
    end
  end

  describe "Multi should work" do
    before :each do
      @multi = CurlFFI::Multi.new
      @easy = CurlFFI::Easy.new
      @easy.setopt(CurlFFI::OPTION[:PROXY], "")
    end

    describe "#add_handle" do
      it "should add the easy object to this multi objects handles" do
        @multi.add_handle(@easy)
      end
    end

    describe "#info_read_next" do
      it "should return nil if there are no messages" do
        @multi.info_read_next.should be_nil
      end

      it "should return CurlFFI::Message objects when messages are available" do
        @easy.setopt(CurlFFI::OPTION[:URL], "http://google.de")
        @multi.add_handle(@easy)

        @multi.perform while @multi.running != 0
        message = @multi.info_read_next
        message.should be_a(CurlFFI::Message)
        message[:msg].should == :DONE
      end
    end

    describe "#info_read_all" do
      it "should return an empty array if there are no messages" do
        @multi.info_read_all.should == []
      end

      it "should return an array of CurlFFI::Message objects when messages are available" do
        @easy.setopt(CurlFFI::OPTION[:URL], "http://google.de")
        @multi.add_handle(@easy)

        @multi.perform while @multi.running != 0
        messages = @multi.info_read_all
        messages.size.should == 1

        messages.first.should be_a(CurlFFI::Message)
        messages.first[:msg].should == :DONE
      end
    end

    describe "#timeout" do
      it "should return -1 if there is no timer set yet" do
        @multi.timeout.should == -1
      end

      it "should return the timeout till the next call to #perform" do
        @easy.setopt(CurlFFI::OPTION[:URL], "http://google.de")
        @multi.add_handle(@easy)

        @multi.timeout.should == 1
        @multi.perform
        @multi.timeout.should == 1
      end
    end

    describe "#perform" do
      before :each do
        @easy.setopt(CurlFFI::OPTION[:URL], "http://google.de")
        @multi.add_handle(@easy)
      end

      it "should perform the request"
    end
  end
end