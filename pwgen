#!/usr/bin/env ruby
class PwGen
  def initialize(pw_count,pw_size)
    @pw_size = pw_size
    pw_count.times do
      puts generate
    end
  end
  
  def generate
    while (not (validate(pw = gen))); end;
    return pw
  end
  
  def gen
    return Array.new(@pw_size){( (0..9).to_a + 
                                 ('a'..'z').to_a + 
                                 ('A'..'Z').to_a)[(rand(42))]}.join
  end

  def validate(pw)
    if @pw_size > 9
      return (pw.scan(/[A-Z]/).size > 2 &&
        pw.scan(/[0-9]/).size > 2 &&
        pw.scan(/[a-z]/).size > 2)
    else
      true
    end
  end
end


PwGen.new((ARGV[0] || 1).to_i,(ARGV[1] || 10).to_i)

