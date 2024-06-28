import gleam/list
import gleam/option.{type Option, None, Some}
import gleeunit/should
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

const passwords_name = "passwords"

const passwords = Table(
  passwords_name,
  Passwords(
    account_id: Column(
      passwords_name,
      "account_id",
      types.integer,
      schema.no_args,
    ),
    password: Column(passwords_name, "password", types.blob, schema.no_args),
    salt: Column(passwords_name, "salt", types.blob, schema.no_args),
  ),
)

pub type Passwords(a) {
  Passwords(
    account_id: Column(Int, a),
    password: Column(BitArray, a),
    salt: Column(BitArray, a),
  )
}

fn get_connection(func) {
  sqlight.with_connection(":memory:", func)
}

fn insert_values(conn) {
  accounts
  |> insertion.insert_into()
  |> insertion.columns3(
    accounts.table.id,
    accounts.table.name,
    accounts.table.avatar,
  )
  |> insertion.values([
    #(1, "Lucy", Some("somepath")),
    #(2, "Me!", None),
    #(3, "You!", None),
    #(4, "Someone!", Some("pfp")),
  ])
  |> execute.insertion3(conn)
  |> should.be_ok()
}

fn create_tables(conn) {
  accounts
  |> creation.create_table3(
    accounts.table.id,
    accounts.table.name,
    accounts.table.avatar,
  )
  |> sqlight.exec(conn)
  |> should.be_ok()

  passwords
  |> creation.create_table3(
    passwords.table.account_id,
    passwords.table.password,
    passwords.table.salt,
  )
  |> sqlight.exec(conn)
  |> should.be_ok()
}

pub fn create_test() {
  use conn <- get_connection()

  create_tables(conn)
}

pub fn select_test() {
  use conn <- get_connection()

  let id = 1
  let name = "Lucy"
  let avatar = "somepath"

  create_tables(conn)
  insert_values(conn)

  let query =
    accounts
    |> query.from()
    |> query.select3(
      accounts.table.id,
      accounts.table.name,
      accounts.table.avatar,
    )

  let results =
    query
    |> execute.query3(conn)
    |> should.be_ok()

  let #(result_id, result_name, result_avatar) =
    results
    |> list.first()
    |> should.be_ok()

  result_id
  |> should.equal(id)

  result_name
  |> should.equal(name)

  result_avatar
  |> should.be_some()
  |> should.equal(avatar)
}

pub fn select_amount_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  let results =
    accounts
    |> query.from()
    |> query.select3(
      accounts.table.id,
      accounts.table.name,
      accounts.table.avatar,
    )
    |> execute.query3(conn)
    |> should.be_ok()

  results
  |> list.length()
  |> should.equal(4)
}

pub fn select_amount_limit_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  let results =
    accounts
    |> query.from()
    |> query.select3(
      accounts.table.id,
      accounts.table.name,
      accounts.table.avatar,
    )
    |> query.limit(2)
    |> execute.query3(conn)
    |> should.be_ok()

  results
  |> list.length()
  |> should.equal(2)
}
