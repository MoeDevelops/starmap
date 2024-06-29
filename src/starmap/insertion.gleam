import gleam/list
import starmap/schema.{type Column}

pub type Insertion(a, b) {
  Insertion(table: String, columns: a, values: List(b))
}

pub fn insert_into(table: String) -> Insertion(Nil, Nil) {
  Insertion(table, Nil, [])
}

pub fn columns1(
  insertion: Insertion(Nil, Nil),
  column1: Column(a, value),
) -> Insertion(Column(a, value), a) {
  Insertion(table: insertion.table, columns: column1, values: [])
}

pub fn columns2(
  insertion: Insertion(Nil, Nil),
  column1: Column(a, value),
  column2: Column(b, value),
) -> Insertion(#(Column(a, value), Column(b, value)), #(a, b)) {
  Insertion(table: insertion.table, columns: #(column1, column2), values: [])
}

pub fn columns3(
  insertion: Insertion(Nil, Nil),
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
) -> Insertion(
  #(Column(a, value), Column(b, value), Column(c, value)),
  #(a, b, c),
) {
  Insertion(
    table: insertion.table,
    columns: #(column1, column2, column3),
    values: [],
  )
}

pub fn columns4(
  insertion: Insertion(Nil, Nil),
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
) -> Insertion(
  #(Column(a, value), Column(b, value), Column(c, value), Column(d, value)),
  #(a, b, c, d),
) {
  Insertion(
    table: insertion.table,
    columns: #(column1, column2, column3, column4),
    values: [],
  )
}

pub fn columns5(
  insertion: Insertion(Nil, Nil),
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
  column5: Column(e, value),
) -> Insertion(
  #(
    Column(a, value),
    Column(b, value),
    Column(c, value),
    Column(d, value),
    Column(e, value),
  ),
  #(a, b, c, d, e),
) {
  Insertion(
    table: insertion.table,
    columns: #(column1, column2, column3, column4, column5),
    values: [],
  )
}

pub fn columns6(
  insertion: Insertion(Nil, Nil),
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
  column5: Column(e, value),
  column6: Column(f, value),
) -> Insertion(
  #(
    Column(a, value),
    Column(b, value),
    Column(c, value),
    Column(d, value),
    Column(e, value),
    Column(f, value),
  ),
  #(a, b, c, d, e, f),
) {
  Insertion(
    table: insertion.table,
    columns: #(column1, column2, column3, column4, column5, column6),
    values: [],
  )
}

pub fn columns7(
  insertion: Insertion(Nil, Nil),
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
  column5: Column(e, value),
  column6: Column(f, value),
  column7: Column(g, value),
) -> Insertion(
  #(
    Column(a, value),
    Column(b, value),
    Column(c, value),
    Column(d, value),
    Column(e, value),
    Column(f, value),
    Column(g, value),
  ),
  #(a, b, c, d, e, f, g),
) {
  Insertion(
    table: insertion.table,
    columns: #(column1, column2, column3, column4, column5, column6, column7),
    values: [],
  )
}

pub fn columns8(
  insertion: Insertion(Nil, Nil),
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
  column5: Column(e, value),
  column6: Column(f, value),
  column7: Column(g, value),
  column8: Column(h, value),
) -> Insertion(
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
  #(a, b, c, d, e, f, g, h),
) {
  Insertion(
    table: insertion.table,
    columns: #(
      column1,
      column2,
      column3,
      column4,
      column5,
      column6,
      column7,
      column8,
    ),
    values: [],
  )
}

pub fn columns9(
  insertion: Insertion(Nil, Nil),
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
  column4: Column(d, value),
  column5: Column(e, value),
  column6: Column(f, value),
  column7: Column(g, value),
  column8: Column(h, value),
  column9: Column(i, value),
) -> Insertion(
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
  #(a, b, c, d, e, f, g, h),
) {
  Insertion(
    table: insertion.table,
    columns: #(
      column1,
      column2,
      column3,
      column4,
      column5,
      column6,
      column7,
      column8,
      column9,
    ),
    values: [],
  )
}

pub fn value(insertion: Insertion(a, b), value1: b) -> Insertion(a, b) {
  Insertion(..insertion, values: insertion.values |> list.append([value1]))
}

pub fn values(insertion: Insertion(a, b), values: List(b)) {
  Insertion(..insertion, values: insertion.values |> list.append(values))
}
