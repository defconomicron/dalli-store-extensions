require "#{File.dirname(__FILE__)}/spec_helper"


describe ActiveSupport::Cache::DalliStore do
  before(:all) do
    @cache = ActiveSupport::Cache.lookup_store(:dalli_store, "localhost:11211")

    @data = { 
      "color1" => "red",
      "color2" => "blue"
    }

    @data.each do |k,v|
      @cache.delete(k)
    end
  end

  it "should write and read value from cache" do
    @data.each do |k,v|
      @cache.write(k,v)
    end

    @data.each do |k,v|
      @cache.fetch(k).should eql(v)
    end
  end

  it "should successfully expire a cache key on a match" do
    @data.each do |k,v|
      @cache.write(k,v)
    end

    @cache.delete_matched(/color.*/)

    @data.each do |k,v|
      @cache.fetch(k).should eql(nil)
    end
  end

  it "should not expire a cache key without a match" do
    @cache.write("permanent", "value")
    @cache.delete_matched(/notpermanent.*/)
    @cache.fetch("permanent").should eql("value") 
  end
end
