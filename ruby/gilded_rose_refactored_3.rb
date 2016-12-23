class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      ItemUpdate.new(item).update
    end
  end
end

class ItemUpdate
  def initialize(item)
    @item = item
    @name = item.name
    @quality = item.quality
    @sell_in = item.sell_in
  end

  def update
    if @name != 'Aged Brie' and @name != 'Backstage passes to a TAFKAL80ETC concert'
      if @quality > 0
        if @name != 'Sulfuras, Hand of Ragnaros'
          @quality = @quality - 1
        end
      end
    else
      if @quality < 50
        @quality = @quality + 1
        if @name == 'Backstage passes to a TAFKAL80ETC concert'
          if @sell_in < 11
            if @quality < 50
              @quality = @quality + 1
            end
          end
          if @sell_in < 6
            if @quality < 50
              @quality = @quality + 1
            end
          end
        end
      end
    end
    if @name != 'Sulfuras, Hand of Ragnaros'
      @sell_in = @sell_in - 1
    end
    if @sell_in < 0
      if @name != 'Aged Brie'
        if @name != 'Backstage passes to a TAFKAL80ETC concert'
          if @quality > 0
            if @name != 'Sulfuras, Hand of Ragnaros'
              @quality = @quality - 1
            end
          end
        else
          @quality = @quality - @quality
        end
      else
        if @quality < 50
          @quality = @quality + 1
        end
      end
    end

    update_item
  end

  def update_item
    @item.sell_in = @sell_in
    @item.quality = @quality
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
