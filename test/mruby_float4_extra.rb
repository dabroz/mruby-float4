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

assert('base class') do
  assert_equal Vec4.superclass, BaseVec
  assert_true Vec4.new.is_a? Vec4
  assert_true Vec4.new.is_a? BaseVec
end

assert('dup') do
  v = Vec4.new(1, 2, 3, 4)
  assert_same(v, v.dup)
end

assert('clone') do
  v = Vec4.new(1, 2, 3, 4)
  assert_same(v, v.clone)
end
