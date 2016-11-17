def assert_float(actual, expected, tolerance = 1e-7)
  msg = "Scalar #{actual} expected to be within #{tolerance} of #{expected}"
  assert_true((actual - expected).abs < tolerance, msg)
end

def assert_vector(actual, expected, tolerance = 1e-7)
  msg = "Vector #{actual} expected to be within #{tolerance} of #{expected}"
  assert_true((actual.x - expected.x).abs < tolerance, msg) &&
    assert_true((actual.y - expected.y).abs < tolerance, msg) &&
    (actual.data_size < 3 || assert_true((actual.z - expected.z).abs < tolerance, msg)) &&
    (actual.data_size < 4 || assert_true((actual.w - expected.w).abs < tolerance, msg))
end

def assert_same(a, b)
  assert_equal a.object_id, b.object_id
end

assert('float4 class') do
  Vec4
end

assert('float4 class instance') do
  assert_equal(Vec4.new.class, Vec4)
end

assert('float4 creation with 0 args') do
  Vec4.new()
end

assert('float4 creation with 4 args') do
  Vec4.new(1.0, 2.0, 3.0, 4.0)
end

assert('float4 creation should raise with 5 args') do
  assert_raise ArgumentError do
    Vec4.new(1.0, 2.0, 3.0, 4.0, 5.0)
  end
end

assert('default float2 representation') do
  assert_equal(Vec2.new().to_s, 'vec2(0, 0)')
end

assert('float2 string representation') do
  assert_equal(Vec2.new(1.0, 2.0).to_s, 'vec2(1, 2)')
end

assert('float2 string representation') do
  assert_equal(Vec2.new(1.5, 2.0).to_s, 'vec2(1.5, 2)')
end

assert('float3 string representation') do
  assert_equal(Vec3.new(1.0, 2.0, 3.5).to_s, 'vec3(1, 2, 3.5)')
end

assert('float4 string representation') do
  assert_equal(Vec4.new(1.0, 2.0, 3.0, 4.0).to_s, 'vec4(1, 2, 3, 4)')
end

assert('int4 string representation') do
  assert_equal(IVec4.new(1.0, 2.0, 3.0, 4.25).to_s, 'ivec4(1, 2, 3, 4)')
end

assert('bool4 string representation') do
  assert_equal(BVec4.new(nil, 2.0, false, 4.25).to_s, 'bvec4(false, true, false, true)')
end

assert('vec4 x/y/z/w members') do
  vec = Vec4.new(-1, 1.25, 42, 9e4)

  assert_equal(vec.x, -1)
  assert_equal(vec.y, 1.25)
  assert_equal(vec.z, 42)
  assert_equal(vec.w, 9e4)
end

assert('vec4 [] members') do
  vec = Vec4.new(-1, 1.25, 42, 9e4)

  assert_equal(vec[0], -1)
  assert_equal(vec[1], 1.25)
  assert_equal(vec[2], 42)
  assert_equal(vec[3], 9e4)
end

assert('raise on extra members') do
  assert_raise NoMethodError do
    Vec2.new.w
  end
end

assert('vec4 [] extra members') do
  vec = Vec4.new(-1, 1.25, 42, 9e4)

  assert_equal(vec[-1], nil)
  assert_equal(vec[4], nil)
  assert_equal(vec[6], nil)
end

assert('vec2 [] extra members') do
  vec = Vec2.new(-1, 1.25)

  assert_equal(vec[-1], nil)
  assert_equal(vec[2], nil)
  assert_equal(vec[3], nil)
  assert_equal(vec[4], nil)
  assert_equal(vec[6], nil)
end

assert('vec2 [] invalid type') do
  vec = Vec2.new(-1, 1.25)

  assert_raise TypeError do
    assert_equal(vec[1..3], nil)
  end
end

assert('vec4.to_vec') do
  vec = Vec4.new(1, 2, 3, 4)
  assert_equal(vec.class, Vec4)
  assert_equal(vec.to_vec.class, Vec4)
  assert_equal(vec, vec.to_vec)
