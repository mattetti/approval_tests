require "#{File.dirname(__FILE__)}/../approvals"

module ApprovalTests
  module Extensions
    module RSpec
      def approve(thing=nil, options={}, backtrace=nil, &implementation)
        if block_given?
          approve_description = "#{thing}" 
        else
          approve_description = nil
          result = thing
        end

        example(approve_description, options) do
          if block_given?    
            result = yield implementation
          end
          ApprovalTests::Approvals.approve(result)
        end
      end
      
      def approve_html(thing=nil, options={}, backtrace=nil, &implementation)
        if block_given?
          approve_description = "#{thing}" 
        else
          approve_description = nil
          result = thing
        end

        example(approve_description, options) do
          if block_given?    
            result = yield implementation
          end
          ApprovalTests::Approvals.approve(result, :html)
        end
      end
    end
  end
end

Spec::Runner.configure do |config|  
  config.before(:each) do
    ApprovalTests::Approvals.namer = RSpecNamer.new()
    extra_description = ""
    extra_description = "_#{self.description}" if !self.description.empty?
    ApprovalTests::Approvals.namer.approval_name = "#{self.class.description}#{extra_description}".gsub("/", "__FORWARD_SLASH__");
    ApprovalTests::Approvals.namer.source_file_path = File.dirname(self.class.spec_path)
  end
  config.extend(ApprovalTests::Extensions::RSpec)
end