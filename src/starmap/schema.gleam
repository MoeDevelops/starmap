import gleam/dynamic.{type DecodeErrors, type Dynamic}

pub type Table(table) {
  Table(name: String, table: table)
}

pub type Column(datatype, value) {
  Column(
    name: String,
    encoder: fn(datatype) -> value,
    decoder: fn(Dynamic) -> Result(datatype, DecodeErrors),
  )
}

pub type ColumnType(datatype, value) {
  ColumnType(
    name: String,
    encode: fn(datatype) -> value,
    decoder: fn(Dynamic) -> Result(datatype, DecodeErrors),
  )
}
