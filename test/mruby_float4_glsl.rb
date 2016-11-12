extend Vec4::GLSL

assert('GLSL: float4 class') do
  Vec4
end

assert('GLSL: float4 class instance') do
  assert_equal(vec4.class, Vec4)
end

assert('GLSL: float4 creation with 0 args') do
  vec4()
end

assert('GLSL: float4 creation with 4 args') do
  vec4(1.0, 2.0, 3.0, 4.0)
end

assert('GLSL: float4 creation should raise with 5 args') do
  assert_raise ArgumentError do
    vec4(1.0, 2.0, 3.0, 4.0, 5.0)
  end
end

assert('GLSL: default float2 representation') do
  assert_equal(vec2().to_s, 'vec2(0, 0)')
end

assert('GLSL: float2 string representation') do
  assert_equal(vec2(1.0, 2.0).to_s, 'vec2(1, 2)')
end

assert('GLSL: float2 string representation') do
  assert_equal(vec2(1.5, 2.0).to_s, 'vec2(1.5, 2)')
end

assert('GLSL: float3 string representation') do
  assert_equal(vec3(1.0, 2.0, 3.5).to_s, 'vec3(1, 2, 3.5)')
end

assert('GLSL: float4 string representation') do
  assert_equal(vec4(1.0, 2.0, 3.0, 4.0).to_s, 'vec4(1, 2, 3, 4)')
end

assert('GLSL: int4 string representation') do
  assert_equal(ivec4(1.0, 2.0, 3.0, 4.25).to_s, 'ivec4(1, 2, 3, 4)')
end

assert('GLSL: bool4 string representation') do
  assert_equal(bvec4(nil, 2.0, false, 4.25).to_s, 'bvec4(false, true, false, true)')
end

assert('GLSL: vec4 x/y/z/w members') do
  vec = vec4(-1, 1.25, 42, 9e4)

  assert_equal(vec.x, -1)
  assert_equal(vec.y, 1.25)
  assert_equal(vec.z, 42)
  assert_equal(vec.w, 9e4)
end

assert('GLSL: vec4 [] members') do
  vec = vec4(-1, 1.25, 42, 9e4)

  assert_equal(vec[0], -1)
  assert_equal(vec[1], 1.25)
  assert_equal(vec[2], 42)
  assert_equal(vec[3], 9e4)
end

assert('GLSL: raise on extra members') do
  assert_raise NoMethodError do
    vec2.w
  end
end

assert('GLSL: vec4 [] extra members') do
  vec = vec4(-1, 1.25, 42, 9e4)

  assert_equal(vec[-1], nil)
  assert_equal(vec[4], nil)
  assert_equal(vec[6], nil)
end

assert('GLSL: vec2 [] extra members') do
  vec = vec2(-1, 1.25)

  assert_equal(vec[-1], nil)
  assert_equal(vec[2], nil)
  assert_equal(vec[3], nil)
  assert_equal(vec[4], nil)
  assert_equal(vec[6], nil)
end

assert('GLSL: vec2 [] invalid type') do
  vec = vec2(-1, 1.25)

  assert_raise TypeError do
    assert_equal(vec[1..3], nil)
  end
end

assert('GLSL: vec4.to_vec') do
  vec = vec4(1, 2, 3, 4)
  assert_equal(vec.class, Vec4)
  assert_equal(vec.to_vec4.class, Vec4)
  assert_equal(vec, vec.to_vec4)
end

assert('GLSL: ivec4.to_vec') do
  vec = ivec4(1, 2, 3, 4)
  assert_equal(vec.class, IVec4)
  assert_equal(vec.to_vec4.class, Vec4)
end

assert('GLSL: vec4 ==') do
  assert_equal(vec4(1, 2, 0, 0), vec4(1, 2))
  assert_equal(vec4(1, 2, 3, 4), vec4(1, 2, 3, 4))
  assert_equal(vec4(1, 2, 3, 4), vec4(1.0, 2.0, 3.0, 4.0))
end

assert('GLSL: vec4 -> vec2') do
  v = vec4(1, 2, 3, 4).to_vec2
  assert_equal(v.class, Vec2)
  assert_equal(v.x, 1)
  assert_equal(v.y, 2)
  assert_equal(v[2], nil)
  assert_equal(v[3], nil)
end

