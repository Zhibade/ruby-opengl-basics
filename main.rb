##
##     OPENGL Test project
##


require 'opengl'
require 'glu'
require 'glut'

$LOAD_PATH << '.'


# Vector3D

require 'math/vector3D'

# Camera

require 'camera/navigation'

# Grid

require 'draw/3D/grid'

# Shader

require 'shader/shader'

# Mesh

require 'draw/3D/triangle'
require 'draw/3D/square'
require 'draw/3D/cube'

# UI

require 'draw/UI/text2D'
require 'draw/UI/fpsText'
require 'draw/UI/button'


include Gl
include Glu
include Glut


# ENV - Constants

BG_COLOR = [0.35, 0.39, 0.43]
NO_TRANS = Vector3D.new(0.0, 0.0, 0.0)
NO_ROT = [0.0, 0.0, 0.0, 0.0]
NO_SCALE = Vector3D.new(1.0, 1.0, 1.0)
WIN_WIDTH = 640
WIN_HEIGHT = 480

GLOBAL_MAT_DIFF = [rand, rand, rand]
GLOBAL_MAT_SPEC = [0.1, 0.1, 0.1]


# Window

$winRatio = WIN_WIDTH.to_f / WIN_HEIGHT.to_f

# Camera

$cam = CameraNavigation.new(3.0, 2.0, 3.0)


# Grid

$grid = Grid.new(25, 25, 1.0)


# Shader ------ Needs to be initialized on MAIN

$globalColor = GLOBAL_MAT_DIFF
$shader = nil

# Meshes

$triangleA = Triangle.new
$triangleB = Triangle.new
$squareA = Square.new
$cubeA = Cube.new


# UI

BTN_COLOR_UP = [0.2, 0.2, 0.2]
BTN_COLOR_DOWN = [0.75, 0.75, 0.75]

$fpsText = FPSText.new([10, 20])

randBtnCallback = lambda { $globalColor = [rand, rand, rand] }
$randButton = Button.new([15, WIN_HEIGHT - 50], [100, 30],
                         "Randomize", BTN_COLOR_UP, BTN_COLOR_DOWN, randBtnCallback)


# Key states

$keyPress = { :alt => false, :shift => false};


# Other variables

$rot = 0
$rotSpeed = 0.1



# Lighting init

def lighting
  # Directional

  lightA_color = [1.0, 1.0, 1.0, 1,0]
  lightA_pos = [-1.0, 0.7, 1, 0.0]

  glLightfv(GL_LIGHT0, GL_POSITION, lightA_pos)
  glLightfv(GL_LIGHT0, GL_DIFFUSE, lightA_color)

  # Ambient

  lightB_color = [0.8, 0.8, 1.0, 1,0]
  glLightfv(GL_LIGHT1, GL_AMBIENT, lightB_color)

  # Init

  glShadeModel(GL_SMOOTH)
  glEnable(GL_LIGHTING)
  glEnable(GL_LIGHT0)
  glEnable(GL_LIGHT1)
  #glEnable(GL_COLOR_MATERIAL)  # This enables vertex colors
end




# Depth init

def depth
  #glFrontFace(GL_CW)   # This inverts faces
  glCullFace(GL_BACK)

  glEnable(GL_DEPTH_TEST)
  glEnable(GL_CULL_FACE)
  glDepthFunc(GL_LESS)
end




# Global material

def globalMat
  glMaterialfv(GL_FRONT, GL_DIFFUSE, $globalColor);
  glMaterialfv(GL_FRONT, GL_SPECULAR, GLOBAL_MAT_SPEC);
end




# Shader

def shader
  $shader.apply
  $shader.setUniform4f("Color", *$globalColor, 1.0)   # This needs to be called after glUseProgram
end




# Camera

def camera
  gluLookAt(*$cam.pos.to_a, *$cam.target.to_a, 0.0, 1.0, 0.0) # Position, look at, Y-up
end




# Projection methods (for UI and 3D views)

def orthoProjection
  glMatrixMode(GL_PROJECTION)
  glPushMatrix()

  glLoadIdentity()

  gluOrtho2D(0, WIN_WIDTH, WIN_HEIGHT, 0)     # Reverse Y so 0 is at the top

  glMatrixMode(GL_MODELVIEW)

  glPushMatrix()
  glLoadIdentity()
end


def perspProjection
  glPopMatrix()
  glMatrixMode(GL_PROJECTION)
  glPopMatrix()

  glMatrixMode(GL_MODELVIEW)