end

assert('vec4.to_ivec') do
  vec = Vec4.new(1, 2.5, 3, 4)
  assert_equal(vec.class, Vec4)
  assert_equal(vec.to_ivec.class, IVec4)
  assert_vector(vec.to_ivec, IVec4.new(1,2,3,4))
end

assert('ivec4.to_vec') do
  vec = IVec4.new(1, 2, 3, 4)
  assert_equal(vec.class, IVec4)
  assert_equal(vec.to_vec.class, Vec4)
end

assert('vec4 ==') do
  assert_equal(Vec4.new(1, 2, 0, 0), Vec4.new(1, 2))
  assert_equal(Vec4.new(1, 2, 3, 4), Vec4.new(1, 2, 3, 4))
  assert_equal(Vec4.new(1, 2, 3, 4), Vec4.new(1.0, 2.0, 3.0, 4.0))
end

assert('vec4 should raise when compared with different size (1)') do
  assert_raise TypeError do
    assert_not_equal(Vec2.new(1, 2), Vec4.new(1, 2, 0, 1))
  end
end

assert('vec4 should raise when compared with different size (2)') do
  assert_raise TypeError do
    assert_not_equal(Vec4.new(1, 2, 0, 1), Vec2.new(1, 2))
  end
end

assert('vec4 -> vec2') do
  v = Vec4.new(1, 2, 3, 4).xy
  assert_equal(v.class, Vec2)
  assert_equal(v.x, 1)
  assert_equal(v.y, 2)
  assert_equal(v[2], nil)
  assert_equal(v[3], nil)
end

assert('vec4 -> vec4') do
  v = Vec4.new(1, 2, 3, 4)
  assert_same(v, v.to_vec)
  v = v.to_vec
  assert_equal(v.class, Vec4)
  assert_equal(v.x, 1)
  assert_equal(v.y, 2)
  assert_equal(v[2], 3)
  assert_equal(v[3], 4)
end

assert('vec4 not ==') do
  assert_not_equal(Vec4.new(1, 2, 3, 4), Vec4.new(1, 2, 3, 5))
end

assert('vec4 floor') do
  assert_equal(Vec4.new(1.25, 3.5, -4.75, 0).floor, Vec4.new(1, 3, -5, 0))
end

assert('ivec4 floor') do
  assert_equal(IVec4.new(1.25, 3.5, -4.75, 0).floor, IVec4.new(1, 3, -4, 0))
end

assert('bvec4 floor') do
  assert_raise NoMethodError do
    BVec4.new(1.25, 3.5, -4.75, 0).floor
  end
end

assert('vec4 ceil') do
  assert_equal(Vec4.new(1.25, 3.5, -4.75, 0).ceil, Vec4.new(2, 4, -4, 0))
end

assert('vec4 sign') do
  assert_equal(Vec4.new(1.25, 3.5, -4.75, 0).sign, Vec4.new(1, 1, -1, 0))
end

assert('vec4 sqrt') do
  assert_equal(Vec4.new(16, 9, 6.25, 0).sqrt, Vec4.new(4, 3, 2.5, 0))
end

assert('vec4 log2') do
  assert_equal(Vec4.new(16, 8, 32, 1).log2, Vec4.new(4, 3, 5, 0))
end

assert('vec4 exp2') do
  assert_equal(Vec4.new(8, -1, 1, 0).exp2, Vec4.new(256, 0.5, 2, 1))
end

assert('vec2 log') do
  vec = Vec2.new(1, 2.71828182846).log
  tolerance = 1e-7
  assert_true((vec.x - 0.0).abs < tolerance)
  assert_true((vec.y - 1.0).abs < tolerance)
end

assert('vec2 exp') do
  vec = Vec2.new(0.0, 1.0).exp
  tolerance = 1e-7
  assert_true((vec.x - 1.0).abs < tolerance)
  assert_true((vec.y - 2.71828182846).abs < tolerance)
end

