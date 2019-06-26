#!/usr/bin/env ruby

Dir.glob('data/train/*').each do |f|
  raw = IO.read(f)
  unless raw.match(/positives:[^-]*[a-z]/)
    puts f
  end
end
