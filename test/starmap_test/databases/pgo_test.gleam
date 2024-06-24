import gleam/dynamic
import gleam/option.{type Option}
import gleam/pgo
import starmap/query
import starmap/schema.{type Column, Column, Table}

const accounts = Table(
  "Accounts",
  Accounts(
    id: Column("id", pgo.int, dynamic.int),
    name: Column("name", pgo.text, dynamic.string),
    avatar: Column("avatar", encode_nullable_text, decode_nullable_text),
  ),
)

fn encode_nullable_text(x: Option(String)) {
  pgo.nullable(pgo.text, x)
}

fn decode_nullable_text(dyn: dynamic.Dynamic) {
  dynamic.optional(dynamic.string)(dyn)
}

pub type Accounts(a) {
  Accounts(
    id: Column(Int, a),
    name: Column(String, a),
    avatar: Column(Option(String), a),
  )
}

const passwords = Table(
  "passwords",
  Passwords(
    account_id: Column("account_id", pgo.int, dynamic.int),
    password: Column("password", pgo.bytea, dynamic.bit_array),
    salt: Column("salt", pgo.bytea, dynamic.bit_array),
  ),
)

pub type Passwords(a) {
  Passwords(
    account_id: Column(Int, a),
    password: Column(BitArray, a),
    salt: Column(BitArray, a),
  )
}

pub fn select_join_test() {
  query.from(accounts)
  |> query.inner_join(
    accounts,
    accounts.table.id,
    passwords,
    passwords.table.account_id,
  )
  |> query.select1(accounts, accounts.table.name)
  |> query.select2(passwords, passwords.table.password, passwords.table.salt)
}
