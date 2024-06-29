import gleam/list
import gleam/option.{type Option, None, Some}
import gleeunit/should
import sqlight
import starmap/creation
import starmap/insertion
import starmap/query.{IsNull}
import starmap/schema.{type Column, Column, ForeignKey, PrimaryKey}
import starmap/sqlight/execute
import starmap/sqlight/types

const accounts_table = "accounts"

const accounts = Accounts(
  id: Column(accounts_table, "id", types.integer, [PrimaryKey]),
  name: Column(accounts_table, "name", types.text, []),
  avatar: Column(accounts_table, "avatar", types.text_nullable, []),
)

pub type Accounts(value) {
  Accounts(
    id: Column(Int, value),
    name: Column(String, value),
    avatar: Column(Option(String), value),
  )
}

const passwords_table = "passwords"

const passwords = Passwords(
  account_id: Column(
    passwords_table,
    "account_id",
    types.integer,
    [PrimaryKey, ForeignKey(passwords_table, "id")],
  ),
  password: Column(passwords_table, "password", types.blob, []),
  salt: Column(passwords_table, "salt", types.blob, []),
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
  insertion.insert_into(accounts_table)
  |> insertion.columns3(accounts.id, accounts.name, accounts.avatar)
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
  accounts_table
  |> creation.create_table3(accounts.id, accounts.name, accounts.avatar)
  |> execute.create_table3(conn)
  |> should.be_ok()

  passwords_table
  |> creation.create_table3(
    passwords.account_id,
    passwords.password,
    passwords.salt,
  )
  |> execute.create_table3(conn)
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
    query.from(accounts_table)
    |> query.select3(accounts.id, accounts.name, accounts.avatar)

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
    query.from(accounts_table)
    |> query.select3(accounts.id, accounts.name, accounts.avatar)
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

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.limit(2)
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(2)
}

pub fn where_is_null_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.where(IsNull(accounts.avatar))
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(2)
}
