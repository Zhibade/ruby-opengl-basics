#
#     Shader compiling and applying
#

require 'opengl'

include Gl

class Shader
  def Shader.stopAll
    glUseProgram(0)
  end

  def initialize(vShader, fShader)
    vertexShader = glCreateShader(GL_VERTEX_SHADER)
    fragShader = glCreateShader(GL_FRAGMENT_SHADER)

    glShaderSource(vertexShader, File.read(vShader))
    glShaderSource(fragShader, File.read(fShader))

    # Compile shaders

    glCompileShader(vertexShader)
    vertexShaderCompile = glGetShaderiv(vertexShader, GL_COMPILE_STATUS)
    p "Compiled Vertex Shader: #{glGetShaderInfoLog(vertexShader)}"

    glCompileShader(fragShader)
    fragShaderCompile = glGetShaderiv(fragShader, GL_COMPILE_STATUS)
    p "Compiled Fragment Shader: #{glGetShaderInfoLog(fragShader)}"

    # Abort if compilation failed

    if (vertexShaderCompile == false or fragShaderCompile == false)
      return false
    end


    # Create program and attach shaders (this links the two shaders together)

    @shaderProg = glCreateProgram()
    glAttachShader(@shaderProg, vertexShader)
    glAttachShader(@shaderProg, fragShader)

    glLinkProgram(@shaderProg)
    programLink = glGetProgramiv(@shaderProg, GL_LINK_STATUS)
    p "Linked Program: #{glGetProgramInfoLog(@shaderProg)}"

    # Abort if link failed

    if programLink == false
      return false
    end
  end

  def apply
    glUseProgram(@shaderProg)
  end

  def setUniform2f(property, x, y)
    location = glGetUniformLocation(@shaderProg, property)

    glUniform2f(location, x, y)
  end

  def setUniform3f(property, x, y, z)
    location = glGetUniformLocation(@shaderProg, property)

    glUniform3f(location, x, y, z)
  end

  def setUniform4f(property, x, y, z, w)
    location = glGetUniformLocation(@shaderProg, property)

    glUniform4f(location, x, y, z, w)
  end

  attr_reader :shaderProg
end