assert('GLSL: vec4 -> vec4') do
  v = vec4(1, 2, 3, 4).to_vec4
  assert_equal(v.class, Vec4)
  assert_equal(v.x, 1)
  assert_equal(v.y, 2)
  assert_equal(v[2], 3)
  assert_equal(v[3], 4)
end

assert('GLSL: vec4 not ==') do
  assert_not_equal(vec4(1, 2, 3, 4), vec4(1, 2, 3, 5))
end

assert('GLSL: vec4 floor') do
  assert_equal(vec4(1.25, 3.5, -4.75, 0).floor, vec4(1, 3, -5, 0))
end

assert('GLSL: ivec4 floor') do
  assert_equal(ivec4(1.25, 3.5, -4.75, 0).floor, ivec4(1, 3, -4, 0))
end

assert('GLSL: bvec4 floor') do
  assert_raise NoMethodError do
    bvec4(1.25, 3.5, -4.75, 0).floor
  end
end

assert('GLSL: vec4 ceil') do
  assert_equal(vec4(1.25, 3.5, -4.75, 0).ceil, vec4(2, 4, -4, 0))
end

assert('GLSL: vec4 sign') do
  assert_equal(vec4(1.25, 3.5, -4.75, 0).sign, vec4(1, 1, -1, 0))
end

assert('GLSL: vec4 sqrt') do
  assert_equal(vec4(16, 9, 6.25, 0).sqrt, vec4(4, 3, 2.5, 0))
end

assert('GLSL: vec4 log2') do
  assert_equal(vec4(16, 8, 32, 1).log2, vec4(4, 3, 5, 0))
end

assert('GLSL: vec4 exp2') do
  assert_equal(vec4(8, -1, 1, 0).exp2, vec4(256, 0.5, 2, 1))
end

assert('GLSL: vec2 log') do
  vec = vec2(1, 2.71828182846).log
  tolerance = 1e-7
  assert_true((vec.x - 0.0).abs < tolerance)
  assert_true((vec.y - 1.0).abs < tolerance)
end

assert('GLSL: vec2 exp') do
  vec = vec2(0.0, 1.0).exp
  tolerance = 1e-7
  assert_true((vec.x - 1.0).abs < tolerance)
  assert_true((vec.y - 2.71828182846).abs < tolerance)
end

assert('GLSL: vec2 inversesqrt') do
  vec = vec2(4.0, 2.0).inversesqrt
  tolerance = 1e-7
  assert_true((vec.x - 0.5).abs < tolerance)
  assert_true((vec.y - 0.70710676908493).abs < tolerance)
end

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

assert('GLSL: vec2 sin') do
  vec = sin(vec2(1.0, 2.34))
  assert_vector(vec, vec2(0.84147095680237, 0.71846485137939))
end

assert('GLSL: vec2 cos') do
  vec = cos(vec2(1.0, 2.34))
  assert_vector(vec, vec2(0.54030227661133, -0.69556325674057))
end

assert('GLSL: vec2 tan') do
  vec = tan(vec2(1.0, 2.34))
  assert_vector(vec, vec2(1.5574077367783, -1.0329252481461))
end

assert('GLSL: vec2 asin') do
  vec = asin(vec2(0.8, -0.34))
  assert_vector(vec, vec2(0.92729520797729, -0.34691691398621))
end

assert('GLSL: vec2 acos') do
  vec = acos(vec2(0.8, -0.34))
  assert_vector(vec, vec2(0.64350110292435, 1.9177131652832))
end

assert('GLSL: vec2 atan') do
  vec = atan(vec2(1.0, 2.34))
  assert_vector(vec, vec2(0.78539818525314, 1.1669365167618))
end

assert('GLSL: vec2 atan2') do
  vec1 = vec2(1.0, 2.34)
  vec2 = vec2(4.0, -1.34)
  vec = atan2(vec1, vec2)
  assert_vector(vec, vec2(0.24497866630554, 2.0908625125885), 1e-6)
end

assert('GLSL: vec2 atan2 w/float') do
  vec1 = vec2(1.0, 2.34)
  vec = atan2(vec1, 4.0)
  assert_vector(vec, vec2(0.24497866630554, 0.52931702136993))
end

assert('GLSL: vec2 atan2 w/int') do
  vec1 = vec2(1.0, 2.34)
  vec = atan2(vec1, 4)
  assert_vector(vec, vec2(0.24497866630554, 0.52931702136993))
end

