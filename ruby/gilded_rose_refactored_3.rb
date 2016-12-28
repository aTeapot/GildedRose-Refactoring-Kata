class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      item_update(item).update
    end
  end

  def item_update(item)
    klass =
      case item.name
      when 'Aged Brie'then BrieUpdate
      when 'Backstage passes to a TAFKAL80ETC concert' then BackstagePassesUpdate
      when 'Sulfuras, Hand of Ragnaros' then SulfurasUpdate
      else ItemUpdate
      end
    klass.new(item)
  end
end

class ItemUpdate
  def initialize(item)
    @item = item
    @quality = GuardedQuality.new(item.quality)
    @sell_in = item.sell_in
  end

  def update
    update_sellin
    update_quality
    update_item
  end

  private

  def update_sellin
    @sell_in -= 1
  end

  def update_quality
    @quality.value += expired_modify(quality_modifier)
  end

  def quality_modifier
    -1
  end

  def expired_modify(diff)
    if @sell_in >= 0
      diff
    else
      diff * 2
    end
  end

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
      @value =
        if value < 0
          0
        elsif value > 50
          50
        else
          value
        end
    end
  end
end

class BrieUpdate < ItemUpdate
  private

  def quality_modifier
    1
  end
end

class BackstagePassesUpdate < ItemUpdate
  private

  def update_quality
    if @sell_in < 0
      @quality.value = 0
    elsif @sell_in < 5
      @quality.value += 3
    elsif @sell_in < 10
      @quality.value += 2
    else
      @quality.value += 1
    end
  end
end

class SulfurasUpdate < ItemUpdate
  private

  def update_quality
    # don't update quality
  end

  def update_sellin
    # don't update sell_in
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
