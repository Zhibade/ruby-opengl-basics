#
#       Grid drawing
#

require 'opengl'

include Gl

class Grid
  def initialize(linesX, linesY, spacing)
    @x = linesX
    @y = linesY
    @spacing = spacing

    @xOffset = (@x * @spacing) / 2
    @yOffset = (@y * @spacing) / 2

    @xLength = @yOffset
    @yLength = @xOffset

    @lineWidth = 0.4
    @gridColor = [0.2, 0.2, 0.2]
  end

  def draw
    glDisable(GL_LIGHTING)
    glDisable(GL_DEPTH_TEST)

    glLineWidth(@lineWidth)
    #glMaterialfv(GL_FRONT, GL_DIFFUSE, @gridColor)
    glColor3f(*@gridColor)

    glBegin(GL_LINES)

    (0..@x).each do |n|
      linePos = (@spacing * n) - @xOffset

      glVertex3f(linePos, 0.0, @xLength * -1)
      glVertex3f(linePos, 0.0, @xLength)
    end

    (0..@y).each do |n|
      linePos = (@spacing * n) - @yOffset

      glVertex3f(@xLength * -1, 0.0, linePos)
      glVertex3f(@yLength, 0.0, linePos)
    end

    glEnd()

    glEnable(GL_LIGHTING)
    glEnable(GL_DEPTH_TEST)
  end
end