assert('GLSL: vec2 mixed with vec3 should raise on atan2') do
  vec1 = vec2(1.0, 2.34)
  vec2 = vec3(4.0, -1.34, 0.0)
  assert_raise TypeError do
    atan2(vec1, vec2)
  end
end

assert('GLSL: vec2 mixed with Hash should raise on atan2') do
  vec1 = vec2(1.0, 2.34)
  assert_raise TypeError do
    atan2(vec1, {})
  end
end

assert('GLSL: vec3 degrees') do
  vec1 = vec3(1.0, 3.14159265, -0.5)
  vec = degrees(vec1)
  assert_vector(vec, vec3(57.295780181885, 180, -28.647890090942))
end

assert('GLSL: vec3 radians') do
  vec1 = vec3(-171.88733874, 2.34, 180)
  vec = radians(vec1)
  assert_vector(vec, vec3(-3, 0.040840703994036, 3.1415927410126))
end

assert('GLSL: vec3 pow') do
  vec1 = vec3(171.88733874, -2.34, 180)
  vec2 = vec3(0.5, 4.0, -1.5)
  vec = pow(vec1, vec2)
  assert_vector(vec, vec3(13.11058139801, 29.982191085815, 0.00041408665128984))
end

assert('GLSL: vec3 pow') do
  vec1 = vec3(171.88733874, 2.34, 180)
  vec = pow(vec1, 0.5)
  assert_vector(vec, vec3(13.11058139801, 1.5297058820724, 13.416407585144))
end

assert('GLSL: vec4 abs') do
  vec1 = vec4(-180.5, 0.0, -0.0, 42.0)
  vec = abs(vec1)
  assert_vector(vec, vec4(180.5, 0, 0, 42))
end

assert('GLSL: ivec4 abs') do
  vec1 = ivec4(-180.4, 0.0, -0.0, 42.0)
  assert_vector(vec1, ivec4(-180, 0, 0, 42))
  vec = abs(vec1)
  assert_vector(vec, ivec4(180, 0, 0, 42))
end

assert('GLSL: vec3 min') do
  vec1 = vec3(171.88733874, -2.34, 180)
  vec2 = vec3(0.5, 4.0, -1.5)
  vec = min(vec1, vec2)
  assert_vector(vec, vec3(0.5, -2.3399999141693, -1.5))
end

assert('GLSL: vec2 min') do
  vec1 = vec2(171.88733874, -2.34)
  vec = max(vec1, -2)
  assert_vector(vec, vec2(171.88734436035, -2))
end

assert('GLSL: vec4 max') do
  vec1 = vec4(171.88733874, -2.34, 180, 0.0)
  vec2 = vec4(0.5, 4.0, -1.5, 6e2)
  vec = max(vec1, vec2)
  assert_vector(vec, vec4(171.88734436035, 4, 180, 600))
end

assert('GLSL: vec4 max') do
  vec1 = vec4(171.88733874, -2.34, 180, 0.0)
  vec = max(vec1, 120)
  assert_vector(vec, vec4(171.88734436035, 120, 180, 120))
end

assert('GLSL: vec3 max') do
  assert_vector(max(vec3(0,0,1), vec3(0,0,2)), vec3(0,0,2))
end

assert('GLSL: reflection') do
  assert_equal(vec2.data_size, 2)
  assert_equal(vec3.data_size, 3)
  assert_equal(vec4.data_size, 4)
  assert_equal(ivec2.data_size, 2)
  assert_equal(ivec3.data_size, 3)
  assert_equal(ivec4.data_size, 4)
  assert_equal(bvec2.data_size, 2)
  assert_equal(bvec3.data_size, 3)
  assert_equal(bvec4.data_size, 4)

  assert_equal(vec2.data_class, Float)
  assert_equal(vec3.data_class, Float)
  assert_equal(vec4.data_class, Float)
  assert_equal(ivec2.data_class, Fixnum)
  assert_equal(ivec3.data_class, Fixnum)
  assert_equal(ivec4.data_class, Fixnum)
  assert_equal(bvec2.data_class, TrueClass)
  assert_equal(bvec3.data_class, TrueClass)
  assert_equal(bvec4.data_class, TrueClass)
end

assert('GLSL: vec3 fract') do
  vec1 = vec3(171.88733874, -2.34, 0.125)
  vec = fract(vec1)
  assert_vector(vec, vec3(0.88734436035156, -0.34, 0.125))
end

