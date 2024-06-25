import gleam/dynamic
import gleam/option.{type Option}
import sqlight.{type Value}
import starmap/schema.{type ColumnType, ColumnType, Encoding}

pub fn integer() -> ColumnType(Int, Value) {
  ColumnType("integer", False, Encoding(sqlight.int, dynamic.int))
}

pub fn integer_nullable() -> ColumnType(Option(Int), Value) {
  ColumnType(
    "integer",
    True,
    Encoding(fn(x) { sqlight.nullable(sqlight.int, x) }, fn(x) {
      dynamic.optional(dynamic.int)(x)
    }),
  )
}

pub fn bool() -> ColumnType(Bool, Value) {
  ColumnType("integer", False, Encoding(sqlight.bool, sqlight.decode_bool))
}

pub fn bool_nullable() -> ColumnType(Option(Bool), Value) {
  ColumnType(
    "integer",
    True,
    Encoding(fn(x) { sqlight.nullable(sqlight.bool, x) }, fn(x) {
      dynamic.optional(sqlight.decode_bool)(x)
    }),
  )
}

pub fn real() -> ColumnType(Float, Value) {
  ColumnType("real", False, Encoding(sqlight.float, dynamic.float))
}

pub fn real_nullable() -> ColumnType(Option(Float), Value) {
  ColumnType(
    "real",
    True,
    Encoding(fn(x) { sqlight.nullable(sqlight.float, x) }, fn(x) {
      dynamic.optional(dynamic.float)(x)
    }),
  )
}

pub fn text() -> ColumnType(String, Value) {
  ColumnType("text", False, Encoding(sqlight.text, dynamic.string))
}

pub fn text_nullable() -> ColumnType(Option(String), Value) {
  ColumnType(
    "text",
    True,
    Encoding(fn(x) { sqlight.nullable(sqlight.text, x) }, fn(x) {
      dynamic.optional(dynamic.string)(x)
    }),
  )
}

pub fn blob() -> ColumnType(BitArray, Value) {
  ColumnType("blob", False, Encoding(sqlight.blob, dynamic.bit_array))
}

pub fn blob_nullable() -> ColumnType(Option(BitArray), Value) {
  ColumnType(
    "blob",
    True,
    Encoding(fn(x) { sqlight.nullable(sqlight.blob, x) }, fn(x) {
      dynamic.optional(dynamic.bit_array)(x)
    }),
  )
}
