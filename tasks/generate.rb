# encoding: utf-8
#
# mruby-float4 is hosted at https://github.com/dabroz/mruby-float4
# and distributed under the MIT License (MIT). See LICENSE.
#
# Copyright (c) 2016 Tomasz Dąbrowski

TYPES = {
  'Vec' => {math: true, ruby_class: 'float_class', converter: 'mrb_to_flo', type: 'float', ruby_arg: 'f', ruby_arg_type: 'mrb_float', ruby_type: 'float', ruby_convert: 'mrb_float_value(mrb, {ITEM})'},
  'IVec' => {math: true, logic: true, ruby_class: 'fixnum_class', converter: 'mruby_float4_to_fixnum', type: 'int', ruby_arg: 'i', ruby_arg_type: 'mrb_int', ruby_type: 'mrb_int', ruby_convert: 'mrb_fixnum_value({ITEM})'},
  'BVec' => {logic: true, ruby_class: 'true_class', converter: 'mruby_float4_to_bool', type: 'bool', ruby_arg: 'b', ruby_arg_type: 'mrb_bool', ruby_type: 'mrb_bool', ruby_convert: 'mrb_bool_value({ITEM})'},
}
SIZES = 2..4

alias puts_orig puts
def puts(text = '')
  puts_orig(text.lines.map(&:rstrip).join("\n"))
end

puts "/* mruby-float4 is hosted at https://github.com/dabroz/mruby-float4
 * and distributed under the MIT License (MIT). See LICENSE.
 * 
 * Copyright (c) 2016 Tomasz Dąbrowski
 *
 * This file is autogenerated by ../tasks/generate.rb
 */
"

puts '
#include <stdlib.h>
#include <stdio.h>
#include <memory.h>
#include <mruby.h>
#include <math.h>
#include <mruby/class.h>
#include <mruby/variable.h>
#include <mruby/array.h>
#include <mruby/string.h>
#include <mruby/data.h>
#include <mruby/variable.h>
#include <mruby/numeric.h>
#include <mruby/float4.h>

#define MRUBY_FLOAT4_MAX(x, y) (((x) > (y)) ? (x) : (y))
#define MRUBY_FLOAT4_MIN(x, y) (((x) < (y)) ? (x) : (y))

#define MRUBY_FLOAT4_NEG(x) (-(x))
#define MRUBY_FLOAT4_ADD(x, y) ((x) + (y))
#define MRUBY_FLOAT4_SUB(x, y) ((x) - (y))
#define MRUBY_FLOAT4_MUL(x, y) ((x) * (y))
#define MRUBY_FLOAT4_DIV(x, y) ((x) / (y))

#define MRUBY_FLOAT4_FROZEN    4
#define MRUBY_FLOAT4_FROZEN_P(s) (((struct RBasic*)mrb_ptr(s))->flags & MRUBY_FLOAT4_FROZEN)
#define MRUBY_FLOAT4_SET_FROZEN_FLAG(s) (((struct RBasic*)mrb_ptr(s))->flags |= MRUBY_FLOAT4_FROZEN)

#if MRUBY_FLOAT4_USE_ISTRUCT
#define FLOAT4_PTR(obj, data_name) (struct data_name*)mrb_istruct_ptr(obj)  
#else
#define FLOAT4_PTR(obj, data_name) (struct data_name*)DATA_PTR(obj)
#endif

#if !MRUBY_FLOAT4_USE_ISTRUCT
static struct mrb_data_type mruby_float4_data_type =
{
  "float4_storage",
  mrb_free
};

MRB_API struct mrb_data_type* mrb_float4_data_type()
{
  return &mruby_float4_data_type;
}
#endif

#define MRUBY_FLOAT4_INSTANCE_TT (MRUBY_FLOAT4_USE_ISTRUCT ? MRB_TT_ISTRUCT : MRB_TT_DATA)

static mrb_value
mruby_float4_instance_alloc(mrb_state *mrb, mrb_value cv)
{
  struct RClass *c = mrb_class_ptr(cv);
  struct RObject *o = (struct RObject*)mrb_obj_alloc(mrb, MRUBY_FLOAT4_INSTANCE_TT, c);
  return mrb_obj_value(o);
}

static float mruby_float4_signf(float value)
{
  if (value > 0.0f) return 1.0f;
  if (value < 0.0f) return -1.0f;
  return 0.0f;
}

static float mruby_float4_inversesqrt(float value)
{
  return 1.0f / sqrtf(value);
}

static float mruby_float4_degrees(float value)
{
  return value * (float)(180.0 / M_PI);
}

static float mruby_float4_radians(float value)
{
  return value * (float)(M_PI / 180.0);
}

static float mruby_float4_fractf(float value)
{
  return fmodf(value, 1.0f);
}

