#
#     Primitive Parent Class
#     This approach uses vertex libraries instead of the old glBegin way
#


require 'opengl'

include Gl

class Primitive
  @verts = []
  @colors = []
  @normals = []
  @numOfVerts = 0  # This needs to be defined in each mesh, can't be calculated with
                   # .length/3 because of the packing (pack("f*"))

  def draw(translation, rotation, scale)
    glEnableClientState(GL_VERTEX_ARRAY)
    glEnableClientState(GL_COLOR_ARRAY)
    glEnableClientState(GL_NORMAL_ARRAY)

    glVertexPointer(3, GL_FLOAT, 0, @verts) # First argument is either 2D or 3D coords
    glColorPointer(3, GL_FLOAT, 0, @colors)
    glNormalPointer(GL_FLOAT, 0, @normals)


    glPushMatrix() # -------

    glTranslatef(translation[0], translation[1], translation[2])
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3])
    glScalef(scale[0], scale[1], scale[2])

    glMatrixMode(GL_MODELVIEW)
    glDrawArrays(GL_TRIANGLES, 0, @numOfVerts) # Last argument is num of VERTS in TOTAL

    glPopMatrix() # --------


    glDisableClientState(GL_VERTEX_ARRAY)
    glDisableClientState(GL_COLOR_ARRAY)
    glDisableClientState(GL_NORMAL_ARRAY)
  end
end
