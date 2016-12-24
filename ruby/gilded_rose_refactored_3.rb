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
    @quality = GuardedQuality.new(item.quality)
    @sell_in = item.sell_in
  end

  def update
    if @name != 'Aged Brie' and @name != 'Backstage passes to a TAFKAL80ETC concert'
      if @name != 'Sulfuras, Hand of Ragnaros'
        @quality.value -= 1
      end
    else
      @quality.value += 1
      if @name == 'Backstage passes to a TAFKAL80ETC concert'
        if @sell_in <= 10
          @quality.value += 1
        end
        if @sell_in <= 5
          @quality.value += 1
        end
      end
    end
    if @name != 'Sulfuras, Hand of Ragnaros'
      @sell_in -= 1
    end
    if @sell_in < 0
      if @name != 'Aged Brie'
        if @name != 'Backstage passes to a TAFKAL80ETC concert'
          if @name != 'Sulfuras, Hand of Ragnaros'
            @quality.value -= 1
          end
        else
          @quality.value = 0
        end
      else
        @quality.value += 1
      end
    end

    update_item
  end

  private

  def update_item
    @item.sell_in = @sell_in
    @item.quality = @quality.value
  end

  class GuardedQuality
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def value=(value)
      if value < 0
        @value = 0
      elsif value > 50
        @value = 50
      else
        @value = value
      end
    end
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
