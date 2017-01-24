#
#     UI Text rendering
#

require 'opengl'
require 'glut'

include Gl
include Glut


class Text2D
  def initialize(pos, text, col)
    @x, @y = *pos
    @text = text
    @color = col
  end

  def draw
    glColor3f(*@color)
    glRasterPos2i(@x, @y);

    @text.each_char do |c|
      glutBitmapCharacter(GLUT_BITMAP_HELVETICA_12, c.ord);
    end
  end

  def setPos(pos)
    @x, @y = *pos
  end

  def setText(text)
    @text = text
  end

  def setColor(col)
    @color = col
  end
end
