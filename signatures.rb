class Signatures < Array
  def init_defaults
    self << {:part => :patch, :content => /password/}
  end

  def check(file)
    hits = []
    self.each do |matcher|
      hits << matcher if file[matcher[:part]] =~ matcher[:content]
    end
    hits
  end
end