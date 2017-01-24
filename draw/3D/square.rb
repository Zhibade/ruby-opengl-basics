##
##    Square primitive
##


require_relative 'primitive'
require_relative '../../util/utils'

class Square < Primitive
  private

  def initialize
    setup
  end

  def setup
    @verts = [1.0, 1.0, 0.0,
               1.0, -1.0, 0.0,
               -1.0, -1.0, 0.0, # Triangle 1
               -1.0, -1.0, 0.0,
               -1.0, 1.0, 0.0,
                1.0, 1.0, 0.0]

    @numOfVerts = 6
    @colors = Utils.generateColors(6)
  end
end
