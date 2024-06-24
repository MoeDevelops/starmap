import gleam/dynamic
import gleam/pgo.{type Value}
import starmap/schema.{type ColumnType, ColumnType}

// Int types

pub fn smallint() -> ColumnType(Int, Value) {
  ColumnType("smallint", pgo.int, dynamic.int)
}

pub fn integer() -> ColumnType(Int, Value) {
  ColumnType("integer", pgo.int, dynamic.int)
}

pub fn bigint() -> ColumnType(Int, Value) {
  ColumnType("bigint", pgo.int, dynamic.int)
}

// Serial types

pub fn smallserial() -> ColumnType(Float, Value) {
  ColumnType("smallserial", pgo.float, dynamic.float)
}

pub fn serial() -> ColumnType(Float, Value) {
  ColumnType("serial", pgo.float, dynamic.float)
}

pub fn bigserial() -> ColumnType(Float, Value) {
  ColumnType("bigserial", pgo.float, dynamic.float)
}

// Float types

pub fn real() -> ColumnType(Float, Value) {
  ColumnType("real", pgo.float, dynamic.float)
}

pub fn double() -> ColumnType(Float, Value) {
  ColumnType("double precision", pgo.float, dynamic.float)
}

// Monetary types

pub fn money() -> ColumnType(Float, Value) {
  ColumnType("money", pgo.float, dynamic.float)
}

// Character types

pub fn bpchar() -> ColumnType(String, Value) {
  ColumnType("bpchar", pgo.text, dynamic.string)
}

pub fn text() -> ColumnType(String, Value) {
  ColumnType("text", pgo.text, dynamic.string)
}

// Binary data types

pub fn bytea() -> ColumnType(BitArray, Value) {
  ColumnType("bytea", pgo.bytea, dynamic.bit_array)
}
// TODO: Rest of the types, variable types