assert('GLSL: vec3 mod float') do
  vec1 = vec3(171.88733874, -2.34, 0.625)
  vec = mod(vec1, 1.4)
  assert_vector(vec, vec3(1.0873472690582, -0.93999993801117, 0.625))
end

assert('GLSL: vec4 mod vec4') do
  vec1 = vec4(171.88733874, -2.34, 2.34, -2.34)
  vec2 = vec4(1.4, -1.5, -1.5, 1.5)
  vec = mod(vec1, vec2)
  assert_vector(vec, vec4(1.0873472690582, -0.83999991416931, 0.83999991416931, -0.83999991416931))
end

assert('GLSL: vec4 normalize') do
  vec1 = vec4(-14.12, 53.19, -8.51, 56.23)
  vec = normalize(vec1)
  assert_vector(vec, vec4(-0.17842307686806, 0.67211920022964, -0.10753402113914, 0.71053326129913))
  assert_float(vec.length, 1.0)
end

assert('GLSL: vec4/vec2 dot should raise') do
  vec1 = vec4(-14.12, 53.19, -8.51, 56.23)
  vec2 = vec2(-0.51, 0.95)
  assert_raise TypeError do
    dot(vec1, vec2)
  end
end

assert('GLSL: vec4 dot') do
  vec1 = vec4(-14.12, 53.19, -8.51, 56.23)
  vec2 = vec4(-0.51, 10.95, 1.24, 0.53)
  vec = dot(vec1, vec2)
  assert_float(vec, 608.88117240791)
end

assert('GLSL: vec4 length') do
  vec1 = vec4(-14.12, 53.19, -8.51, 56.23)
  f = length(vec1)
  assert_float(f, 79.137748718262)
  assert_float(f * f, length_squared(vec1), 1e-4)
end

assert('GLSL: vec4 length_squared') do
  vec1 = vec4(-14.12, 53.19, -8.51, 56.23)
  f = length_squared(vec1)
  assert_float(f, 6262.783303093)
end

assert('GLSL: vec4 saturate') do
  vec1 = vec4(-14.12, 0.19, -8.51, 56.23)
  vec = saturate(vec1)
  assert_vector(vec, vec4(0, 0.19, 0, 1))
end

assert('GLSL: vec4 clamp') do
  vec1 = vec4(-14.12, 0.19, -8.51, 56.23)
  vec2 = vec4(-10, -10, -5, -5)
  vec3 = vec4(0, 0, 10, 20)
  vec = clamp(vec1, vec2, vec3)
  assert_vector(vec, vec4(-10, 0, -5, 20))
end

assert('GLSL: vec4 mix') do
  vec1 = vec4(1, 2, 3, 4)
  vec2 = vec4(100, -100, 20, -20)
  vec3 = vec4(0, 1, 0.5, 0.5)
  vec = mix(vec1, vec2, vec3)
  assert_vector(vec, vec4(1, -100, 11.5, -8))
end

assert('GLSL: vec4 lerp') do
  vec1 = vec4(1, 2, 3, 4)
  vec2 = vec4(100, -100, 20, -20)
  vec3 = vec4(0, 1, 0.5, 0.5)
  vec = lerp(vec1, vec2, vec3)
  assert_vector(vec, vec4(1, -100, 11.5, -8))
end

assert('GLSL: vec4 smoothstep') do
  vec1 = vec4(0.3, 0.3, 0.3, 0.25)
  vec2 = 0.6
  vec3 = vec4(0.4, 0.8, 0.5, 0.1)
  vec = smoothstep(vec1, vec2, vec3)
  assert_vector(vec, vec4(0.25925925374031, 1, 0.74074065685272, 0))
end

assert('GLSL: vec4 step') do
  vec1 = vec4(0.3, 0.9, 0.3, 0.25)
  vec2 = 0.6
  vec = step(vec1, vec2)
  assert_vector(vec, vec4(1, 0, 1, 1))
end

assert('GLSL: vec3 reflect') do
  vec1 = vec3(0.3, -0.3, 0.3).normalize
  vec2 = vec3(0.4, 7.5, 0.5).normalize
  vec = reflect(vec1, vec2)
  assert_vector(vec, vec3(0.63115209341049, 0.43143334984779, 0.64460253715515))
end

assert('GLSL: vec3 refract') do
  vec1 = vec3(-5.3, 0.3, 0.3).normalize
  vec2 = vec3(11.3, 0.3, 0.3).normalize
  vec = refract(vec1, vec2, 0.6)
  assert_vector(vec, vec3(-0.99946171045303, 0.023197997361422, 0.023197997361422))
  vec = refract(vec1, vec2, 25)
  assert_vector(vec, vec3(0, 0, 0))
