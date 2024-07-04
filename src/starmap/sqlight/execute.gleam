import gleam/dynamic
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import sqlight.{type Connection, type Error, type Value}
import starmap/creation.{type CreateTable}
import starmap/insertion.{type Insertion}
import starmap/query.{type Query, ConvertedColumnValue, ConvertedColumns}
import starmap/schema.{type Column}
import starmap/sqlight/convert

pub fn query1(
  query: Query(Column(a, Value), t_wheres),
  conn: Connection,
) -> Result(List(a), Error) {
  query
  |> convert.query1()
  |> sqlight.query(
    conn,
    [],
    dynamic.element(0, query.columns.column_type.encoding.decoder),
  )
}

pub fn query2(
  query: Query(#(Column(a, Value), Column(b, Value)), Value),
  conn: Connection,
) -> Result(List(#(a, b)), Error) {
  let #(column1, column2) = query.columns
  let parameters = get_parameters(query)

  query
  |> convert.query2()
  |> sqlight.query(
    conn,
    parameters,
    dynamic.tuple2(
      column1.column_type.encoding.decoder,
      column2.column_type.encoding.decoder,
    ),
  )
}

pub fn query3(
  query: Query(#(Column(a, Value), Column(b, Value), Column(c, Value)), Value),
  conn: Connection,
) -> Result(List(#(a, b, c)), Error) {
  let #(column1, column2, column3) = query.columns
  let parameters = get_parameters(query)

  query
  |> convert.query3()
  |> sqlight.query(
    conn,
    parameters,
    dynamic.tuple3(
      column1.column_type.encoding.decoder,
      column2.column_type.encoding.decoder,
      column3.column_type.encoding.decoder,
    ),
  )
}

pub fn query4(
  query: Query(
    #(Column(a, Value), Column(b, Value), Column(c, Value), Column(d, Value)),
    Value,
  ),
  conn: Connection,
) -> Result(List(#(a, b, c, d)), Error) {
  let #(column1, column2, column3, column4) = query.columns
  let parameters = get_parameters(query)

  query
  |> convert.query4()
  |> sqlight.query(
    conn,
    parameters,
    dynamic.tuple4(
      column1.column_type.encoding.decoder,
      column2.column_type.encoding.decoder,
      column3.column_type.encoding.decoder,
      column4.column_type.encoding.decoder,
    ),
  )
}

pub fn query5(
  query: Query(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
    ),
    Value,
  ),
  conn: Connection,
) -> Result(List(#(a, b, c, d, e)), Error) {
  let #(column1, column2, column3, column4, column5) = query.columns
  let parameters = get_parameters(query)

  query
  |> convert.query5()
  |> sqlight.query(
    conn,
    parameters,
    dynamic.tuple5(
      column1.column_type.encoding.decoder,
      column2.column_type.encoding.decoder,
      column3.column_type.encoding.decoder,
      column4.column_type.encoding.decoder,
      column5.column_type.encoding.decoder,
    ),
  )
}

pub fn query6(
  query: Query(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
      Column(f, Value),
    ),
    Value,
  ),
  conn: Connection,
) -> Result(List(#(a, b, c, d, e, f)), Error) {
  let #(column1, column2, column3, column4, column5, column6) = query.columns
  let parameters = get_parameters(query)

  query
  |> convert.query6()
  |> sqlight.query(
    conn,
    parameters,
    dynamic.tuple6(
      column1.column_type.encoding.decoder,
      column2.column_type.encoding.decoder,
      column3.column_type.encoding.decoder,
      column4.column_type.encoding.decoder,
      column5.column_type.encoding.decoder,
      column6.column_type.encoding.decoder,
    ),
  )
}

fn get_parameters(query: Query(t_columns, Value)) -> List(Value) {
  query.wheres
  |> query.unwrap_converted_wheres()
  |> option.values()
  |> list.map(fn(column) {
    case column {
      ConvertedColumnValue(_, val) -> Some(val)
      ConvertedColumns(_, _) -> None
    }
  })
  |> option.values()
}

// Create Table

pub fn create_table1(
  create_table: CreateTable(Column(a, Value)),
  conn: Connection,
) {
  create_table
  |> convert.create_table1()
  |> sqlight.exec(conn)
}

pub fn create_table2(
  create_table: CreateTable(#(Column(a, Value), Column(b, Value))),
  conn: Connection,
) {
  create_table
  |> convert.create_table2()
  |> sqlight.exec(conn)
}

pub fn create_table3(
  create_table: CreateTable(
    #(Column(a, Value), Column(b, Value), Column(c, Value)),
  ),
  conn: Connection,
) {
  create_table
  |> convert.create_table3()
  |> sqlight.exec(conn)
}

pub fn create_table4(
  create_table: CreateTable(
    #(Column(a, Value), Column(b, Value), Column(c, Value), Column(d, Value)),
  ),
  conn: Connection,
) {
  create_table
  |> convert.create_table4()
  |> sqlight.exec(conn)
}

pub fn create_table5(
  create_table: CreateTable(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
    ),
  ),
  conn: Connection,
) {
  create_table
  |> convert.create_table5()
  |> sqlight.exec(conn)
}

pub fn create_table6(
  create_table: CreateTable(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
      Column(f, Value),
    ),
  ),
  conn: Connection,
) {
  create_table
  |> convert.create_table6()
  |> sqlight.exec(conn)
}

pub fn create_table7(
  create_table: CreateTable(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
      Column(f, Value),
      Column(g, Value),
    ),
  ),
  conn: Connection,
) {
  create_table
  |> convert.create_table7()
  |> sqlight.exec(conn)
}

pub fn create_table8(
  create_table: CreateTable(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
      Column(f, Value),
      Column(g, Value),
      Column(h, Value),
    ),
  ),
  conn: Connection,
) {
  create_table
  |> convert.create_table8()
  |> sqlight.exec(conn)
}

pub fn create_table9(
  create_table: CreateTable(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
      Column(f, Value),
      Column(g, Value),
      Column(h, Value),
      Column(i, Value),
    ),
  ),
  conn: Connection,
) {
  create_table
  |> convert.create_table9()
  |> sqlight.exec(conn)
}

// Insert into

pub fn insertion1(
  insertion: Insertion(Column(a, Value), a),
  conn: Connection,
) -> Result(Nil, Error) {
  let column1 = insertion.columns
  let encoding1 = column1.column_type.encoding
  let decoder = encoding1.decoder

  let vals =
    insertion.values
    |> list.fold([], fn(vals, val1) {
      vals
      |> list.append([encoding1.encoder(val1)])
    })

  insertion
  |> convert.insertion1()
  |> sqlight.query(conn, vals, decoder)
  |> result.map(fn(_) { Nil })
}

pub fn insertion2(
  insertion: Insertion(#(Column(a, Value), Column(b, Value)), #(a, b)),
  conn: Connection,
) -> Result(Nil, Error) {
  let #(column1, column2) = insertion.columns
  let encoding1 = column1.column_type.encoding
  let encoding2 = column2.column_type.encoding
  let decoder = dynamic.tuple2(encoding1.decoder, encoding2.decoder)

  let vals =
    insertion.values
    |> list.fold([], fn(vals, x) {
      let #(val1, val2) = x

      vals
      |> list.append([encoding1.encoder(val1), encoding2.encoder(val2)])
    })

  insertion
  |> convert.insertion2()
  |> sqlight.query(conn, vals, decoder)
  |> result.map(fn(_) { Nil })
}

pub fn insertion3(
  insertion: Insertion(
    #(Column(a, Value), Column(b, Value), Column(c, Value)),
    #(a, b, c),
  ),
  conn: Connection,
) -> Result(Nil, Error) {
  let #(column1, column2, column3) = insertion.columns
  let encoding1 = column1.column_type.encoding
  let encoding2 = column2.column_type.encoding
  let encoding3 = column3.column_type.encoding
  let decoder =
    dynamic.tuple3(encoding1.decoder, encoding2.decoder, encoding3.decoder)

  let vals =
    insertion.values
    |> list.fold([], fn(vals, x) {
      let #(val1, val2, val3) = x

      vals
      |> list.append([
        encoding1.encoder(val1),
        encoding2.encoder(val2),
        encoding3.encoder(val3),
      ])
    })

  insertion
  |> convert.insertion3()
  |> sqlight.query(conn, vals, decoder)
  |> result.map(fn(_) { Nil })
}

pub fn insertion4(
  insertion: Insertion(
    #(Column(a, Value), Column(b, Value), Column(c, Value), Column(d, Value)),
    #(a, b, c, d),
  ),
  conn: Connection,
) -> Result(Nil, Error) {
  let #(column1, column2, column3, column4) = insertion.columns
  let encoding1 = column1.column_type.encoding
  let encoding2 = column2.column_type.encoding
  let encoding3 = column3.column_type.encoding
  let encoding4 = column4.column_type.encoding
  let decoder =
    dynamic.tuple4(
      encoding1.decoder,
      encoding2.decoder,
      encoding3.decoder,
      encoding4.decoder,
    )

  let vals =
    insertion.values
    |> list.fold([], fn(vals, x) {
      let #(val1, val2, val3, val4) = x

      vals
      |> list.append([
        encoding1.encoder(val1),
        encoding2.encoder(val2),
        encoding3.encoder(val3),
        encoding4.encoder(val4),
      ])
    })

  insertion
  |> convert.insertion4()
  |> sqlight.query(conn, vals, decoder)
  |> result.map(fn(_) { Nil })
}

pub fn insertion5(
  insertion: Insertion(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
    ),
    #(a, b, c, d, e),
  ),
  conn: Connection,
) -> Result(Nil, Error) {
  let #(column1, column2, column3, column4, column5) = insertion.columns
  let encoding1 = column1.column_type.encoding
  let encoding2 = column2.column_type.encoding
  let encoding3 = column3.column_type.encoding
  let encoding4 = column4.column_type.encoding
  let encoding5 = column5.column_type.encoding
  let decoder =
    dynamic.tuple5(
      encoding1.decoder,
      encoding2.decoder,
      encoding3.decoder,
      encoding4.decoder,
      encoding5.decoder,
    )

  let vals =
    insertion.values
    |> list.fold([], fn(vals, x) {
      let #(val1, val2, val3, val4, val5) = x

      vals
      |> list.append([
        encoding1.encoder(val1),
        encoding2.encoder(val2),
        encoding3.encoder(val3),
        encoding4.encoder(val4),
        encoding5.encoder(val5),
      ])
    })

  insertion
  |> convert.insertion5()
  |> sqlight.query(conn, vals, decoder)
  |> result.map(fn(_) { Nil })
}

pub fn insertion6(
  insertion: Insertion(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
      Column(f, Value),
    ),
    #(a, b, c, d, e, f),
  ),
  conn: Connection,
) -> Result(Nil, Error) {
  let #(column1, column2, column3, column4, column5, column6) =
    insertion.columns
  let encoding1 = column1.column_type.encoding
  let encoding2 = column2.column_type.encoding
  let encoding3 = column3.column_type.encoding
  let encoding4 = column4.column_type.encoding
  let encoding5 = column5.column_type.encoding
  let encoding6 = column6.column_type.encoding
  let decoder =
    dynamic.tuple6(
      encoding1.decoder,
      encoding2.decoder,
      encoding3.decoder,
      encoding4.decoder,
      encoding5.decoder,
      encoding6.decoder,
    )

  let vals =
    insertion.values
    |> list.fold([], fn(vals, x) {
      let #(val1, val2, val3, val4, val5, val6) = x

      vals
      |> list.append([
        encoding1.encoder(val1),
        encoding2.encoder(val2),
        encoding3.encoder(val3),
        encoding4.encoder(val4),
        encoding5.encoder(val5),
        encoding6.encoder(val6),
      ])
    })

  insertion
  |> convert.insertion6()
  |> sqlight.query(conn, vals, decoder)
  |> result.map(fn(_) { Nil })
}