assert('vec2 inversesqrt') do
  vec = Vec2.new(4.0, 2.0).inversesqrt
  tolerance = 1e-7
  assert_true((vec.x - 0.5).abs < tolerance)
  assert_true((vec.y - 0.70710676908493).abs < tolerance)
end

assert('vec2 sin') do
  vec = Vec2.new(1.0, 2.34).sin
  assert_vector(vec, Vec2.new(0.84147095680237, 0.71846485137939))
end

assert('vec2 cos') do
  vec = Vec2.new(1.0, 2.34).cos
  assert_vector(vec, Vec2.new(0.54030227661133, -0.69556325674057))
end

assert('vec2 tan') do
  vec = Vec2.new(1.0, 2.34).tan
  assert_vector(vec, Vec2.new(1.5574077367783, -1.0329252481461))
end

assert('vec2 asin') do
  vec = Vec2.new(0.8, -0.34).asin
  assert_vector(vec, Vec2.new(0.92729520797729, -0.34691691398621))
end

assert('vec2 acos') do
  vec = Vec2.new(0.8, -0.34).acos
  assert_vector(vec, Vec2.new(0.64350110292435, 1.9177131652832), 1e-6)
end

assert('vec2 atan') do
  vec = Vec2.new(1.0, 2.34).atan
  assert_vector(vec, Vec2.new(0.78539818525314, 1.1669365167618))
end

assert('vec2 atan2') do
  vec1 = Vec2.new(1.0, 2.34)
  vec2 = Vec2.new(4.0, -1.34)
  vec = vec1.atan2(vec2)
  assert_vector(vec, Vec2.new(0.24497866630554, 2.0908625125885), 1e-6)
end

assert('vec2 atan2 w/float') do
  vec1 = Vec2.new(1.0, 2.34)
  vec = vec1.atan2(4.0)
  assert_vector(vec, Vec2.new(0.24497866630554, 0.52931702136993))
end

assert('vec2 atan2 w/int') do
  vec1 = Vec2.new(1.0, 2.34)
  vec = vec1.atan2(4)
  assert_vector(vec, Vec2.new(0.24497866630554, 0.52931702136993))
end

assert('vec2 mixed with vec3 should raise on atan2') do
  vec1 = Vec2.new(1.0, 2.34)
  vec2 = Vec3.new(4.0, -1.34, 0.0)
  assert_raise TypeError do
    vec1.atan2(vec2)
  end
end

assert('vec2 mixed with Hash should raise on atan2') do
  vec1 = Vec2.new(1.0, 2.34)
  assert_raise TypeError do
    vec1.atan2({})
  end
end

assert('vec3 degrees') do
  vec1 = Vec3.new(1.0, 3.14159265, -0.5)
  vec = vec1.degrees
  assert_vector(vec, Vec3.new(57.295780181885, 180, -28.647890090942))
end

assert('vec3 radians') do
  vec1 = Vec3.new(-171.88733874, 2.34, 180)
  vec = vec1.radians
  assert_vector(vec, Vec3.new(-3, 0.040840703994036, 3.1415927410126))
end

assert('vec3 pow') do
  vec1 = Vec3.new(171.88733874, -2.34, 180)
  vec2 = Vec3.new(0.5, 4.0, -1.5)
  vec = vec1.pow(vec2)
  assert_vector(vec, Vec3.new(13.11058139801, 29.982191085815, 0.00041408665128984))
end

assert('vec3 pow') do
  vec1 = Vec3.new(171.88733874, 2.34, 180)
  vec = vec1.pow(0.5)
  assert_vector(vec, Vec3.new(13.11058139801, 1.5297058820724, 13.416407585144))
end

assert('vec4 abs') do
  vec1 = Vec4.new(-180.5, 0.0, -0.0, 42.0)
  vec = vec1.abs
  assert_vector(vec, Vec4.new(180.5, 0, 0, 42))
end

assert('ivec4 abs') do
  vec1 = IVec4.new(-180.4, 0.0, -0.0, 42.0)
  assert_vector(vec1, IVec4.new(-180, 0, 0, 42))
  vec = vec1.abs
  assert_vector(vec, IVec4.new(180, 0, 0, 42))
