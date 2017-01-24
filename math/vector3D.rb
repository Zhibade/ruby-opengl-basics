#
#     3D Vector custom class
#

class Vector3D
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z

    @length = nil
    @dirty = false
  end



  def +(v)
    Vector3D.new(@x + v.x, @y + v.y, @z + v.yz)
  end



  def cross(vTarget)
    x = (@y * vTarget.z) - (@z * vTarget.y)
    y = (@z * vTarget.x) - (@x * vTarget.x)
    z = (@x * vTarget.y) - (@y * vTarget.x)
    Vector3D.new(x, y, z)
  end



  def distance(vTarget)
    Vector3D.new(vTarget.x - @x, vTarget.y - @y, vTarget.z - @z)
  end



  def dot(vTarget)
    (@x * vTarget.x) + (@y * vTarget.y) + (@z * vTarget.z)
  end



  def inspect
    "(X : #{@x}, Y : #{@y}, Z : #{@z})"
  end



  def length
    if (@length == nil or @dirty)
      @length = Math.sqrt((x * x) + (y * y) + (z * z))
      @dirty = false
    end

    @length
  end



  def normalize
    nX = @x / self.length
    nY = @y / self.length
    nZ = @z / self.length

    Vector3D.new(nX, nY, nZ)
  end



  def update(x, y, z)
    @x = x
    @y = y
    @z = z
    @dirty = true
  end



  def to_a
    [@x, @y, @z]
  end


  attr_reader :x
  attr_reader :y
  attr_reader :z
end
