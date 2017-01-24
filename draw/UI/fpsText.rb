#
#     FPS UI Text
#

require_relative 'text2D'

class FPSText < Text2D
  def initialize(pos)
    @prevTime = Time.now
    super(pos, "60", [0.0, 1.0, 0.0])
  end

  def update
    thisTime = Time.now - @prevTime
    @prevTime = Time.now

    fps = 1/thisTime

    self.setText(fps.floor.to_s)
  end
end
