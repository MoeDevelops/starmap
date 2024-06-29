import gleam/dynamic.{type DecodeErrors, type Dynamic}

pub type Column(datatype, value) {
  Column(
    table: String,
    name: String,
    column_type: fn() -> ColumnType(datatype, value),
    arguments: List(ColumnArguments),
  )
}

pub type ColumnType(datatype, value) {
  ColumnType(name: String, nullable: Bool, encoding: Encoding(datatype, value))
}

pub type Encoding(datatype, value) {
  Encoding(
    encoder: fn(datatype) -> value,
    decoder: fn(Dynamic) -> Result(datatype, DecodeErrors),
  )
}

pub type ColumnArguments {
  PrimaryKey
  ForeignKey(ref_table: String, ref_column: String)
  Custom(s: String)
}
