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

assert('change 1 member (symbol)') do
  v = Vec4.new(1, 2, 3, 4)

  assert_equal(v.changed(:x, 7), Vec4.new(7, 2, 3, 4))
  assert_equal(v.changed(:y, 7), Vec4.new(1, 7, 3, 4))
  assert_equal(v.changed(:z, 7), Vec4.new(1, 2, 7, 4))
  assert_equal(v.changed(:w, 7), Vec4.new(1, 2, 3, 7))
end

assert('change 1 member (string)') do
  v = Vec4.new(1, 2, 3, 4)
  assert_equal(v.changed('x', 7), Vec4.new(7, 2, 3, 4))
  assert_equal(v.changed('y', 7), Vec4.new(1, 7, 3, 4))
  assert_equal(v.changed('z', 7), Vec4.new(1, 2, 7, 4))
  assert_equal(v.changed('w', 7), Vec4.new(1, 2, 3, 7))
end

assert('change 1 member (int)') do
  v = Vec4.new(1, 2, 3, 4)
  assert_equal(v.changed(0, 7), Vec4.new(7, 2, 3, 4))
  assert_equal(v.changed(1, 7), Vec4.new(1, 7, 3, 4))
  assert_equal(v.changed(2, 7), Vec4.new(1, 2, 7, 4))
  assert_equal(v.changed(3, 7), Vec4.new(1, 2, 3, 7))
end

assert('change 1 member errors (1)') do
  assert_raise ArgumentError do
    Vec4.new.changed(false, 7)
  end
end

assert('change 1 member errors (2)') do
  assert_raise ArgumentError do
    Vec4.new.changed({}, 7)
  end
end

assert('change 1 member errors (3)') do
  assert_raise ArgumentError do
    Vec4.new.changed(:s, 7)
  end
end

assert('change 1 member errors (4)') do
  assert_raise ArgumentError do
    Vec4.new.changed('u', 7)
  end
end

assert('change 1 member errors (5)') do
  assert_raise ArgumentError do
    Vec4.new.changed(-1, 7)
  end
end

assert('change 1 member errors (6)') do
  assert_raise ArgumentError do
    Vec4.new.changed(9, 7)
  end
end

assert('change 1 member errors (7)') do
  assert_raise ArgumentError do
    Vec4.new.changed(1.2, 7)
  end
end

assert('change 1 named member') do
  v = Vec4.new(1, 2, 3, 4)

  assert_equal(v.changed_x(7), Vec4.new(7, 2, 3, 4))
  assert_equal(v.changed_y(7), Vec4.new(1, 7, 3, 4))
  assert_equal(v.changed_z(7), Vec4.new(1, 2, 7, 4))
  assert_equal(v.changed_w(7), Vec4.new(1, 2, 3, 7))
end

assert('should not re-initialize') do
  v = Vec4.new(1, 2, 3, 4)

  assert_raise(NameError) do
    v.initialize(5, 6, 7, 8)
  end

  assert_equal(v, Vec4.new(1, 2, 3, 4))
end

assert('eql?') do
  assert_true Vec4.new(1,2,3,4).eql?(Vec4.new(1,2,3,4))
end

assert('hash equal') do
  assert_equal Vec4.new(1,2,3,4).hash, Vec4.new(1,2,3,4).hash
end

assert('hash not equal') do
  assert_not_equal Vec4.new(4,3,2,1).hash, Vec4.new(1,2,3,4).hash
end

assert('using vectors as hash keys') do
  hash = {}
  hash[Vec4.new(1,2,3,4)] = 42
  assert_equal hash[Vec4.new(1,2,3,4)], 42
end

assert('compare with nil') do
  assert_not_equal Vec4.new(1,2,3,4), nil
  assert_true (Vec2.new(1,2) != nil)
  assert_true !(Vec2.new(1,2) == nil)

  assert_true !Vec2.new(1,2).nil?
end

assert('vec4 round') do
  assert_equal(Vec4.new(1.1, 1.6, 1.5, 0.0).round, Vec4.new(1, 2, 2, 0))
  assert_equal(Vec4.new(-1.1, -1.6, -1.5, -0.0).round, Vec4.new(-1, -2, -2, 0))
end
