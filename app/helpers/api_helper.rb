module ApiHelper 
def self.int?(str)
  (str =~ /\A\d+\Z/) != nil
end

def self.as_int(str)
  return str.to_i if int?(str)
  str
end
end
