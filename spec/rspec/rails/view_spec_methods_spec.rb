require "spec_helper"

module RSpec::Rails
  describe ViewSpecMethods do
    before do
      class ::VCSampleClass; end
    end

    after do
      Object.send(:remove_const, :VCSampleClass)
    end

    describe ".add_extra_params_accessors_to" do
      describe "when accessors are not yet defined" do
        it "adds them as instance methods" do
          ViewSpecMethods.add_to(VCSampleClass)

          expect(VCSampleClass.instance_methods).to include(:extra_params=)
          expect(VCSampleClass.instance_methods).to include(:extra_params)
        end
      end

      describe "when accessors are already defined" do
        before do
          class ::VCSampleClass
            def extra_params; end

            def extra_params=; end
          end
        end

        it "redefines them" do
          silence_warnings { ViewSpecMethods.add_to(VCSampleClass) }
          expect(VCSampleClass.new.extra_params).to eq({})
        end
      end
    end

    describe ".remove_extra_params_accessors_from" do
      describe "when accessors are defined" do
        before do
          ViewSpecMethods.add_to(VCSampleClass)
        end

        it "removes them" do
          ViewSpecMethods.remove_from(VCSampleClass)

          expect(VCSampleClass.instance_methods).to_not include(:extra_params=)
          expect(VCSampleClass.instance_methods).to_not include(:extra_params)
        end
      end

      describe "when accessors are not defined" do
        it "does nothing" do
          expect {
            ViewSpecMethods.remove_from(VCSampleClass)
          }.to_not change { VCSampleClass.instance_methods }
        end
      end
    end
  end
end