end

assert('vec3 min') do
  vec1 = Vec3.new(171.88733874, -2.34, 180)
  vec2 = Vec3.new(0.5, 4.0, -1.5)
  vec = vec1.min(vec2)
  assert_vector(vec, Vec3.new(0.5, -2.3399999141693, -1.5))
end

assert('vec2 min') do
  vec1 = Vec2.new(171.88733874, -2.34)
  vec = vec1.max(-2)
  assert_vector(vec, Vec2.new(171.88734436035, -2))
end

assert('vec4 max') do
  vec1 = Vec4.new(171.88733874, -2.34, 180, 0.0)
  vec2 = Vec4.new(0.5, 4.0, -1.5, 6e2)
  vec = vec1.max(vec2)
  assert_vector(vec, Vec4.new(171.88734436035, 4, 180, 600))
end

assert('vec4 max') do
  vec1 = Vec4.new(171.88733874, -2.34, 180, 0.0)
  vec = vec1.max(120)
  assert_vector(vec, Vec4.new(171.88734436035, 120, 180, 120))
end

assert('vec3 max') do
  assert_vector(Vec3.new(0,0,1).max(Vec3.new(0,0,2)), Vec3.new(0,0,2))
end

assert('reflection') do
  assert_equal(Vec2.new.data_size, 2)
  assert_equal(Vec3.new.data_size, 3)
  assert_equal(Vec4.new.data_size, 4)
  assert_equal(IVec2.new.data_size, 2)
  assert_equal(IVec3.new.data_size, 3)
  assert_equal(IVec4.new.data_size, 4)
  assert_equal(BVec2.new.data_size, 2)
  assert_equal(BVec3.new.data_size, 3)
  assert_equal(BVec4.new.data_size, 4)

  assert_equal(Vec2.new.data_class, Float)
  assert_equal(Vec3.new.data_class, Float)
  assert_equal(Vec4.new.data_class, Float)
  assert_equal(IVec2.new.data_class, Fixnum)
  assert_equal(IVec3.new.data_class, Fixnum)
  assert_equal(IVec4.new.data_class, Fixnum)
  assert_equal(BVec2.new.data_class, TrueClass)
  assert_equal(BVec3.new.data_class, TrueClass)
  assert_equal(BVec4.new.data_class, TrueClass)
end

assert('vec3 fract') do
  vec1 = Vec3.new(171.88733874, -2.34, 0.125)
  vec = vec1.fract
  assert_vector(vec, Vec3.new(0.88734436035156, -0.34, 0.125))
end

assert('vec3 mod float') do
  vec1 = Vec3.new(171.88733874, -2.34, 0.625)
  vec = vec1.mod(1.4)
  assert_vector(vec, Vec3.new(1.0873472690582, -0.93999993801117, 0.625))
end

assert('vec4 mod vec4') do
  vec1 = Vec4.new(171.88733874, -2.34, 2.34, -2.34)
  vec2 = Vec4.new(1.4, -1.5, -1.5, 1.5)
  vec = vec1.mod(vec2)
  assert_vector(vec, Vec4.new(1.0873472690582, -0.83999991416931, 0.83999991416931, -0.83999991416931))
end

assert('vec4 normalize') do
  vec1 = Vec4.new(-14.12, 53.19, -8.51, 56.23)
  vec = vec1.normalize
  assert_vector(vec, Vec4.new(-0.17842307686806, 0.67211920022964, -0.10753402113914, 0.71053326129913))
  assert_float(vec.length, 1.0)
end

assert('vec4/vec2 dot should raise') do
  vec1 = Vec4.new(-14.12, 53.19, -8.51, 56.23)
  vec2 = Vec2.new(-0.51, 0.95)
  assert_raise TypeError do
    vec1.dot(vec2)
  end
end

