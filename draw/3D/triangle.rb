##
##    Triangle primitive
##


require_relative 'primitive'
require_relative '../../util/utils'

class Triangle < Primitive
  private

  def initialize
    setup
  end

  def setup
    @verts = [1, 1, 0.0,
               1, -1, 0.0,
               -1, -1, 0.0]

    @numOfVerts = 3
    @colors = Utils.generateColors(9)
  end
end
