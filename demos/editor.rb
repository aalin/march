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
    'O' => [[0,1,1,1,0],[1,0,0,0,1],[1,0,0,0,1],[1,0,0,0,1],[0,1,1,1,0]],
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

  def initialize(text)
    @text = text
  end

  def draw
    left = 0
    characters.each do |char|
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

  def width
    characters.map { |char| character_width(char) }.inject(0) { |sum, i| sum + i }
  end

  def height
    characters.map { |char| character_height(char) }.map(&:size).max
  end

  private

  def characters
    @characters ||= @text.split('').map { |char| CHARACTERS[char] }.compact
  end

  def character_width(character)
    character.first.size + 1
  end

  def character_height(character)
    character.size + 1
  end
end

class Table
  attr_accessor :rows

  def initialize
    @rows = []
  end

  def update
  end

  def draw
    glPushMatrix

    draw_grid

    @rows.each_with_index do |cells, row_i|
        row_height = row_heights[row_i]

        glTranslate(0.0, border + cell_padding, 0.0)

        glPushMatrix
          cells.each_with_index do |cell, cell_i|
            glTranslate(border + cell_padding, 0, 0)

            cell.draw
            cell_width = column_widths[cell_i]
            glTranslate(cell_width, 0.0, 0.0)

            glTranslate(cell_padding, 0.0, 0.0)
          end
        glPopMatrix

        glTranslate(0.0, cell_padding, 0.0)
        glTranslate(0, row_height, 0.0)
    end
    glPopMatrix
  end

  def cell_padding
    5
  end

  def border
    1
  end

  def width
    column_widths.inject(0) { |sum, (col,w)| sum + w + cell_padding * 2 + border }
  end

  def height
    row_heights.inject(0) { |sum, (row, h)| sum + h + cell_padding * 2 + border }
  end

  private

  def draw_grid
    draw_box(0.0, 0.0, border, height)
    draw_box(0.0, 0.0, width, border)
    draw_box(width, 0.0, border, height)
    draw_box(0.0, height, width, border)

    column_widths.sort_by(&:first).map(&:last).inject(0) do |x, w|
      draw_box(x, 0.0, border, height)
      x + w + cell_padding * 2 + border
    end

    row_heights.sort_by(&:first).map(&:last).inject(0) do |y, h|
      draw_box(0.0, y, width, border)
      y + h + cell_padding * 2 + border
    end
  end

  def column_widths
    update_dimensions unless @column_widths
    @column_widths
  end

  def row_heights
    update_dimensions unless @row_heights
    @row_heights
  end

  def update_dimensions
    @column_widths = {}
    @row_heights = {}
    @rows.each_with_index do |cells, row_i|
      cells.each_with_index do |cell, cell_i|
        if cell.height > @row_heights[row_i].to_i
          @row_heights[row_i] = cell.height
        end

        if cell.width > @column_widths[cell_i].to_i
          @column_widths[cell_i] = cell.width
        end
      end
    end
  end

  def draw_box(x, y, width, height)
    glBegin(GL_QUADS)
    glVertex(x, y)
    glVertex(x + width, y)
    glVertex(x + width, y + height)
    glVertex(x, y + height)
    glEnd()
  end
end

class Pattern
  class Channel
    class Row
    end

    ROWS = 64
    attr_accessor :name

    def initialize(name, number)
      @name = name
      @number = number
      @rows = Array.new(ROWS) { |row| }
    end

    def width
    end

    def draw
    end
  end

  def initialize
    @channels = [
      Channel.new("DRUMS", 0),
      Channel.new("PIANO", 1),
    ]
  end

  def draw
    glPushMatrix

      Table.new.tap { |table|
        table.rows << @channels.map do |channel|
          Font.new(channel.name)
        end
        table.rows << 3.times.map { |i| Font.new((i.next * 1234567).to_s(36).upcase) }
        table.rows << 3.times.map { |i| Font.new((i.next * 234567).to_s(36).upcase) }
        table.rows << 3.times.map { |i| Font.new((i.next * 643234).to_s(36).upcase) }
        table.rows << 3.times.map { |i| Font.new((i.next * 2323).to_s(36).upcase) }
        table.rows << 4.times.map { |i| Font.new("A") }
      }.draw

      height = Channel::ROWS * 8

    glPopMatrix
  end

  private

  def channel_width
    @channels.inject(0) { |total_width, channel| total_width + channel.width }
  end
end

class Editor
  def initialize
    @pattern = Pattern.new
  end

  def update(s)
  end

  def draw
    glColor(1.0, 1.0, 1.0, 1.0)
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
    @x += ((@mouse_position.x || x) - x) / 2.0
    @y += ((@mouse_position.y || y) - y) / 2.0
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
