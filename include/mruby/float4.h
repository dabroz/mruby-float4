/* mruby-float4 is hosted at https://github.com/dabroz/mruby-float4
 * and distributed under the MIT License (MIT). See LICENSE.
 *
 * Copyright (c) 2016 Tomasz Dąbrowski
 */

#include <mruby.h>
#include <mruby/istruct.h>

MRB_BEGIN_DECL

/* use istruct in 64-bit mode */
#ifdef MRB_64BIT
#define MRUBY_FLOAT4_USE_ISTRUCT 1
#else
#define MRUBY_FLOAT4_USE_ISTRUCT 0
#endif

#if !MRUBY_FLOAT4_USE_ISTRUCT
MRB_API struct mrb_data_type* mrb_float4_data_type();
#endif

typedef struct mrb_float4_float
{
  float data[4];
} mrb_float4_float;

typedef struct mrb_float4_int
{
  int32_t data[4];
} mrb_float4_int;

typedef struct mrb_float4_bool
{
  mrb_bool data[4];
} mrb_float4_bool;

MRB_API mrb_bool mrb_float4_vec(mrb_state *mrb, mrb_value self, struct mrb_float4_float *value, mrb_int *size);
MRB_API mrb_bool mrb_float4_ivec(mrb_state *mrb, mrb_value self, struct mrb_float4_int *value, mrb_int *size);
MRB_API mrb_bool mrb_float4_bvec(mrb_state *mrb, mrb_value self, struct mrb_float4_bool *value, mrb_int *size);

MRB_END_DECL
