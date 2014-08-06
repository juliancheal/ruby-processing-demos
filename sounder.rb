# Sounder sounds for class
# Requires an active microphone to pick up anything
 
require 'ruby-processing'
 
class MinimTest < Processing::App
  load_library "minim"
  load_library "oscP5"
  import "ddf.minim"
  import "ddf.minim.analysis"
  include_package "oscp5"
  import "oscP5"
  import "netP5"
  
  def setup
    @minim = Minim.new(self)
    song = "/Users/Jools/Music/Bangarang/02 Bangarang (feat. Sirah).mp3"
    @input = @minim.load_file(song)
    @input.play()
    @fft = FFT.new(@input.left.size, 44100)
    @beat = BeatDetect.new
    @radius = 0
    
    @oscP5 = OscP5.new(self,12000);
    @myRemoteLocation = NetAddress.new("127.0.0.1",3333);
    @myMessage = OscMessage.new("/test")
  end
  
  def draw
    background 0
    stroke 255
    draw_beat
    draw_waveform
    draw_frequency
  end
  
  def draw_beat
    @beat.detect @input.left
    @radius = 100 if @beat.is_onset
    @radius *= 0.95
    oval width/2, height/2, @radius, @radius
    @myMessage.add("beat")
    @oscP5.send(@myMessage, @myRemoteLocation) if @beat.is_onset
  end
  
  def draw_waveform
    scale = height / 4
    (@input.buffer_size - 1).times do |i|
      line(i,   scale + @input.left.get(i)*scale, 
           i+1, scale + @input.left.get(i+1) * scale)
    end
  end
  
  def draw_frequency
    @fft.forward @input.left
    scale = width / 50
    50.times do |i|
      @fft.scale_band i, i * 0.35 + 1
      @fft.scale_band i, 0.3
      line i*scale, height, i*scale, height - @fft.get_band(i)*4
    end
  end
end
 
MinimTest.new :width => 700, :height => 700, :title => "Minim Test"