import starmap/schema.{type Column}

pub type CreateTable(t_columns) {
  CreateTable(table: String, columns: t_columns)
}

pub fn create_table1(
  table: String,
  column1: Column(a, value),
) -> CreateTable(Column(a, value)) {
  CreateTable(table: table, columns: column1)
}

pub fn create_table2(
  table: String,
  column1: Column(a, value),
  column2: Column(b, value),
) -> CreateTable(#(Column(a, value), Column(b, value))) {
  CreateTable(table: table, columns: #(column1, column2))
}

pub fn create_table3(
  table: String,
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
) -> CreateTable(#(Column(a, value), Column(b, value), Column(c, value))) {
  CreateTable(table: table, columns: #(column1, column2, column3))
}

pub fn create_table4(
  table: String,
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
) -> CreateTable(
  #(Column(a, value), Column(b, value), Column(c, value), Column(d, value)),
) {
  CreateTable(table: table, columns: #(column1, column2, column3, column4))
}

pub fn create_table5(
  table: String,
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
  column5: Column(e, value),
) -> CreateTable(
  #(
    Column(a, value),
    Column(b, value),
    Column(c, value),
    Column(d, value),
    Column(e, value),
  ),
) {
  CreateTable(table: table, columns: #(
    column1,
    column2,
    column3,
    column4,
    column5,
  ))
}

pub fn create_table6(
  table: String,
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
  column5: Column(e, value),
  column6: Column(f, value),
) -> CreateTable(
  #(
    Column(a, value),
    Column(b, value),
    Column(c, value),
    Column(d, value),
    Column(e, value),
    Column(f, value),
  ),
) {
  CreateTable(table: table, columns: #(
    column1,
    column2,
    column3,
    column4,
    column5,
    column6,
  ))
}

pub fn create_table7(
  table: String,
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
  column5: Column(e, value),
  column6: Column(f, value),
  column7: Column(g, value),
) -> CreateTable(
  #(
    Column(a, value),
    Column(b, value),
    Column(c, value),
    Column(d, value),
    Column(e, value),
    Column(f, value),
    Column(g, value),
  ),
) {
  CreateTable(table: table, columns: #(
    column1,
    column2,
    column3,
    column4,
    column5,
    column6,
    column7,
  ))
}

pub fn create_table8(
  table: String,
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
  column5: Column(e, value),
  column6: Column(f, value),
  column7: Column(g, value),
  column8: Column(h, value),
) -> CreateTable(
  #(
    Column(a, value),
    Column(b, value),
    Column(c, value),
    Column(d, value),
    Column(e, value),
    Column(f, value),
    Column(g, value),
    Column(h, value),
  ),
) {
  CreateTable(table: table, columns: #(
    column1,
    column2,
    column3,
    column4,
    column5,
    column6,
    column7,
    column8,
  ))
}

pub fn create_table9(
  table: String,
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
  column5: Column(e, value),
  column6: Column(f, value),
  column7: Column(g, value),
  column8: Column(h, value),
  column9: Column(i, value),
) -> CreateTable(
  #(
    Column(a, value),
    Column(b, value),
    Column(c, value),
    Column(d, value),
    Column(e, value),
    Column(f, value),
    Column(g, value),
    Column(h, value),
    Column(i, value),
  ),
) {
  CreateTable(table: table, columns: #(
    column1,
    column2,
    column3,
    column4,
    column5,
    column6,
    column7,
    column8,
    column9,
  ))
}