assert('vec4 dot') do
  vec1 = Vec4.new(-14.12, 53.19, -8.51, 56.23)
  vec2 = Vec4.new(-0.51, 10.95, 1.24, 0.53)
  vec = vec1.dot(vec2)
  assert_float(vec, 608.88117240791)
end

assert('vec4 length') do
  vec1 = Vec4.new(-14.12, 53.19, -8.51, 56.23)
  f = vec1.length
  assert_float(f, 79.137748718262, 1e-6)
  assert_float(f * f, vec1.length_squared, 1e-4)
end

assert('vec4 length_squared') do
  vec1 = Vec4.new(-14.12, 53.19, -8.51, 56.23)
  f = vec1.length_squared
  assert_float(f, 6262.783303093)
end

assert('vec4 saturate') do
  vec1 = Vec4.new(-14.12, 0.19, -8.51, 56.23)
  vec = vec1.saturate
  assert_vector(vec, Vec4.new(0, 0.19, 0, 1))
end

assert('vec4 clamp') do
  vec1 = Vec4.new(-14.12, 0.19, -8.51, 56.23)
  vec2 = Vec4.new(-10, -10, -5, -5)
  vec3 = Vec4.new(0, 0, 10, 20)
  vec = vec1.clamp(vec2, vec3)
  assert_vector(vec, Vec4.new(-10, 0, -5, 20))
end

assert('vec4 mix') do
  vec1 = Vec4.new(1, 2, 3, 4)
  vec2 = Vec4.new(100, -100, 20, -20)
  vec3 = Vec4.new(0, 1, 0.5, 0.5)
  vec = vec1.mix(vec2, vec3)
  assert_vector(vec, Vec4.new(1, -100, 11.5, -8))
end

assert('vec4 lerp') do
  vec1 = Vec4.new(1, 2, 3, 4)
  vec2 = Vec4.new(100, -100, 20, -20)
  vec3 = Vec4.new(0, 1, 0.5, 0.5)
  vec = vec1.lerp(vec2, vec3)
  assert_vector(vec, Vec4.new(1, -100, 11.5, -8))
end

assert('vec4 smoothstep') do
  vec1 = Vec4.new(0.3, 0.3, 0.3, 0.25)
  vec2 = 0.6
  vec3 = Vec4.new(0.4, 0.8, 0.5, 0.1)
  vec = vec1.smoothstep(vec2, vec3)
  assert_vector(vec, Vec4.new(0.25925925374031, 1, 0.74074065685272, 0))
end

assert('vec4 step') do
  vec1 = Vec4.new(0.3, 0.9, 0.3, 0.25)
  vec2 = 0.6
  vec = vec1.step(vec2)
  assert_vector(vec, Vec4.new(1, 0, 1, 1))
end

assert('vec3 reflect') do
  vec1 = Vec3.new(0.3, -0.3, 0.3).normalize
  vec2 = Vec3.new(0.4, 7.5, 0.5).normalize
  vec = vec1.reflect(vec2)
  assert_vector(vec, Vec3.new(0.63115209341049, 0.43143334984779, 0.64460253715515))
end

assert('vec3 refract') do
  vec1 = Vec3.new(-5.3, 0.3, 0.3).normalize
  vec2 = Vec3.new(11.3, 0.3, 0.3).normalize
  vec = vec1.refract(vec2, 0.6)
  assert_vector(vec, Vec3.new(-0.99946171045303, 0.023197997361422, 0.023197997361422))
  vec = vec1.refract(vec2, 25)
  assert_vector(vec, Vec3.new(0, 0, 0))
end

assert('vec3 refract should raise on wrong types 1') do
  assert_raise TypeError do
    Vec3.new.refract(Vec4.new, 0.0)
  end
end

assert('vec3 refract should raise on wrong types 2') do
  assert_raise TypeError do
    Vec3.new.refract(Vec3.new, Vec3.new)
  end
end

assert('vec4 swizzle types') do
  assert_equal(Vec4.new.xxyy.class, Vec4)
  assert_equal(Vec4.new.xyz.class, Vec3)
  assert_equal(Vec4.new.zx.class, Vec2)
