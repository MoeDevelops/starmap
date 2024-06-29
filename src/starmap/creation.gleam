import starmap/schema.{type Column}

pub type CreateTable(t_table, t_columns) {
  CreateTable(table: String, columns: t_columns)
}

pub fn create_table3(
  table: String,
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
) -> CreateTable(
  t_table,
  #(Column(a, value), Column(b, value), Column(c, value)),
) {
  CreateTable(table: table, columns: #(column1, column2, column3))
}
