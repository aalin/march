require 'rubygems'
require 'march'
require 'glapp'


class Font
  CHARACTERS = {
    'A' => [[0,1,1,0],[1,0,0,1],[1,1,1,1],[1,0,0,1],[1,0,0,1]],
    'B' => [[1,1,1,0],[1,0,0,1],[1,1,1,0],[1,0,0,1],[1,1,1,0]],
    'C' => [[0,1,1,0],[1,0,0,1],[1,0,0,0],[1,0,0,1],[0,1,1,0]],
    'D' => [[1,1,1,0],[1,0,0,1],[1,0,0,1],[1,0,0,1],[1,1,1,0]],
    'E' => [[1,1,1,1],[1,0,0,0],[1,1,1,0],[1,0,0,0],[1,1,1,1]],
    'F' => [[1,1,1,1],[1,0,0,0],[1,1,1,0],[1,0,0,0],[1,0,0,0]],
    'G' => [[0,1,1,1],[1,0,0,0],[1,0,1,1],[1,0,0,1],[0,1,1,1]],
    'H' => [[1,0,0,1],[1,0,0,1],[1,1,1,1],[1,0,0,1],[1,0,0,1]],
    'I' => [[1,1,1],[0,1,0],[0,1,0],[0,1,0],[1,1,1]],
    'J' => [[1,1,1,1],[0,0,0,1],[0,0,0,1],[1,0,0,1],[0,1,1,0]],
    'K' => [[1,0,0,1],[1,0,1,0],[1,1,0,0],[1,0,1,0],[1,0,0,1]],
    'L' => [[1,0,0],[1,0,0],[1,0,0],[1,0,0],[1,1,1]],
    'M' => [[1,0,0,0,1],[1,1,0,1,1],[1,0,1,0,1],[1,0,0,0,1],[1,0,0,0,1]],
    'N' => [[1,0,0,1],[1,1,0,1],[1,0,1,1],[1,0,0,1],[1,0,0,1]],
    'O' => [[0,1,1,1,0],[1,0,0,0,1],[1,0,0,0,1],[1,0,0,0,1],[0,1,1,1,1,0]],
    'P' => [[1,1,1,0],[1,0,0,1],[1,1,1,0],[1,0,0,0],[1,0,0,0]],
    'Q' => [[0,1,1,1,0],[1,0,0,0,1],[1,0,0,0,1],[1,0,0,1,1],[0,1,1,1,1]],
    'R' => [[1,1,1,0],[1,0,0,1],[1,1,1,0],[1,0,0,1],[1,0,0,1]],
    'S' => [[0,1,1,1],[1,0,0,0],[0,1,1,0],[0,0,0,1],[1,1,1,0]],
    'T' => [[1,1,1,1,1],[0,0,1,0,0],[0,0,1,0,0],[0,0,1,0,0],[0,0,1,0,0]],
    'U' => [[1,0,0,1],[1,0,0,1],[1,0,0,1],[1,0,0,1],[0,1,1,0]],
    'W' => [[1,0,0,0,1],[1,0,0,0,1],[1,0,1,0,1],[1,1,0,1,1],[1,0,0,0,1]],
    'X' => [[1,0,0,0,1],[0,1,0,1,0],[0,0,1,0,0],[0,1,0,1,0],[1,0,0,0,1]],
    'Y' => [[1,0,0,0,1],[0,1,0,1,0],[0,0,1,0,0],[0,0,1,0,0],[0,0,1,0,0]],
    'Z' => [[1,1,1,1,1],[0,0,0,1,0],[0,0,1,0,0],[0,1,0,0,0],[1,1,1,1,1]],
    '#' => [[0,1,0,1,0],[1,1,1,1,1],[0,1,0,1,0],[1,1,1,1,1],[0,1,0,1,0]],
    'b' => [[1,0,0],[1,0,0],[1,1,0],[1,0,1],[1,1,0]],
    '1' => [[0,1,0],[1,1,0],[0,1,0],[0,1,0],[1,1,1]],
    '2' => [[0,1,1,0],[1,0,0,1],[0,0,1,0],[0,1,0,0],[1,1,1,1]],
    '3' => [[0,1,1,0],[1,0,0,1],[0,0,1,0],[1,0,0,1],[0,1,1,0]],
    '4' => [[1,0,0,1],[1,0,0,1],[1,1,1,1],[0,0,0,1],[0,0,0,1]],
    '5' => [[1,1,1,1],[1,0,0,0],[1,1,1,0],[0,0,0,1],[1,1,1,0]],
    '6' => [[0,1,1,0],[1,0,0,0],[1,1,1,0],[1,0,0,1],[0,1,1,0]],
    '7' => [[1,1,1,1],[0,0,0,1],[0,0,0,1],[0,0,1,0],[0,0,1,0]],
    '8' => [[0,1,1,0],[1,0,0,1],[0,1,1,0],[1,0,0,1],[0,1,1,0]],
    '9' => [[0,1,1,0],[1,0,0,1],[0,1,1,1],[0,0,0,1],[0,1,1,0]],
    '0' => [[0,1,1,0],[1,0,1,1],[1,0,0,1],[1,1,0,1],[0,1,1,0]],
    ' ' => [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
  }

  def draw(text)
    left = 0
    characters_from_text(text).each do |char|
      char.each_with_index do |row, y|
        row.each_with_index do |value, x|
          if value == 1
            glBegin(GL_TRIANGLE_STRIP)
            glVertex(left + x, y)
            glVertex(left + x, y + 1)
            glVertex(left + x + 1, y)
            glVertex(left + x + 1, y + 1)
            glEnd
          end
        end
      end
      left += character_width(char)
    end
  end

  def width(text)
    characters_from_text(text).map { |char| character_width(char) }.inject(0) { |sum, i| sum + i }
  end

  private

  def characters_from_text(text)
    text.split('').map { |char| CHARACTERS[char] }
  end

  def character_width(character)
    character.first.size + 1
  end
end

class Pattern
  class Channel
    def initialize(number)
      @number = number
      @notes = { }
    end

    def draw
      glColor(1.0, 1.0, 1.0, 1.0)
      Font.new.draw('I WISH I WAS A LITTLE BIT TALLER')#BCDEFG#b1234567890')
    end
  end

  def initialize
    @channels = [
      Channel.new(0)
    ]
  end

  def draw
    glPushMatrix
      @channels.each do |channel|
        channel.draw
      end
    glPopMatrix
  end

  def update(s)
  end
end

class Editor
  def initialize
    @pattern = Pattern.new
  end

  def update(s)
  end

  def draw
    @pattern.draw
  end
end

class EditorWindow
  include GLApp

  def initialize
    @editor = Editor.new
    @mouse_position = Struct.new(:x, :y).new
    @x, @y = 0, 0
  end

  def setup_context
    glEnable(GL_BLEND)
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glEnable(GL_LINE_SMOOTH)
    glClearColor(0.0, 0.0, 0.0, 1.0)
  end

  def pre_draw
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(30.0, 1.0, 1.0, 1000.0)
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
  end

  def update(s)
    @editor.update(s)
  end

  def draw
    draw_camera
    @editor.draw
  end

  def keyboard_down(key, meta)
    exit if key == ?\e 
  end 

  def mouse_click(button, state, x, y)
    case state
    when 0 # down
      puts "Mouse down %d at %dx%d" % [button, x, y]
    when 1 # up
      puts "Mouse up %d at %dx%d" % [button, x, y]
    end
  end

  def mouse_dragging_motion(x, y)
    @x += ((@mouse_position.x || x) - x) / 5.0
    @y += ((@mouse_position.y || y) - y) / 5.0
  end

  def mouse_motion(x, y)
    @mouse_position.x = x
    @mouse_position.y = y
  end

  private

  def draw_camera
    x,y = 0, 0
    glRotate(180.0, 0.0, 0.0, 1.0)
    gluLookAt(@x, @y, -900.0,
              @x, @y, 0.0,
              0.0, 1.0, 0.0)

  end
end

EditorWindow.new.show(1024, 1024)
