# Starmap

**THIS IS VERY WORK IN PROGRESS!!! EVERYTHING CAN (and probably will) BREAK!!!**

[![Package Version](https://img.shields.io/hexpm/v/starmap)](https://hex.pm/packages/starmap)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/starmap/)

## Plans for v0.1.0 (When it will be somewhat usable)

- Release hex package
- Split project to `starmap`, `starmap_pgo` and `starmap_sqlight`
- Remove dependencies of `gleam_pgo` and `sqlight` from `starmap`
- Better documentation

## Usage

```sh
gleam add starmap
```

```gleam
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import sqlight
import starmap/creation
import starmap/insertion
import starmap/query
import starmap/schema.{type Column, Column, Table}
import starmap/sqlight/execute
import starmap/sqlight/types

const accounts_name = "accounts"

const accounts = Table(
  accounts_name,
  Accounts(
    id: Column(accounts_name, "id", types.integer, schema.no_args),
    name: Column(accounts_name, "name", types.text, schema.no_args),
    avatar: Column(accounts_name, "avatar", types.text_nullable, schema.no_args),
  ),
)

pub type Accounts(a) {
  Accounts(
    id: Column(Int, a),
    name: Column(String, a),
    avatar: Column(Option(String), a),
  )
}

pub fn main() {
  use conn <- sqlight.with_connection(":memory:")

  let assert Ok(_) =
    accounts
    |> creation.create_table3(
      accounts.table.id,
      accounts.table.name,
      accounts.table.avatar,
    )
    |> sqlight.exec(conn)

  let assert Ok(_) =
    accounts
    |> insertion.insert_into()
    |> insertion.columns3(
      accounts.table.id,
      accounts.table.name,
      accounts.table.avatar,
    )
    |> insertion.values([
      #(1, "Lucy", Some("lucy.svg")),
      #(2, "John Doe", None),
      #(3, "MoeDev", None),
    ])
    |> execute.insertion3(conn)

  let assert Ok(results) =
    accounts
    |> query.from()
    |> query.select3(
      accounts.table.id,
      accounts.table.name,
      accounts.table.avatar,
    )
    |> execute.query3(conn)

  results
  |> list.map(fn(row) {
    let #(id, name, avatar) = row
    int.to_string(id) <> " " <> name <> " " <> option.unwrap(avatar, "")
  })
  |> list.each(io.println)
}
```

Further documentation can be found at <https://hexdocs.pm/starmap>.