end

assert('GLSL: vec3 refract should raise on wrong types 1') do
  assert_raise TypeError do
    refract(vec3, vec4, 0.0)
  end
end

assert('GLSL: vec3 refract should raise on wrong types 2') do
  assert_raise TypeError do
    refract(vec3, vec3, vec3)
  end
end

assert('GLSL: vec4 swizzle types') do
  assert_equal(vec4.xxyy.class, Vec4)
  assert_equal(vec4.xyz.class, Vec3)
  assert_equal(vec4.zx.class, Vec2)
end

assert('GLSL: vec4 swizzle') do
  vec = vec4(1.0, 2.0, 3.0, 4.0)
  assert_equal(vec.xxyy, vec4(1.0, 1.0, 2.0, 2.0))
  assert_equal(vec.xyz, vec3(1.0, 2.0, 3.0))
  assert_equal(vec.zx, vec2(3.0, 1.0))
end

assert('GLSL: vec2 swizzle') do
  vec = vec2(1.0, 2.0)
  assert_equal(vec.yx, vec2(2.0, 1.0))
  assert_equal(vec.xy, vec2(1.0, 2.0))
  assert_equal(vec.xxyy, vec4(1.0, 1.0, 2.0, 2.0))
end

assert('GLSL: vec3 +') do
  vec1 = vec3(1.0, 2.0, 3.0)
  vec2 = vec3(2.0, 4.0, 0.0)
  vec = vec1 + vec2
  assert_equal(vec, vec3(3, 6, 3))
end

assert('GLSL: vec3 + f') do
  vec1 = vec3(1.0, 2.0, 3.0)
  vec2 = 2.0
  vec = vec1 + vec2
  assert_equal(vec, vec3(3, 4, 5))
end

assert('GLSL: vec3 -') do
  vec1 = vec3(1.0, 2.0, 3.0)
  vec2 = vec3(2.0, 4.0, 0.0)
  vec = vec1 - vec2
  assert_equal(vec, vec3(-1, -2, 3))
end

assert('GLSL: vec3 - f') do
  vec1 = vec3(1.0, 2.0, 3.0)
  vec2 = 2.0
  vec = vec1 - vec2
  assert_equal(vec, vec3(-1, 0, 1))
end

assert('GLSL: vec3 @-') do
  vec1 = vec3(1.0, 2.0, 3.0)
  vec = -vec1
  assert_equal(vec, vec3(-1, -2, -3))
end

assert('GLSL: vec3 *') do
  vec1 = vec3(1.0, 2.0, 3.0)
  vec2 = vec3(2.0, 4.0, 0.0)
  vec = vec1 * vec2
  assert_equal(vec, vec3(2, 8, 0))
end

assert('GLSL: vec3 * f') do
  vec1 = vec3(1.0, 2.0, 3.0)
  vec2 = 2.0
  vec = vec1 * vec2
  assert_equal(vec, vec3(2, 4, 6))
end

assert('GLSL: vec3 /') do
  vec1 = vec3(1.0, 2.0, 3.0)
  vec2 = vec3(2.0, 4.0, 1.0)
  vec = vec1 / vec2
  assert_equal(vec, vec3(0.5, 0.5, 3.0))
end

assert('GLSL: vec3 / f') do
  vec1 = vec3(1.0, 2.0, 3.0)
  vec2 = 2.0
  vec = vec1 / vec2
  assert_equal(vec, vec3(0.5, 1, 1.5))
end

assert('GLSL: vec2 cross') do
  vec1 = vec2(1.0, 2.0)
  vec2 = vec2(-5.0, 1.4)
  f = cross(vec1, vec2)
  assert_float(f, 11.4, 1e-6)
end

assert('GLSL: vec3 cross') do
  vec1 = vec3(3,-3,1)
  vec2 = vec3(4,9,2)
  vec = cross(vec1, vec2)
  assert_vector(vec, vec3(-15, -2, 39))
end

assert('GLSL: vec2/vec3 cross should raise') do
  assert_raise TypeError do
    cross(vec2, vec3)
  end
end

assert('GLSL: vec4 cross should raise') do
  assert_raise NoMethodError do
    cross(vec4, vec4)
  end
end
