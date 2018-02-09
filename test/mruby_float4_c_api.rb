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

assert('C API: test_mrb_float4_vec') do
  Float4Test.test_mrb_float4_vec(Vec4.new(1,2,3,0))
end

assert('C API: test_mrb_float4_value') do
  vec = Float4Test.test_mrb_float4_value

  assert_equal vec.class, Vec3
  assert_equal vec.x, 0.5
  assert_equal vec.y, 1.0
  assert_equal vec.z, 1.5
end
