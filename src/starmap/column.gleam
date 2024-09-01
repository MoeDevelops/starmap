//// Types for definining columns in starmap

import gleam/dynamic.{type DecodeErrors, type Dynamic}

/// Defines a column
pub type Column(datatype, value) {
  Column(
    table: String,
    name: String,
    column_type: ColumnType(datatype, value),
    arguments: List(ColumnArguments),
  )
}

/// Defines both the database and gleam type for the column 
pub type ColumnType(datatype, value) {
  ColumnType(name: String, nullable: Bool, encoding: Encoding(datatype, value))
}

/// Stores the encoder and decoder for a column type
pub type Encoding(datatype, value) {
  Encoding(
    encoder: fn(datatype) -> value,
    decoder: fn(Dynamic) -> Result(datatype, DecodeErrors),
  )
}

/// Extra arguments for a column like primary key, foreign key
pub type ColumnArguments {
  PrimaryKey
  ForeignKey(ref_table: String, ref_column: String)
  Custom(s: String)
}
