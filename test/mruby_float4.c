#include <mruby.h>
#include <mruby/compile.h>
#include <mruby/float4.h>

static mrb_value
float4_test_mrb_float4_vec(mrb_state *mrb, mrb_value self)
{
  mrb_value vec = mrb_load_string(mrb, "Vec4.new(1, 2, 3)");
  mrb_float4_float value;
  mrb_int size;
  mrb_bool success = mrb_float4_vec(mrb, vec, &value, &size);
  mrb_assert(success);
  mrb_assert(value.data[0] == 1.0f);
  mrb_assert(value.data[1] == 2.0f);
  mrb_assert(value.data[2] == 3.0f);
  mrb_assert(value.data[3] == 0.0f);
  mrb_assert(size == 4);
  return mrb_bool_value(TRUE);
}

void mrb_mruby_float4_gem_test(mrb_state *mrb)
{
  struct RClass *cls;

  cls = mrb_define_class(mrb, "Float4Test", mrb->object_class);
  mrb_define_class_method(mrb, cls, "test_mrb_float4_vec", float4_test_mrb_float4_vec, MRB_ARGS_NONE());
}
