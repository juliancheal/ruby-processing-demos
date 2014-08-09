# Visualiser from https://github.com/atleastimtrying/Ruby-Processing-Visualizer/blob/master/visualizer.rb

class Visualiser < Processing::App
	load_library "minim"
	import "ddf.minim"
	import "ddf.minim.analysis"
	
	def setup
		smooth
		size(500,100)
		background 10
		setup_sound
	end
	
	def setup_sound
		@minim = Minim.new(self)
    song = "/Users/Jools/Music/Bangarang/02 Bangarang (feat. Sirah).mp3"
    # @input = @minim.load_file(song)
    # @input.play()
    @input = @minim.get_line_in
		@fft = FFT.new(@input.left.size, 44100)
		@beat = BeatDetect.new
		@freqs = [60, 170, 310, 600, 1000, 3000, 6000, 12000, 14000, 16000]
		@current_ffts = Array.new(@freqs.size, 0.001)
		@previous_ffts = Array.new(@freqs.size, 0.001)
		@max_ffts = Array.new(@freqs.size, 0.001)
		@scaled_ffts = Array.new(@freqs.size, 0.001)
		@bars = []
		@scaled_ffts.each_with_index{|object, index| @bars << Bar.new(30*index + 10,height, 20,height- 10, object) }
		@fft_smoothing = 0.8
	end
	
	def update_sound
		@fft.forward(@input.left)
		@previous_ffts = @current_ffts
		@freqs.each_with_index do |freq,i|
			new_fft = @fft.get_freq(freq)
			@max_ffts[i] = new_fft if new_fft > @max_ffts[i]
			@current_ffts[i] = ((1 - @fft_smoothing)* new_fft) + (@fft_smoothing * @previous_ffts[i])
			@bars[i].src = @scaled_ffts[i] = (@current_ffts[i]/@max_ffts[i])
		end
		
		@beat.detect(@input.left)
	end
	
	def animate_sound
		@bars.each {|bar| bar.animate}
	end
	
	def draw
		background 0
		update_sound
		animate_sound
	end
	
	class Bar
		attr_accessor :src
		
		def initialize(x,y,w,h, src)
			@x = x
			@y = y
			@w = w
			@h = h
			@src = src
		end
		
		def animate
			stroke(0, 255, 0) 
			fill(0, 255, 0) 
			line(@x,@h,@x + @w,@h - (@src * @h))
			ellipse(@x + @w,@h - (@src * @h),5,5)
		end
	end
end
Visualiser.new :title => "Visualiser"