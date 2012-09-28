require 'rubygems'
require 'bundler'
require 'flt'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'ext'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'ieee-fpu'

class Test::Unit::TestCase
end


def test_operation(description, parameters)

  cons = lambda{|x| Float(x)}
  result = IEEE_FPU.scope(parameters){yield(cons)}

  binnum_parameters = {
      :rounding => {
        :even=>:half_even,
        :down=>:floor,
        :up=>:ceiling,
        :zero=>:down
      }[parameters[:rounding]],
      :precision => {
        :single=>24,
        :double=>53,
        :extended=>64
      }[parameters[:rounding]]
  }

  cons = Flt::BinNum
  base_context = Flt::BinNum::FloatContext
  reference = Flt::BinNum.context(base_context, binnum_parameters){yield(cons)}.to_f

  assert_equal reference, result, description

end
