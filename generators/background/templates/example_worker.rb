class ExampleWorker
  
  def add(a, b)
    a + b
  end
  
  def long
    @progress = 0
    while(@progress < 100)
      @progress += 1
      sleep 1
    end
  end

end
