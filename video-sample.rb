#!/usr/bin/env ruby
 
# this is a test of ruby-processing (https://github.com/jashkenas/ruby-processing) with the video library
 
# use "rp5 unpack library" at a command line to install the video library, among others
 
# tested with Ruby 1.9.2
# video file: http://bit.ly/H5yBjK
 
class VideoTest < Processing::App
  load_library :video
  include_package "processing.video"
 
  def setup
    size(640, 480, P2D)
    @movie = Movie.new(self, "data/sample.mov")
    @movie.play                                                                
  end
 
  def draw
    tint(*Array.new(3) { rand(256) })
    movie_event(@movie)
    image(@movie, 0,0)
  end
 
  def movie_event(m)
    m.read
  end
 
end
