class ManagedIntervalArray


  def initialize
    @objects = [nil]
    @bounds = [0]
  end

  def add object, count=1
    raise ArgumentError if count<1
    @objects.push object
    @bounds.push size+count

    if @objects.size==2 then
      @objects[0] = @objects[1]
    end
  end

  def [] num
    idx = find_index(num)
    idx && @objects[idx]
  end

  def size
    @bounds.last
  end

  def countOf num
    idx = find_index(num)
    countOfAt(idx)
  end

  def delete num
    index = find_index num
    raise ArgumentError unless index

    moveBounds(index, -1)
    new_count = countOfAt(index)
    if new_count == 0 then
      @objects[index].send :delete!
      @objects.delete_at index
      @bounds.delete_at index
    else
      @objects[index].send :setCount, new_count
    end
  end

  def moveBounds start, diff
    (start...@bounds.size).each { |i| @bounds[i]+=diff }
  end

  def insert num, count =1
    if num >= size then
      return appendItemAtEnd(num,count)
    end

    index = find_index num
    raise ArgumentError unless index

    start = @bounds[index-1]
    if start < num then
      splitObject(index,num)
      index+=1
    end

    raise RuntimeError if index<1
    new_item = @objects[index-1].send :duplicate

    if index==1 then # if insert at beginning we have to swap 
      @objects.insert(index+1, new_item)
      new_item = @objects[1]
    else
      @objects.insert(index, new_item)
    end
    new_item.send :setCount, count


    @bounds.insert(index, num)
    moveBounds(index, count)

    return new_item
  end

  def appendItemAtEnd position, count
    if position > size then
      new_item = @objects.last.send :duplicate
      new_item.send :setCount, position-size
      add new_item, position-size
    end

    new_item = @objects.last.send :duplicate
    new_item.send :setCount, count
    add new_item, count
    return new_item
  end


  def splitObject index, num
    start = @bounds[index-1]
    len = countOfAt(index)
    split = num-start

    raise ArgumentError if start==num

    new_item = @objects[index].send :duplicate
    @objects.insert(index+1, new_item)

    @objects[index].send :setCount, split
    @objects[index+1].send :setCount, len-split

    @bounds.insert index, num
  end  


  def prepareForChange num
    if num >= size then
      return appendItemAtEnd(num,1)
    end

    index = find_index num
    raise IndexError unless index

    len = countOfAt(index)
    return @objects[index]  if len==1

    new_item = insert(num)
    delete(num+1)

    return new_item
  end

#############

  def countOfAt index
    @bounds[index] - @bounds[index-1]
  end

  # Ruby v < 2.0 didn't have bsearch. so we do it in pure ruby
  def find_index num
    return if num > size

    low = 1
    high = @bounds.count

    while low!=high do
      mid = (low+high)/2
      if @bounds[mid] <= num then
        low = mid+1
      else
        high = mid
      end
    end

    low
  end

  private :countOfAt, :moveBounds, :appendItemAtEnd, :find_index, :splitObject

end

