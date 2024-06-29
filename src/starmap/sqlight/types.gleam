import gleam/dynamic.{type DecodeErrors, type Dynamic}
import gleam/option.{type Option}
import sqlight.{type Value}
import starmap/schema.{type ColumnType, ColumnType, Encoding}

pub const integer = ColumnType(
  "integer",
  False,
  Encoding(sqlight.int, dynamic.int),
)

pub const integer_nullable = ColumnType(
  "integer",
  True,
  Encoding(integer_nullable_encode, integer_nullable_decode),
)

fn integer_nullable_encode(val: Option(Int)) -> Value {
  sqlight.nullable(sqlight.int, val)
}

fn integer_nullable_decode(dyn: Dynamic) -> Result(Option(Int), DecodeErrors) {
  dynamic.optional(dynamic.int)(dyn)
}

pub const bool = ColumnType(
  "integer",
  False,
  Encoding(sqlight.bool, sqlight.decode_bool),
)

pub const bool_nullable = ColumnType(
  "integer",
  True,
  Encoding(bool_nullable_encode, bool_nullable_decode),
)

fn bool_nullable_encode(val: Option(Bool)) -> Value {
  sqlight.nullable(sqlight.bool, val)
}

fn bool_nullable_decode(dyn: Dynamic) -> Result(Option(Bool), DecodeErrors) {
  dynamic.optional(dynamic.bool)(dyn)
}

pub const real = ColumnType(
  "real",
  False,
  Encoding(sqlight.float, dynamic.float),
)

pub const real_nullable = ColumnType(
  "real",
  True,
  Encoding(real_nullable_encode, real_nullable_decode),
)

fn real_nullable_encode(val: Option(Float)) -> Value {
  sqlight.nullable(sqlight.float, val)
}

fn real_nullable_decode(dyn: Dynamic) -> Result(Option(Float), DecodeErrors) {
  dynamic.optional(dynamic.float)(dyn)
}

pub const text = ColumnType(
  "text",
  False,
  Encoding(sqlight.text, dynamic.string),
)

pub const text_nullable = ColumnType(
  "text",
  True,
  Encoding(text_nullable_encode, text_nullable_decode),
)

fn text_nullable_encode(val: Option(String)) -> Value {
  sqlight.nullable(sqlight.text, val)
}

fn text_nullable_decode(dyn: Dynamic) -> Result(Option(String), DecodeErrors) {
  dynamic.optional(dynamic.string)(dyn)
}

pub const blob = ColumnType(
  "blob",
  False,
  Encoding(sqlight.blob, dynamic.bit_array),
)

pub const blob_nullable = ColumnType(
  "blob",
  True,
  Encoding(blob_nullable_encode, blob_nullable_decode),
)

fn blob_nullable_encode(val: Option(BitArray)) -> Value {
  sqlight.nullable(sqlight.blob, val)
}

fn blob_nullable_decode(dyn: Dynamic) -> Result(Option(BitArray), DecodeErrors) {
  dynamic.optional(dynamic.bit_array)(dyn)
}