end

assert('vec4 swizzle') do
  vec = Vec4.new(1.0, 2.0, 3.0, 4.0)
  assert_equal(vec.xxyy, Vec4.new(1.0, 1.0, 2.0, 2.0))
  assert_equal(vec.xyz, Vec3.new(1.0, 2.0, 3.0))
  assert_equal(vec.zx, Vec2.new(3.0, 1.0))
end

assert('vec2 swizzle') do
  vec = Vec2.new(1.0, 2.0)
  assert_equal(vec.yx, Vec2.new(2.0, 1.0))
  assert_equal(vec.xy, Vec2.new(1.0, 2.0))
  assert_equal(vec.xxyy, Vec4.new(1.0, 1.0, 2.0, 2.0))
end

assert('vec3 +') do
  vec1 = Vec3.new(1.0, 2.0, 3.0)
  vec2 = Vec3.new(2.0, 4.0, 0.0)
  vec = vec1 + vec2
  assert_equal(vec, Vec3.new(3, 6, 3))
end

assert('vec3 + f') do
  vec1 = Vec3.new(1.0, 2.0, 3.0)
  vec2 = 2.0
  vec = vec1 + vec2
  assert_equal(vec, Vec3.new(3, 4, 5))
end

assert('vec3 -') do
  vec1 = Vec3.new(1.0, 2.0, 3.0)
  vec2 = Vec3.new(2.0, 4.0, 0.0)
  vec = vec1 - vec2
  assert_equal(vec, Vec3.new(-1, -2, 3))
end

assert('vec3 - f') do
  vec1 = Vec3.new(1.0, 2.0, 3.0)
  vec2 = 2.0
  vec = vec1 - vec2
  assert_equal(vec, Vec3.new(-1, 0, 1))
end

assert('vec3 -@') do
  vec1 = Vec3.new(1.0, 2.0, 3.0)
  assert_equal(-vec1, Vec3.new(-1, -2, -3))
end

assert('vec3 @-') do
  vec1 = Vec3.new(1.0, 2.0, 3.0)
  vec = -vec1
  assert_equal(vec, Vec3.new(-1, -2, -3))
end

assert('vec3 *') do
  vec1 = Vec3.new(1.0, 2.0, 3.0)
  vec2 = Vec3.new(2.0, 4.0, 0.0)
  vec = vec1 * vec2
  assert_equal(vec, Vec3.new(2, 8, 0))
end

assert('vec3 * f') do
  vec1 = Vec3.new(1.0, 2.0, 3.0)
  vec2 = 2.0
  vec = vec1 * vec2
  assert_equal(vec, Vec3.new(2, 4, 6))
end

assert('vec3 /') do
  vec1 = Vec3.new(1.0, 2.0, 3.0)
  vec2 = Vec3.new(2.0, 4.0, 1.0)
  vec = vec1 / vec2
  assert_equal(vec, Vec3.new(0.5, 0.5, 3.0))
end

assert('vec3 / f') do
  vec1 = Vec3.new(1.0, 2.0, 3.0)
  vec2 = 2.0
  vec = vec1 / vec2
  assert_equal(vec, Vec3.new(0.5, 1, 1.5))
end

assert('vec2 cross') do
  vec1 = Vec2.new(1.0, 2.0)
  vec2 = Vec2.new(-5.0, 1.4)
  f = vec1.cross(vec2)
  assert_float(f, 11.4, 1e-6)
end

assert('vec3 cross') do
  vec1 = Vec3.new(3,-3,1)
  vec2 = Vec3.new(4,9,2)
  vec = vec1.cross(vec2)
  assert_vector(vec, Vec3.new(-15, -2, 39))
end

assert('vec2/vec3 cross should raise') do
  assert_raise TypeError do
    Vec2.new.cross(Vec3.new)
  end
end

assert('vec4 cross should raise') do
  assert_raise NoMethodError do
    Vec4.new.cross(Vec4.new)
  end
end
