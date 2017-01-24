##
##    Cube primitive
##


require_relative 'primitive'
require_relative '../../util/utils'

class Cube < Primitive
  private

  def initialize
    setup
  end

  # Two tris per face

  def setup
    @verts = [
             -1.0,-1.0, 1.0,     1.0,-1.0, 1.0,      1.0, 1.0, 1.0, # FRONT
              1.0, 1.0, 1.0,    -1.0, 1.0, 1.0,     -1.0,-1.0, 1.0,

              1.0, 1.0,-1.0,     1.0,-1.0,-1.0,     -1.0,-1.0,-1.0, # BACK
             -1.0,-1.0,-1.0,    -1.0, 1.0,-1.0,      1.0, 1.0,-1.0,

              1.0,-1.0,-1.0,     1.0, 1.0,-1.0,      1.0, 1.0, 1.0, # RIGHT
              1.0, 1.0, 1.0,     1.0,-1.0, 1.0,      1.0,-1.0,-1.0,

             -1.0,-1.0, 1.0,     -1.0, 1.0, 1.0,     -1.0, 1.0,-1.0, # LEFT
             -1.0, 1.0,-1.0,     -1.0,-1.0,-1.0,     -1.0,-1.0, 1.0,

              1.0, 1.0, 1.0,      1.0, 1.0,-1.0,     -1.0, 1.0,-1.0, # TOP
             -1.0, 1.0,-1.0,     -1.0, 1.0, 1.0,      1.0, 1.0, 1.0,

             -1.0,-1.0,-1.0,      1.0,-1.0,-1.0,      1.0,-1.0, 1.0, # BOTTOM
              1.0,-1.0, 1.0,     -1.0,-1.0, 1.0,     -1.0,-1.0,-1.0,

              ].pack("f*")

    @normals = [
                 0.0, 0.0, 1.0,     0.0, 0.0, 1.0,      0.0, 0.0, 1.0, # FRONT
                 0.0, 0.0, 1.0,     0.0, 0.0, 1.0,      0.0, 0.0, 1.0,

                 0.0, 0.0,-1.0,     0.0, 0.0,-1.0,      0.0, 0.0,-1.0, # BACK
                 0.0, 0.0,-1.0,     0.0, 0.0,-1.0,      0.0, 0.0,-1.0,

                 1.0, 0.0, 0.0,     1.0, 0.0, 0.0,      1.0, 0.0, 0.0, # RIGHT
                 1.0, 0.0, 0.0,     1.0, 0.0, 0.0,      1.0, 0.0, 0.0,

                -1.0, 0.0, 0.0,     -1.0, 0.0, 0.0,      -1.0, 0.0, 0.0, # LEFT
                -1.0, 0.0, 0.0,     -1.0, 0.0, 0.0,      -1.0, 0.0, 0.0,

                 0.0, 1.0, 0.0,     0.0, 1.0, 0.0,      0.0, 1.0, 0.0, # TOP
                 0.0, 1.0, 0.0,     0.0, 1.0, 0.0,      0.0, 1.0, 0.0,

                 0.0,-1.0, 0.0,     0.0,-1.0, 0.0,      0.0,-1.0, 0.0, # BOTTOM
                 0.0,-1.0, 0.0,     0.0,-1.0, 0.0,      0.0,-1.0, 0.0,

                 ]

    @numOfVerts = 36
    @colors = Utils.generateColors(@numOfVerts*3)
  end
end