class ManagedIntervalArray

# TODO: insert dummy element (referenz to element 1) at 0; this will eliminate many index>0 conditions

  def initialize
    @objects = []
    @bounds = []
  end

  def add object, count=1
    raise ArgumentError if count<1
    @objects.push object
    @bounds.push size+count
  end

  def [] index
    idx = find_index(index)
    idx && @objects[idx]
  end

  def size
    @bounds.last || 0
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
      @objects[index].delete!
      @objects.delete_at index
      @bounds.delete_at index
    else
      @objects[index].setCount(new_count)
    end
  end

  def moveBounds start, diff
    (start...@bounds.size).each { |i| @bounds[i]+=diff }
  end


  def insert num, count =1
    if num >= size then
      return appendItemAtEnd(num,count)
    end

    if num==0 then
      return insertItemAtBegining(count)
    end

    index = find_index num
    raise ArgumentError unless index

    start = startOfAt(index)
    if start < num then
      splitObject(index,num)
      index+=1
    end

    raise RuntimeError if index<1
    new_item = @objects[index-1].duplicate
    new_item.setCount(count)
    @objects.insert(index, new_item)

    @bounds.insert(index, num)
    moveBounds(index, count)

    return new_item
  end

  def appendItemAtEnd position, count
    if position > size then
      new_item = @objects.last.duplicate
      new_item.setCount position-size
      add new_item, position-size
    end

    new_item = @objects.last.duplicate
    new_item.setCount count
    add new_item, count
    return new_item
  end

  def insertItemAtBegining count
    new_item = @objects.first.duplicate
    @objects.insert(1, new_item)
    @objects.first.setCount(count)

    @bounds.insert(0, 0)
    moveBounds(0, count)
    return @objects.first
  end

  def splitObject index, num
    start = startOfAt(index)
    len = countOfAt(index)
    split = num-start

    raise ArgumentError if start==num

    new_item = @objects[index].duplicate
    @objects.insert(index+1, new_item)

    @objects[index].setCount(split)
    @objects[index+1].setCount(len-split)

    @bounds.insert index, num
  end  


#############

  def countOfAt index
    return @bounds[0] if index==0
    @bounds[index] - @bounds[index-1]
  end

  def startOfAt index
    index > 0 ? @bounds[index-1] : 0
  end

  # Ruby v < 2.0 didn't have bsearch. so we do it in pure ruby
  def find_index num
    return if num > size

    low = 0
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

  private :countOfAt, :moveBounds, :appendItemAtEnd, :insertItemAtBegining, :find_index, :splitObject

end

