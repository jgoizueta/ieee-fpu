require 'helper'

class TestIeeeFpu < Test::Unit::TestCase

  should "round correctly for each precision supported" do

    IEEE_FPU.supported_precisions.each do |precision|
      [:up, :down, :zero, :even].each do |rounding|
        parameters = {
            :rounding => rounding,
            :precision => precision
        }

        test_operation("#{precision} #{rounding} : (2000.0/60)*60/1000 - 2", parameters) do |num|
          (num[2000]/60)*num[60]/1000 - num[2]
        end

        test_operation("#{precision} #{rounding} : 1.0+Float::EPSILON/2", parameters) do |num|
          num[1] + num[Float::EPSILON/2]
        end

        test_operation("#{precision} #{rounding} : 1.0-Float::EPSILON/4", parameters) do |num|
          num[1] - num[Float::EPSILON/4]
        end

        test_operation("#{precision} #{rounding} : -1.0-Float::EPSILON/2", parameters) do |num|
          num[-1] - num[Float::EPSILON/2]
        end

        test_operation("#{precision} #{rounding} : -1.0+Float::EPSILON/4", parameters) do |num|
          num[-1] + num[Float::EPSILON/4]
        end

        test_operation("#{precision} #{rounding} : 10/9.0-1.0-1/9.0", parameters) do |num|
          num[10]/num[9]-num[1]-num[1]/num[9]
        end

        test_operation("#{precision} #{rounding} : -10/9.0+1.0+1/9.0", parameters) do |num|
          num[-10]/num[9]+num[1]+num[1]/num[9]
        end

        test_operation("#{precision} #{rounding} : 1-(4.0/3-1)*3", parameters) do |num|
          num[1] - (num[4]/num[3]-num[1])*num[3]
        end

        test_operation("#{precision} #{rounding} : (4.0/3-1)*3 - 1", parameters) do |num|
          (num[4]/num[3]-num[1])*num[3] - num[1]
        end

      end

    end

  end
end
