# starmap

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
import sqlight
import starmap/creation
import starmap/query
import starmap/schema.{type Column, Column, Table}
import starmap/sqlight/conversion
import starmap/sqlight/types

const accounts_name = "accounts"

const accounts = Table(
  accounts_name,
  Accounts(
    id: Column(accounts_name, "id", types.integer, schema.no_args),
    name: Column(accounts_name, "name", types.text, schema.no_args),
    avatar: Column(accounts_name, "avatar", types.text, schema.no_args),
  ),
)

pub type Accounts(a) {
  Accounts(
    id: Column(Int, a),
    name: Column(String, a),
    avatar: Column(String, a),
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

  // Insert data (not done yet)

  let query =
    accounts
    |> query.from()
    |> query.select3(
      accounts.table.id,
      accounts.table.name,
      accounts.table.avatar,
    )

  let assert Ok(results) =
    query
    |> conversion.convert_query()
    |> sqlight.query(
      conn,
      [],
      query.encodings_to_tuple3_decoder(query.encoding),
    )
}
```

Further documentation can be found at <https://hexdocs.pm/starmap>.
