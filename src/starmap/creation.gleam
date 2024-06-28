import starmap/schema.{type Column, type Table}

pub type CreateTable(t_table, t_columns) {
  CreateTable(table: Table(t_table), columns: t_columns)
}

pub fn create_table3(
  table: Table(t_table),
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
) -> CreateTable(
  t_table,
  #(Column(a, value), Column(b, value), Column(c, value)),
) {
  CreateTable(table: table, columns: #(column1, column2, column3))
}
