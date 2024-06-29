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
  column1: Column(a, b),
  column2: Column(c, d),
  column3: Column(e, f),
) -> Insertion(#(Column(a, b), Column(c, d), Column(e, f)), #(a, c, e)) {
  Insertion(
    table: insertion.table,
    columns: #(column1, column2, column3),
    values: [],
  )
}

pub fn value(insertion: Insertion(a, b), value1: b) -> Insertion(a, b) {
  Insertion(..insertion, values: insertion.values |> list.append([value1]))
}

pub fn values(insertion: Insertion(a, b), values: List(b)) {
  Insertion(..insertion, values: insertion.values |> list.append(values))
}
