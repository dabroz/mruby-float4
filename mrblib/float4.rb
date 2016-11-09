# mruby-float4 is hosted at https://github.com/dabroz/mruby-float4
# and distributed under the MIT License (MIT). See LICENSE.
#
# Copyright (c) 2016 Tomasz Dąbrowski

module Vec4::GLSL
  def cross(a, b)
    a.cross(b)
  end

  def sin(a)
    a.sin
  end

  def cos(a)
    a.cos
  end

  def tan(a)
    a.tan
  end

  def asin(a)
    a.asin
  end

  def acos(a)
    a.acos
  end

  def atan(a)
    a.atan
  end

  def atan2(a, b)
    a.atan2(b)
  end

  def degrees(a)
    a.degrees
  end

  def radians(a)
    a.radians
  end

  def min(a, b)
    a.min(b)
  end

  def max(a, b)
    a.max(b)
  end

  def pow(a, b)
    a.pow(b)
  end

  def abs(a)
    a.abs
  end

  def mod(a, b)
    a.mod(b)
  end

  def saturate(a)
    a.saturate
  end

  def reflect(a, b)
    a.reflect(b)
  end

  def refract(a, b, c)
    a.refract(b, c)
  end

  def dot(a, b)
    a.dot(b)
  end

  def length(a)
    a.length
  end

  def length_squared(a)
    a.length_squared
  end

  def smoothstep(a, b, c)
    a.smoothstep(b, c)
  end

  def fract(a)
    a.fract
  end

  def normalize(a)
    a.normalize
  end

  def clamp(a, b, c)
    a.clamp(b, c)
  end

  def mix(a, b, c)
    a.mix(b, c)
  end

  def lerp(a, b, c)
    a.lerp(b, c)
  end

  def step(a, b)
    a.step(b)
  end

  def vec4(*args)
    Vec4.new(*args)
  end

  def vec3(*args)
    Vec3.new(*args)
  end

  def vec2(*args)
    Vec2.new(*args)
  end

  def ivec4(*args)
    IVec4.new(*args)
  end

  def ivec3(*args)
    IVec3.new(*args)
  end

  def ivec2(*args)
    IVec2.new(*args)
  end

  def bvec4(*args)
    BVec4.new(*args)
  end

  def bvec3(*args)
    BVec3.new(*args)
  end

  def bvec2(*args)
    BVec2.new(*args)
  end
end