static float mruby_float4_clampf(float value, float min, float max)
{
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

static float mruby_float4_mixf(float x, float y, float a)
{
  return x * (1.0f - a) + y * a;
}

static float mruby_float4_stepf(float edge, float x)
{
  return (x < edge) ? 0.0f : 1.0f;
}

static float mruby_float4_smoothstepf(float edge0, float edge1, float x)
{
  float t = mruby_float4_clampf((x - edge0) / (edge1 - edge0), 0.0f, 1.0f);
  return t * t * (3.0f - 2.0f * t);
}

static float mruby_float4_saturatef(float value)
{
  return mruby_float4_clampf(value, 0.0f, 1.0f);
}

static mrb_int mruby_float4_to_fixnum(mrb_state *mrb, mrb_value self)
{
  switch (mrb_type(self)) {
  case MRB_TT_FIXNUM:
    return mrb_fixnum(self);
  case MRB_TT_FLOAT:
    return (mrb_int)mrb_float(self);
  default:
    mrb_raise(mrb, E_TYPE_ERROR, "not numeric value");
  }
}'

class MethodWriter
  attr_accessor :type_name
  attr_accessor :type_data
  attr_accessor :size
  attr_accessor :ruby_type
  attr_accessor :data_name
  attr_accessor :argsym
  attr_accessor :ruby_arg_type
  attr_accessor :ruby_convert
  attr_accessor :klass
  attr_accessor :klass_c
  attr_accessor :members
  attr_accessor :converter
  attr_accessor :ruby_class

  attr_accessor :functions

  attr_accessor :include_math
  attr_accessor :include_logic

  def initialize(type_name, type_data, size)
    self.type_name = type_name
    self.type_data = type_data
    self.size = size
    self.ruby_type = type_data[:ruby_type]
    self.data_name = "mrb_float4_#{type_data[:type]}"
    self.argsym = type_data[:ruby_arg]
    self.ruby_arg_type = type_data[:ruby_arg_type]
    self.ruby_convert = type_data[:ruby_convert]
    self.klass = "#{type_name}#{size}"
    self.klass_c = klass.downcase
    self.members = %w{x y z w}[0...size]
    self.include_math = type_data[:math]
    self.include_logic = type_data[:logic]
    self.converter = type_data[:converter]
    self.ruby_class = type_data[:ruby_class]

    self.functions = {}
  end

  def disable_write!
    @write_disabled = true
  end

  def puts(text = '')
    Kernel.puts text unless @write_disabled
  end

  def write_function(name, arg_req = 0, arg_opt = 0, ruby_name = nil, extra = nil, &block)
    @functions[ruby_name || name] = [arg_req, arg_opt, ruby_name ? name : nil, extra].compact
    raw_write_function(name, extra == :class, &block)
  end

  def raw_write_function(name, is_klass)
    puts "
static mrb_value mruby_float4_#{klass_c}_#{is_klass ? 'c' : 'i'}_#{name}(mrb_state *mrb, mrb_value #{is_klass ? 'self_class' : 'self'})
{"
    yield
    puts "}"

  end

  def write_initializer
    write_function('initialize', 0, size) do
      puts "  #{ruby_arg_type} argv[#{size}] = {0};
  struct #{data_name} *data;

  if (MRUBY_FLOAT4_FROZEN_P(self))
  {
    mrb_raise(mrb, E_NAME_ERROR, \"`initialize' called twice\");
  }
  MRUBY_FLOAT4_SET_FROZEN_FLAG(self);

  mruby_float4_check_argc(mrb, 0, #{size});

  mrb_get_args(mrb, \"|#{argsym * size}\", #{(0...size).map{|n|'&argv[' + n.to_s + ']'}.join(', ')});

  mrb_assert(sizeof(#{data_name}) <= 16);
#if !MRUBY_FLOAT4_USE_ISTRUCT
  mrb_data_init(self, mrb_malloc(mrb, 16), &mruby_float4_data_type);
#endif
  data = FLOAT4_PTR(self, #{data_name});
  "

      members.each_with_index do |member, index|
        puts "  data->data[#{index}] = argv[#{index}];"
      end

      puts "
  return mrb_nil_value();"
    end
  end

  def write_to_s
    format_arg = (['%S']*size).join(', ')
    format_values = members.each_with_index.map{|member,index|ruby_convert.gsub('{ITEM}',"data->data[#{index}]")}.join(', ')

    write_function('to_s') do
      puts "  struct #{data_name} *data;

  mruby_float4_check_argc(mrb, 0, 0);

  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);

  return mrb_format(mrb, \"#{klass_c}(#{format_arg})\", #{format_values});"
    end
  end

  def write_members
    members.each_with_index do |member, index|
      ret_value = ruby_convert.gsub('{ITEM}',"data->data[#{index}]")
      write_function(member) do
        puts "  struct #{data_name} *data;
  mruby_float4_check_argc(mrb, 0, 0);
  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);
  return #{ret_value};"
      end
    end
  end

  def write_at
    ret_value = ruby_convert.gsub('{ITEM}',"data->data[index]")

    write_function('at', 1, 0, '[]') do
      puts "  struct #{data_name} *data;
  mrb_int index;

  mruby_float4_check_argc(mrb, 1, 1);
  mrb_get_args(mrb, \"i\", &index);
  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);

  if (index < 0 || index >= #{size})
  {
    return mrb_nil_value();
  }
  else
  {
    return #{ret_value};
  }"
    end
  end

  def write_eq
    write_function('eq', 1, 0, '==') do
      puts "  mrb_value other;"
      puts "  struct #{data_name} *self_data;"
      puts "  struct #{data_name} *other_data;"
      puts
      puts "  mruby_float4_check_argc(mrb, 1, 1);"
      puts "  mrb_get_args(mrb, \"o\", &other);"
      puts
      puts "  if (mrb_obj_equal(mrb, self, other)) return mrb_bool_value(1);"
      puts "  if (mrb_obj_class(mrb, self) != mrb_obj_class(mrb, other))"
      puts "  {"
      puts "      mrb_raisef(mrb, E_TYPE_ERROR, \"expected argument to be %S, %S given\", mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, self)), mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, other)));"
      puts "  }"
      puts
      puts "  self_data = FLOAT4_PTR(self, #{data_name});"
      puts "  other_data = FLOAT4_PTR(other, #{data_name});"
      puts
      members.each_with_index do |member, index|
        puts "  if (self_data->data[#{index}] != other_data->data[#{index}]) return mrb_bool_value(0);"
      end
      puts
      puts "  return mrb_bool_value(1);"
    end
  end

  def write_converter(c_type)
    c_size = size
    klass = "#{c_type}#{c_size}"
    method = "to_#{c_type.downcase}"
    write_function(method) do
      min_size = [c_size, size].min
      if c_type == type_name and c_size == size
        puts "  return self;"
      else
        args = (0...min_size).map do |index|
          "mrb_funcall(mrb, self, \"[]\", 1, mrb_fixnum_value(#{index}))"
        end
        cargs = args.join(",\n    ")
        puts "  return mrb_funcall(mrb, mrb_obj_value(mrb_class_get(mrb, \"#{klass}\")), \"new\", #{args.size},
    #{cargs});"
      end
    end
  end

  def print_alloc_ret(klass = nil)
    klass_object = klass ? "mrb_class_get(mrb, \"#{klass}\")" : 'mrb_obj_class(mrb, self)'
    puts "  ret = mruby_float4_instance_alloc(mrb, mrb_obj_value(#{klass_object}));"
    puts "#if !MRUBY_FLOAT4_USE_ISTRUCT"
    puts "  mrb_data_init(ret, mrb_malloc(mrb, 16), &mruby_float4_data_type);"
    puts '#endif'
    puts "  ret_data = FLOAT4_PTR(ret, #{data_name});"
  end

  def write_op(op_name, c_op, c_name = nil)
    write_function(c_name || op_name, 0, 0, op_name) do
      puts "  struct #{data_name} *data;"
      puts "  mrb_value ret;"
      puts "  struct #{data_name} *ret_data;

  mruby_float4_check_argc(mrb, 0, 0);
  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);"
      puts
      print_alloc_ret
      puts
      (0...size).each do |index|
        puts "  ret_data->data[#{index}] = #{c_op}(data->data[#{index}]);"
      end
      puts
      puts "  return ret;"
    end
  end

  def write_op_arg(op_name, c_op, c_name = nil)
    write_function(c_name || op_name, 1, 0, op_name) do
      puts "  struct #{data_name} *data = NULL;"
      puts "  struct #{data_name} *other_data = NULL;"
      puts "  mrb_value ret;"
      puts "  mrb_value other;"
      puts "  #{ruby_arg_type} other_value = 0;"
      puts "  mrb_bool use_vector;"
      puts "  struct #{data_name} *ret_data = NULL;"
      puts
      puts "  mruby_float4_check_argc(mrb, 1, 1);"
      puts "  mrb_get_args(mrb, \"o\", &other);"
      puts "  use_vector = !(mrb_float_p(other) || mrb_fixnum_p(other) || mrb_type(other) == MRB_TT_FALSE || mrb_type(other) == MRB_TT_TRUE);"
      puts "  if (!use_vector)"
      puts "  {"
      puts "    other_value = #{converter}(mrb, other);"
      puts "  }"
      puts "  else"
      puts "  {"
      puts "    if (mrb_obj_class(mrb, self) != mrb_obj_class(mrb, other))"
      puts "    {"
      puts "      mrb_raisef(mrb, E_TYPE_ERROR, \"expected argument to be scalar or %S, %S given\", mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, self)), mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, other)));"
      puts "    }"
      puts "    other_data = FLOAT4_PTR(other, #{data_name});"
      puts "    mrb_assert(other_data);"
      puts "  }"
      puts "  data = FLOAT4_PTR(self, #{data_name});"
      puts "  mrb_assert(data);"
      puts
      print_alloc_ret
      puts
      (0...size).each do |index|
        puts "  ret_data->data[#{index}] = #{c_op}(data->data[#{index}], use_vector ? other_data->data[#{index}] : other_value);"
      end
      puts
      puts "  return ret;"
    end
  end

  def write_op_arg2(op_name, c_op)
    write_function(op_name, 2) do
      puts "  struct #{data_name} *data = NULL;"
      puts "  struct #{data_name} *other_data = NULL;"
      puts "  struct #{data_name} *other_data2 = NULL;"
      puts "  mrb_value ret;"
      puts "  mrb_value other;"
      puts "  mrb_value other2;"
      puts "  #{ruby_arg_type} other_value = 0;"
      puts "  #{ruby_arg_type} other_value2 = 0;"
      puts "  mrb_bool use_vector;"
      puts "  mrb_bool use_vector2;"
      puts "  struct #{data_name} *ret_data = NULL;"
      puts
      puts "  mruby_float4_check_argc(mrb, 2, 2);"
      puts "  mrb_get_args(mrb, \"oo\", &other, &other2);"
      puts "  use_vector = !(mrb_float_p(other) || mrb_fixnum_p(other) || mrb_type(other) == MRB_TT_FALSE || mrb_type(other) == MRB_TT_TRUE);"
      puts "  use_vector2 = !(mrb_float_p(other2) || mrb_fixnum_p(other2) || mrb_type(other2) == MRB_TT_FALSE || mrb_type(other2) == MRB_TT_TRUE);"
      puts "  if (!use_vector)"
      puts "  {"
      puts "    other_value = #{converter}(mrb, other);"
      puts "  }"
      puts "  else"
      puts "  {"
      puts "    if (mrb_obj_class(mrb, self) != mrb_obj_class(mrb, other))"
      puts "    {"
      puts "      mrb_raisef(mrb, E_TYPE_ERROR, \"expected argument to be scalar or %S, %S given\", mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, self)), mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, other)));"
      puts "    }"
      puts "    other_data = FLOAT4_PTR(other, #{data_name});"
      puts "    mrb_assert(other_data);"
      puts "  }"
      puts "  if (!use_vector2)"
      puts "  {"
      puts "    other_value2 = #{converter}(mrb, other2);"
      puts "  }"
      puts "  else"
      puts "  {"
      puts "    if (mrb_obj_class(mrb, self) != mrb_obj_class(mrb, other2))"
      puts "    {"
      puts "      mrb_raisef(mrb, E_TYPE_ERROR, \"expected argument to be scalar or %S, %S given\", mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, self)), mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, other)));"
      puts "    }"
      puts "    other_data2 = FLOAT4_PTR(other2, #{data_name});"
      puts "    mrb_assert(other_data2);"
      puts "  }"
      puts "  data = FLOAT4_PTR(self, #{data_name});"
      puts "  mrb_assert(data);"
      puts
      print_alloc_ret
      puts
      (0...size).each do |index|
        puts "  ret_data->data[#{index}] = #{c_op}(data->data[#{index}], use_vector ? other_data->data[#{index}] : other_value, use_vector2 ? other_data2->data[#{index}] : other_value2);"
      end
      puts
      puts "  return ret;"
    end
  end

  def write_reflection
    write_function("data_size") do
      puts "  return mrb_fixnum_value(#{size});"
    end

    write_function("data_class") do
      puts "  return mrb_obj_value(mrb->#{ruby_class});"
    end
  end

  def write_custom_op(op_name, type, items, per_item = nil, target_fun = nil)
    write_function(op_name, items - 1) do
      puts "  struct #{data_name} *data = NULL;"
      puts "  #{ruby_arg_type} temp_value;"
      if type == :normalize
        puts "  mrb_value ret;"
        puts "  struct #{data_name} *ret_data = NULL;"
        puts "  #{ruby_arg_type} vec_length;"
      else
        puts "  #{ruby_arg_type} ret_value;"
      end
      if items == 2
        puts "  struct #{data_name} *other_data = NULL;"
        puts "  mrb_value other;"
        puts "  #{ruby_arg_type} other_value;"
        puts "  mrb_bool use_vector;"
        puts "  #{ruby_arg_type} other_temp_value;"
      end
      puts
      if items == 1
        puts "  mruby_float4_check_argc(mrb, 0, 0);"
      else
        puts "  mruby_float4_check_argc(mrb, 1, 1);"
        puts "  mrb_get_args(mrb, \"o\", &other);"
        puts "  use_vector = !(mrb_float_p(other) || mrb_fixnum_p(other) || mrb_type(other) == MRB_TT_FALSE || mrb_type(other) == MRB_TT_TRUE);"
        puts "  if (!use_vector)"
        puts "  {"
        puts "    other_value = #{converter}(mrb, other);"
        puts "  }"
        puts "  else"
        puts "  {"
        puts "    if (mrb_obj_class(mrb, self) != mrb_obj_class(mrb, other))"
        puts "    {"
        puts "      mrb_raisef(mrb, E_TYPE_ERROR, \"expected argument to be scalar or %S, %S given\", mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, self)), mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, other)));"
        puts "    }"
        puts "    other_data = FLOAT4_PTR(other, #{data_name});"
        puts "    mrb_assert(other_data);"
        puts "  }"
      end
      puts "  data = FLOAT4_PTR(self, #{data_name});"
      puts "  mrb_assert(data);"
      if type == :normalize
        print_alloc_ret
      end
      puts
      if type == :normalize
        puts "  vec_length = 0.0f;"
        (0...size).each do |index|
          puts "  temp_value = data->data[#{index}];"
          puts "  vec_length += temp_value * temp_value;"
        end
        puts "  vec_length = 1.0f / sqrtf(vec_length);"
        (0...size).each do |index|
          puts "  ret_data->data[#{index}] = data->data[#{index}] * vec_length;"
        end
      else
        puts "  ret_value = 0.0f;"
        (0...size).each do |index|
          puts "  temp_value = data->data[#{index}];"
          if items == 2
            puts "  other_temp_value = use_vector ? other_data->data[#{index}] : other_value;"
          end
          puts "  ret_value += " + per_item.gsub('{ITEM}', 'temp_value').gsub('{A}', 'temp_value').gsub('{B}', 'other_temp_value') + ";"
        end
        puts "  ret_value = " + target_fun.gsub('{ITEM}', 'ret_value') + ";" unless target_fun == '{ITEM}'
      end
      puts
      if type == :normalize
        puts "  return ret;"
      else
        puts "  return " + ruby_convert.gsub('{ITEM}', 'ret_value') + ';'
      end
    end
  end

  def write_reflect
    write_function('reflect', 1) do
      puts "  struct #{data_name} *data = NULL;"
      puts "  struct #{data_name} *other_data = NULL;"
      puts "  #{ruby_type} *I = NULL;"
      puts "  #{ruby_type} *N = NULL;"
      puts "  #{ruby_type} *R = NULL;"
      puts "  #{ruby_type} dot;"
      puts "  mrb_value ret;"
      puts "  mrb_value other;"
      puts "  struct #{data_name} *ret_data = NULL;"
      puts
      puts "  mruby_float4_check_argc(mrb, 1, 1);"
      puts "  mrb_get_args(mrb, \"o\", &other);"
      puts "  if (mrb_obj_class(mrb, self) != mrb_obj_class(mrb, other))"
      puts "  {"
      puts "    mrb_raisef(mrb, E_TYPE_ERROR, \"expected argument to be %S, %S given\", mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, self)), mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, other)));"
      puts "  }"
      puts "  other_data = FLOAT4_PTR(other, #{data_name});"
      puts "  mrb_assert(other_data);"
      puts "  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);
  I = data->data;
  N = other_data->data;"
      puts
      print_alloc_ret
      puts "  R = ret_data->data;"
      puts
      puts "  dot = 0.0f;"
      (0...size).each do |index|
        puts "  dot += I[#{index}] * N[#{index}];"
      end
      (0...size).each do |index|
        puts "  R[#{index}] = I[#{index}] - 2.0 * dot * N[#{index}];"
      end
      puts
      puts "  return ret;"
    end
  end

  def write_refract
    write_function('refract', 2) do
      puts "  struct #{data_name} *data = NULL;"
      puts "  struct #{data_name} *other_data = NULL;"
      puts "  #{ruby_type} *I = NULL;"
      puts "  #{ruby_type} *N = NULL;"
      puts "  #{ruby_type} *R = NULL;"
      puts "  #{ruby_type} dot;"
      puts "  #{ruby_type} k;"
      puts "  #{ruby_type} ksqrt;"
      puts "  mrb_float eta;"
      puts "  mrb_value ret;"
      puts "  mrb_value other;"
      puts "  struct #{data_name} *ret_data = NULL;"
      puts
      puts "  mruby_float4_check_argc(mrb, 2, 2);"
      puts "  mrb_get_args(mrb, \"of\", &other, &eta);"
      puts "  if (mrb_obj_class(mrb, self) != mrb_obj_class(mrb, other))"
      puts "  {"
      puts "    mrb_raisef(mrb, E_TYPE_ERROR, \"expected argument to be %S, %S given\", mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, self)), mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, other)));"
      puts "  }"
      puts "  other_data = FLOAT4_PTR(other, #{data_name});"
      puts "  mrb_assert(other_data);"
      puts "  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);
  I = data->data;
  N = other_data->data;"
      puts
      print_alloc_ret
      puts "  R = ret_data->data;"
      puts
      puts "  dot = 0.0f;"
      (0...size).each do |index|
        puts "  dot += I[#{index}] * N[#{index}];"
      end
      puts "  k = 1.0f - eta * eta * (1.0f - dot * dot);"
      puts "  if (k < 0.0)"
      puts "  {"
      (0...size).each do |index|
        puts "    R[#{index}] = 0.0f;"
      end
      puts "  }"
      puts "  else"
      puts "  {"
      puts "    ksqrt = sqrtf(k);"
      (0...size).each do |index|
        puts "    R[#{index}] = eta * I[#{index}] - (eta * dot + ksqrt) * N[#{index}];"
      end
      puts "  }"
      puts
      puts "  return ret;"
    end
  end

  def write_swizzle(*args)
    name = args.join
    sw_size = args.count
    sw_klass = "#{type_name}#{sw_size}"
    sw_indexes = args.map do |sw|
      members.index(sw)
    end
    write_function(name) do
      puts "  struct #{data_name} *data;"
      puts "  mrb_value ret;"
      puts "  struct #{data_name} *ret_data;

  mruby_float4_check_argc(mrb, 0, 0);
  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);"
      puts
      print_alloc_ret(sw_klass)
      puts
      (0...sw_size).each do |index|
        puts "  ret_data->data[#{index}] = data->data[#{sw_indexes[index]}];"
      end
      puts
      puts "  return ret;"
    end
  end

  def write_swizzles
    members.each do |sw1|
      members.each do |sw2|
        write_swizzle(sw1, sw2)
        members.each do |sw3|
          write_swizzle(sw1, sw2, sw3)
          members.each do |sw4|
            write_swizzle(sw1, sw2, sw3, sw4)
          end
        end
      end
    end
  end

  def write_cross2
    write_function('cross', 1) do
      puts "  struct #{data_name} *data = NULL;"
      puts "  struct #{data_name} *other_data = NULL;"
      puts "  #{ruby_type} *A = NULL;"
      puts "  #{ruby_type} *B = NULL;"
      puts "  mrb_value other;"
      puts
      puts "  mruby_float4_check_argc(mrb, 1, 1);"
      puts "  mrb_get_args(mrb, \"o\", &other);"
      puts "  if (mrb_obj_class(mrb, self) != mrb_obj_class(mrb, other))"
      puts "  {"
      puts "    mrb_raisef(mrb, E_TYPE_ERROR, \"expected argument to be %S, %S given\", mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, self)), mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, other)));"
      puts "  }"
      puts "  other_data = FLOAT4_PTR(other, #{data_name});"
      puts "  mrb_assert(other_data);"
      puts "  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);
  A = data->data;
  B = other_data->data;"

      puts
      puts "  return mrb_float_value(mrb, A[0] * B[1] - A[1] * B[0]);"
    end
  end

  def write_cross3
    write_function('cross', 1) do
      puts "  struct #{data_name} *data = NULL;"
      puts "  struct #{data_name} *other_data = NULL;"
      puts "  #{ruby_type} *A = NULL;"
      puts "  #{ruby_type} *B = NULL;"
      puts "  #{ruby_type} *R = NULL;"
      puts "  mrb_value ret;"
      puts "  mrb_value other;"
      puts "  struct #{data_name} *ret_data = NULL;"
      puts
      puts "  mruby_float4_check_argc(mrb, 1, 1);"
      puts "  mrb_get_args(mrb, \"o\", &other);"
      puts "  if (mrb_obj_class(mrb, self) != mrb_obj_class(mrb, other))"
      puts "  {"
      puts "    mrb_raisef(mrb, E_TYPE_ERROR, \"expected argument to be %S, %S given\", mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, self)), mrb_str_new_cstr(mrb, mrb_obj_classname(mrb, other)));"
      puts "  }"
      puts "  other_data = FLOAT4_PTR(other, #{data_name});"
      puts "  mrb_assert(other_data);"
      puts "  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);
  A = data->data;
  B = other_data->data;"
      puts
      print_alloc_ret
      puts "  R = ret_data->data;"
      puts
      puts "  R[0] = A[1] * B[2] - A[2] * B[1];"
      puts "  R[1] = A[2] * B[0] - A[0] * B[2];"
      puts "  R[2] = A[0] * B[1] - A[1] * B[0];"
      puts
      puts "  return ret;"
    end
  end

  def write_dup
    write_function('dup') do
      puts "  return self;"
    end

    write_function('clone') do
      puts "  return self;"
    end
  end

  def write_glob_type_functions
    puts
    puts "MRB_API mrb_bool mrb_float4_#{type_name.downcase}(mrb_state *mrb, mrb_value self, struct #{data_name} *value, mrb_int *size)"
    puts "{"
    (2..4).each do |n|
      puts "  mrb_bool is_vec#{n} = mrb_obj_class(mrb, self) == mrb_class_get(mrb, \"#{type_name}#{n}\");"
    end
    puts "  if (!is_vec2 && !is_vec3 && !is_vec4)"
    puts "  {"
    puts "    return FALSE;"
    puts "  }"
    puts "  if (size)"
    puts "  {"
    puts "    *size = is_vec2 ? 2 : (is_vec3 ? 3 : 4);"
    puts "  }"
    puts "  if (value)"
    puts "  {"
    puts "    memcpy(value, FLOAT4_PTR(self, #{data_name}), sizeof(struct #{data_name}));"
    puts "  }"
    puts "  return TRUE;"
    puts "}"
  end

  def write_changers
    write_function('changed', 2) do
      puts "  struct #{data_name} *data;"
      puts "  mrb_value ret;"
      puts "  struct #{data_name} *ret_data;"

      puts "  mrb_value member;"
      puts "  #{ruby_arg_type} value;"
      puts "  mrb_int member_index = -1;"
      puts
      puts "  mruby_float4_check_argc(mrb, 2, 2);"
      puts "  mrb_get_args(mrb, \"o#{argsym}\", &member, &value);"
      puts
      puts "  if (mrb_string_p(member))"
      puts "  {"
      puts "    member = mrb_funcall(mrb, member, \"to_sym\", 0);"
      puts "  }"
      puts "  if (mrb_fixnum_p(member))"
      puts "  {"
      puts "    member_index = mrb_fixnum(member);"
      puts "  }"
      puts "  if (mrb_symbol_p(member))"
      puts "  {"
      puts "    if (mrb_intern_cstr(mrb, \"x\") == mrb_symbol(member)) member_index = 0;"
      puts "    else if (mrb_intern_cstr(mrb, \"y\") == mrb_symbol(member)) member_index = 1;"
      puts "    else if (mrb_intern_cstr(mrb, \"z\") == mrb_symbol(member)) member_index = 2;"
      puts "    else if (mrb_intern_cstr(mrb, \"w\") == mrb_symbol(member)) member_index = 3;"
      puts "  }"
      puts
      puts "  if (member_index < 0 || member_index >= #{size})"
      puts "  {"
      exp = members.each_with_index.map do |value, index|
        [":#{value}", "\\\"#{value}\\\"", index]
      end.flatten.join(', ')
      puts "    mrb_raisef(mrb, E_ARGUMENT_ERROR, \"wrong member argument, expected one of: #{exp}\");"
      puts "  }"
      puts "
  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);"
      puts
      print_alloc_ret
      puts
      (0...size).each do |index|
        puts "  ret_data->data[#{index}] = (member_index == #{index}) ? value : data->data[#{index}];"
      end
      puts
      puts "  return ret;"
    end

    members.each_with_index do |member, member_index|
      write_function("changed_#{member}", 1) do
        puts "  struct #{data_name} *data;"
        puts "  mrb_value ret;"
        puts "  struct #{data_name} *ret_data;"
        puts "  #{ruby_arg_type} value;"
        puts
        puts "  mruby_float4_check_argc(mrb, 1, 1);"
        puts "  mrb_get_args(mrb, \"#{argsym}\", &value);"
        puts "
  data = FLOAT4_PTR(self, #{data_name});
  mrb_assert(data);"
        puts
        print_alloc_ret
        puts
        (0...size).each do |index|
          puts "  ret_data->data[#{index}] = " + ((member_index == index) ? "value" : "data->data[#{index}]") + ";"
        end
        puts
        puts "  return ret;"
      end
    end
  end

  def write_functions
    write_initializer
    write_to_s
    write_members
    write_at
    write_eq
    write_reflection
    write_dup
    write_changers

    TYPES.each do |c_type, c_data|
      write_converter(c_type)
    end

    if include_math
      write_op('floor', 'floorf')
      write_op('ceil', 'ceilf')
      write_op('sign', 'mruby_float4_signf')
      write_op('sqrt', 'sqrtf')
      write_op('log2', 'log2f')
      write_op('exp2', 'exp2f')
      write_op('log', 'logf')
      write_op('exp', 'expf')
      write_op('inversesqrt', 'mruby_float4_inversesqrt')
      write_op('sin', 'sinf')
      write_op('cos', 'cosf')
      write_op('tan', 'tanf')
      write_op('asin', 'asinf')
      write_op('acos', 'acosf')
      write_op('atan', 'atanf')
      write_op_arg('atan2', 'atan2f')
      write_op('degrees', 'mruby_float4_degrees')
      write_op('radians', 'mruby_float4_radians')
      write_op_arg('pow', 'powf')
      write_op('abs', type_name == 'IVec' ? 'abs' : 'fabsf')
      write_op_arg('min', 'MRUBY_FLOAT4_MIN')
      write_op_arg('max', 'MRUBY_FLOAT4_MAX')
      write_op('fract', 'mruby_float4_fractf')
      write_op_arg('mod', 'fmodf')
      write_op('saturate', 'mruby_float4_saturatef')
      write_op_arg2('clamp', 'mruby_float4_clampf')
      write_op_arg2('mix', 'mruby_float4_mixf')
      write_op_arg2('lerp', 'mruby_float4_mixf')
      write_op_arg2('smoothstep', 'mruby_float4_smoothstepf')
      write_op_arg('step', 'mruby_float4_stepf')

      write_custom_op('length', :scalar, 1, '({ITEM} * {ITEM})', 'sqrtf({ITEM})')
      write_custom_op('length_squared', :scalar, 1, '({ITEM} * {ITEM})', '{ITEM}')
      write_custom_op('dot', :scalar, 2, '({A} * {B})', '{ITEM}')
      write_custom_op('normalize', :normalize, 1)
      write_op_arg('+', 'MRUBY_FLOAT4_ADD', 'add')
      write_op_arg('-', 'MRUBY_FLOAT4_SUB', 'sub')
      write_op_arg('*', 'MRUBY_FLOAT4_MUL', 'mul')
      write_op_arg('/', 'MRUBY_FLOAT4_DIV', 'div')
      write_op('-@', 'MRUBY_FLOAT4_NEG', 'neg')

      write_reflect
      write_refract
      write_cross2 if size == 2
      write_cross3 if size == 3
    end

    write_swizzles
  end
end

puts "
static void mruby_float4_check_argc(mrb_state *mrb, mrb_int min_argc, mrb_int max_argc)
{
  mrb_int argc = mrb_get_argc(mrb);
  if (argc < min_argc || argc > max_argc)
  {
    mrb_raisef(mrb, E_ARGUMENT_ERROR, \"wrong number of arguments (%S for %S..%S)\", mrb_fixnum_value(argc), mrb_fixnum_value(min_argc), mrb_fixnum_value(max_argc));
  }
}"

TYPES.each do |type_name, type_data|
  MethodWriter.new(type_name, type_data, 4).write_glob_type_functions
end

TYPES.each do |type_name, type_data|
  SIZES.each do |size|
    MethodWriter.new(type_name, type_data, size).write_functions
  end
end

puts "
void mrb_mruby_float4_gem_init(mrb_state *mrb)
{
  struct RClass *base_class = mrb_define_class(mrb, \"BaseVec\", mrb->object_class);
"
puts

TYPES.each do |type_name, type_data|
  SIZES.each do |size|
    klass = "#{type_name}#{size}"
    klass_c = klass.downcase
    klass_name = "mruby_float4_klass_#{klass_c}"

    puts "  struct RClass *#{klass_name};"
  end
end

TYPES.each do |type_name, type_data|
  SIZES.each do |size|
    klass = "#{type_name}#{size}"
    klass_c = klass.downcase
    klass_name = "mruby_float4_klass_#{klass_c}"

    writer = MethodWriter.new(type_name, type_data, size)
    writer.disable_write!
    writer.write_functions

    puts
    puts "  #{klass_name} = mrb_define_class(mrb, \"#{klass}\", base_class);"
    puts "  MRB_SET_INSTANCE_TT(#{klass_name}, MRUBY_FLOAT4_INSTANCE_TT);"
    methods = writer.functions
    methods['inspect'] = [0, 0, 'to_s']
    methods.sort.each do |method_name, method_data|
      method_req = method_data[0]
      method_opt = method_data[1]
      method_cname = method_data[2] || method_name
      method_class = method_data[3] == :class
      method_c_name = "mruby_float4_#{klass_c}_#{method_class ? 'c' : 'i'}_#{method_cname}"
      puts "  mrb_define_#{method_class ? 'class_' : ''}method(mrb, #{klass_name}, \"#{method_name}\", #{method_c_name}, MRB_ARGS_ARG(#{method_req}, #{method_opt}));"
    end
  end
end


puts "}

void mrb_mruby_float4_gem_final(mrb_state *mrb)
{
}
"
