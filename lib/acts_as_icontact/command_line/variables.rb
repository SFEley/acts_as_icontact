module ActsAsIcontact
  
  # Allows local variables to be set in the command line client.  :nodoc:
  def self.method_missing(method, *params)
    puts "Missing method invoked!"
    @variables ||= {}
    variable = method.to_s
    if variable =~ /(.*)=$/  # It's a variable assignment
      @variables[variable.sub(/=$/,'')] = params[0]
      @variables
    else
      @variables[variable]
    end
  end
  
end
  