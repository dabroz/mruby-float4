MRUBY_CONFIG=File.expand_path(ENV["MRUBY_CONFIG"] || "build_config_sample.rb")

file :mruby do
  sh "git clone --depth 1 git://github.com/mruby/mruby.git"
end

INPUT = 'tasks/generate.rb'
OUTPUT = 'src/mruby_float4.c'

file OUTPUT => INPUT do
  sh "ruby #{INPUT} > #{OUTPUT}"
end

task :default => :test

desc "compile binary"
task :compile => :mruby do
  sh "cd mruby && MRUBY_CONFIG=#{MRUBY_CONFIG} rake all"
end

desc "test"
task :test => [:mruby, OUTPUT] do
  sh "cd mruby && MRUBY_CONFIG=#{MRUBY_CONFIG} rake test"
end

desc "cleanup"
task :clean do
  sh "cd mruby && rake deep_clean"
end

task :bench_ruby do
  sh 'time ./mruby/build/bench/bin/mruby benchmark/bm_ao_render.rb > benchmark/ruby.ppm'
end

task :bench_float4 do
  sh 'time ./mruby/build/bench/bin/mruby benchmark/bm_ao_render_float4.rb > benchmark/float4.ppm'
end
