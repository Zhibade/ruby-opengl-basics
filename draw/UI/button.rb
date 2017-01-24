#
#     Generic Button
#

require 'opengl'

require_relative 'text2D'

include Gl

class Button
  def initialize(pos, size, text, colorA, colorB, callback)
    @state = "UP"
    @x, @y = *pos
    @sX, @sY = *size
    @upColor = colorA
    @downColor = colorB

    textPos = [pos[0] + 15, pos[1] + size[1]/2]

    @text = Text2D.new(textPos, text, @downColor)

    @callback = callback
  end

  def draw
    color = @upColor
    textColor = @downColor

    if @state == "OVER"
      color = @downColor
      textColor = @upColor
    end

    @text.setColor(textColor)

    glColor3f(*color)
    glLineWidth(2.0)

    glBegin(GL_QUADS)
    glVertex2i(@x, @y)
    glVertex2i(@x, @y + @sY)
    glVertex2i(@x + @sX, @y + @sY)
    glVertex2i(@x + @sX, @y)
    glEnd()

    @text.draw
  end

  def readMouse(x, y, click)
    if x > @x and x < (@x + @sX) and y > @y and (y < @y + @sY)
      setState("OVER")

      if click == 1
        @callback.call()
      end

    else
      setState("UP")
    end
  end

  def setState(mouseState)
    @state = mouseState
  end
end
