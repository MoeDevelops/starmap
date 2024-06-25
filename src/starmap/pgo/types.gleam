// import gleam/dynamic
// import gleam/option.{type Option}
// import gleam/pgo.{type Value}
// import starmap/schema.{type ColumnType, ColumnType}

// // STILL WORK IN PROGRESS

// // Int types

// pub fn smallint() -> ColumnType(Int, Value) {
//   ColumnType("smallint", False, pgo.int, dynamic.int)
// }

// pub fn integer() -> ColumnType(Int, Value) {
//   ColumnType("integer", False, pgo.int, dynamic.int)
// }

// pub fn bigint() -> ColumnType(Int, Value) {
//   ColumnType("bigint", False, pgo.int, dynamic.int)
// }

// // Serial types

// pub fn smallserial() -> ColumnType(Float, Value) {
//   ColumnType("smallserial", False, pgo.float, dynamic.float)
// }

// pub fn serial() -> ColumnType(Float, Value) {
//   ColumnType("serial", False, pgo.float, dynamic.float)
// }

// pub fn bigserial() -> ColumnType(Float, Value) {
//   ColumnType("bigserial", False, pgo.float, dynamic.float)
// }

// // Float types

// pub fn real() -> ColumnType(Float, Value) {
//   ColumnType("real", False, pgo.float, dynamic.float)
// }

// pub fn double() -> ColumnType(Float, Value) {
//   ColumnType("double precision", False, pgo.float, dynamic.float)
// }

// // Monetary types

// pub fn money() -> ColumnType(Float, Value) {
//   ColumnType("money", False, pgo.float, dynamic.float)
// }

// // Character types

// pub fn bpchar() -> ColumnType(String, Value) {
//   ColumnType("bpchar", False, pgo.text, dynamic.string)
// }

// pub fn text() -> ColumnType(String, Value) {
//   ColumnType("text", False, pgo.text, dynamic.string)
// }

// pub fn text_nullable() -> ColumnType(Option(String), Value) {
//   ColumnType("text", True, fn(x) { pgo.nullable(pgo.text, x) }, fn(x) {
//     dynamic.optional(dynamic.string)(x)
//   })
// }

// // Binary data types

// pub fn bytea() -> ColumnType(BitArray, Value) {
//   ColumnType("bytea", False, pgo.bytea, dynamic.bit_array)
// }
// // TODO: Rest of the types, variable types
