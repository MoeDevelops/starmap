# Starmap

**THIS IS VERY WORK IN PROGRESS! EVERYTHING CAN (and probably will) BREAK!**

But feel free to try it out!

[![Package Version](https://img.shields.io/hexpm/v/starmap)](https://hex.pm/packages/starmap)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/starmap/)

## Plans for v0.1.X (Current)

- Fix bugs that might occur
- Support all operations with 1-9 columns
- Start with documentation

## Plans for v0.2.0

- Better documentation
- Split project to `starmap` and `starmap_sqlight`
- Remove dependency of `sqlight` from `starmap`
- Create `starmap_pgo`

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
import starmap/schema.{type Column, Column, PrimaryKey}
import starmap/sqlight/execute
import starmap/sqlight/types

const accounts_table = "accounts"

const accounts = Accounts(
  id: Column(accounts_table, "id", types.integer, [PrimaryKey]),
  name: Column(accounts_table, "name", types.text, []),
  avatar: Column(accounts_table, "avatar", types.text_nullable, []),
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
    accounts_table
    |> creation.create_table3(accounts.id, accounts.name, accounts.avatar)
    |> execute.create_table3(conn)

  let assert Ok(_) =
    insertion.insert_into(accounts_table)
    |> insertion.columns2(accounts.name, accounts.avatar)
    |> insertion.values([
      #("Lucy", Some("lucy.svg")),
      #("John Doe", None),
      #("MoeDev", None),
    ])
    |> execute.insertion2(conn)

  let assert Ok(results) =
    query.from(accounts_table)
    |> query.select3(accounts.id, accounts.name, accounts.avatar)
    |> execute.query3(conn)

  results
  |> list.map(fn(row) {
    let #(id, name, avatar) = row
    int.to_string(id) <> " " <> name <> " " <> option.unwrap(avatar, "")
  })
  |> list.each(io.println)
  // 1 Lucy lucy.svg
  // 2 John Doe 
  // 3 MoeDev
}
```

Further documentation can be found at <https://hexdocs.pm/starmap>.
