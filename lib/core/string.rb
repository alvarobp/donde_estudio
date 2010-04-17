class String
  
  def sanitize
    return if self.empty?
    self.parameterize.to_s
  end
  
end