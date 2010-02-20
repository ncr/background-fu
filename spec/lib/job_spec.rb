require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Job do 
  #TODO DRY this up. Can't get the shoulda macros working
  specify { subject.should validate_presence_of :worker_class }
  specify { subject.should validate_presence_of :worker_method }
  specify { subject.should have_readonly_attribute :worker_class }
  specify { subject.should have_readonly_attribute :worker_method }
  specify { subject.should have_readonly_attribute :args }
end
