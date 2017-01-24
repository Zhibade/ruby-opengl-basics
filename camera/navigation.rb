#
#       Camera navigation class
#         Left-Mouse: Tumble, ALT + Left-Mouse: Orbit, CTRL + Left-Mouse: Dolly
#

require_relative "../math/vector3D"

class CameraNavigation

  # -------- Constructor ---------

  def initialize(x, y, z)
    @pos = Vector3D.new(x, y, z)
    @target = Vector3D.new(0.0, 0.0, 0.0)


    # Spherical position angles (used when orbiting)
    # Initializing from position (Z and Y switch places because of OpenGLs axes)

    # Polar angle or colatitude
    @zenith = Math.atan(Math.sqrt((@pos.x ** 2) + (@pos.z ** 2)) / @pos.y)

    # X-Y plane or longitude
    @azimuth = Math.atan(@pos.z / @pos.x)


    # 2D to 3D camera control

    @isMoving = false
    @lastPos = nil

    @sensitivity = 0.05
    @orbitSensitivity = 0.5
  end


  # --------- Camera movement methods ---------

  # Tumble
  # Move relative X, Y of position and target relative to target
  # Cross product of camera direction with Y-up gives you local X

  def tumble(x, y)
    if @isMoving
      mouseDist = getMouseDistance([x, y])
      dist3D = [mouseDist[0] * @sensitivity, mouseDist[1] * @sensitivity]

      distNormalized = @pos.distance(@target).normalize
      crossProduct = distNormalized.cross(Vector3D.new(0.0, 1.0, 0.0))

      xMove = dist3D[0] * crossProduct.x
      zMove = dist3D[0] * crossProduct.z

      @pos.update(@pos.x + xMove, @pos.y - dist3D[1], @pos.z + zMove)

      @target.update(@target.x + xMove, @target.y - dist3D[1], @target.z + zMove)

      @lastPos = [x, y]
    end
  end

  def initMove(state, x, y)
    @isMoving = (state == 0) ? true : false
    @lastPos = [x, y]
  end

  # Orbit
  # Rotate position around target
  # Uses spherical coordinates for orbiting

  def orbit(x, y)
    if @isMoving
      mouseDist = getMouseDistance([x, y])
      dist3D = [mouseDist[0] * @orbitSensitivity, mouseDist[1] * @orbitSensitivity]

      radius = @pos.distance(@target).length

      @azimuth -= dist3D[0] * (Math::PI / 180)  # Invert X
      @zenith += dist3D[1] * (Math::PI / 180)

      cosTheta = Math.cos(@azimuth)
      cosPhi = Math.cos(@zenith)
      sinTheta = Math.sin(@azimuth)
      sinPhi = Math.sin(@zenith)

      # Switched Z with Y from math formula so it matches OpenGLs axes

      newX = @target.x + (radius * cosTheta * sinPhi)
      newY = @target.y + (radius * cosPhi)
      newZ = @target.z + (radius * sinTheta * sinPhi)

      @pos.update(newX, newY, newZ)

      @lastPos = [x, y]
    end
  end


  # Dolly
  # Move in relative Z of the camera (taking into account its rotation, AKA target)
  # Position - (Mouse distance * direction)

  def dolly(x, y)
    if @isMoving
      mouseDist = getMouseDistance([x, y])
      dist3D = [mouseDist[0] * @sensitivity, mouseDist[1] * @sensitivity]

      dist = @pos.distance(@target)
      normDist = dist.normalize

      offset = [dist3D[0] * normDist.x, dist3D[0] * normDist.y, dist3D[0] * normDist.z]
      @pos.update(@pos.x - offset[0], @pos.y - offset[1], @pos.z - offset[2])

      @lastPos = [x, y]
    end
  end


  # Variable access

  attr_reader :pos
  attr_reader :target


  # Internal methods

  private

  def getMouseDistance(newPos)
    mouseDiff = [@lastPos[0] - newPos[0], @lastPos[1] - newPos[1]]
  end

end