end




# Mesh rendering

def meshes
  glPushMatrix()

  #$triangleA.draw([2.0, 0.0, 0.0], [$rot, 0.0, 1.0, 0.0], NO_SCALE)
  #$triangleB.draw([-2.0, 0.0, 0.0], [$rot, 0.0, 1.0, 0.0], NO_SCALE)
  #$squareA.draw(NO_TRANS, [$rot, 0.0, 1.0, 0.0], NO_SCALE)
  $cubeA.draw([0.0, 1.0, 0.0], [$rot, 0.0, 1.0, 0.0], NO_SCALE.to_a)


  #glutSolidCube(2.0)
  #glutSolidSphere(2.0, 50, 50)

  glPopMatrix()
end




# UI rendering

def ui
  glDisable(GL_LIGHTING)
  glDisable(GL_DEPTH_TEST)

  Shader.stopAll

  glPushMatrix()

  $fpsText.draw
  $randButton.draw

  glPopMatrix()

  camera    # Reset camera

  glEnable(GL_LIGHTING)
  glEnable(GL_DEPTH_TEST)
end




# Display function

def display
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

  glClearColor(*BG_COLOR, 1.0)
  glClearDepth(1.0)

  glLoadIdentity()

  camera
  $grid.draw
  globalMat
  shader
  meshes

  # UI rendering

  orthoProjection
  ui
  perspProjection

  $fpsText.update

  glutSwapBuffers()
end




# Menu function -- NOT USED

def menu(val)
  p val
end



# Timer function - Executes itself every 0 seconds

def timer(value)
  $rot += $rotSpeed

  glutTimerFunc(0, :timer, value)
  glutPostRedisplay()
end




# Window resizing function

def reshape(width, height)
  $winRatio = width.to_f / height.to_f
  glViewport(0, 0, width, height)

  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  #glOrtho(-ratio, ratio, -1.0, 1.0, 1.0, -1.0)
  gluPerspective(60.0, $winRatio, 0.01, 1000.0)

  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  #gluLookAt(0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0) # Position, look at, Y-up
end




# Keyboard function

def keyboardDown(key, x, y)
  case key
  when "\e"   # ESCAPE
      exit
  end
end




# Mouse click function

def mouse(button, state, x, y)
  mod = glutGetModifiers()     # Get SHIFT only (on Mac)

  $cam.initMove(state, x, y)

  case button
    when 0    # LEFT-MOUSE
      if state == 0
        $randButton.readMouse(x, y, 1)
      end

      if mod == GLUT_ACTIVE_SHIFT
        if state == 0
          $keyPress[:shift] = true
        else
          $keyPress[:shift] = false
        end
      end

      $keyPress[:alt] = false
    when 1    # ALT + LEFT
      $keyPress[:shift] = false

      if state == 0
        $keyPress[:alt] = true
      else
        $keyPress[:alt] = false
      end
  end
end




# Mouse movement functions

def mouseMove(x, y)
  if $keyPress[:shift] == true
    $cam.dolly(x, y)
  elsif $keyPress[:alt] == true
    $cam.orbit(x, y)
  else
    $cam.tumble(x, y)
  end
end


def mouseMovePassive(x, y)
  $randButton.readMouse(x, y, 0)
end



# MAIN

if __FILE__ == $0
  glutInit()
  glutInitDisplayMode( GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH ) # Double buffering instead of single buffer
  glutInitWindowSize(WIN_WIDTH, WIN_HEIGHT)
  glutInitWindowPosition(100, 100)

  glutCreateWindow('OpenGL Test')

  # Callback functions

  glutDisplayFunc(:display)
  glutReshapeFunc(:reshape)
  glutKeyboardFunc(:keyboardDown)
  #glutKeyboardUpFunc(GLUT.create_callback(:GLUTKeyboardFunc, method(:keyboardUp).to_proc))
  glutMouseFunc(:mouse)
  glutMotionFunc(:mouseMove)
  glutPassiveMotionFunc(:mouseMovePassive)
  glutTimerFunc(0, :timer, 0)

  # UI Menu

  #glutCreateMenu(:menu)
  #glutAddMenuEntry("Randomize", 1)
  #glutAttachMenu(GLUT_LEFT_BUTTON)

  # Lighting & Depth

  lighting
  depth

  $shader = Shader.new("shader/simple.vert", "shader/simple.frag")

  glutMainLoop()
end
