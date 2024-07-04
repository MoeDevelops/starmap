import gleam/list
import gleam/option.{type Option, None, Some}
import gleeunit/should
import sqlight.{type Connection}
import starmap/creation
import starmap/insertion
import starmap/query.{
  ColumnValue, ColumnsOneNullable, Equal, Greater, GreaterOrEqual, IsNotNull,
  IsNull, Lower, LowerOrEqual, NotEqual, Or,
}
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
    #(1, "Lucy", Some("Lucy")),
    #(2, "A user", None),
    #(3, "You!", None),
    #(4, "Someone!", None),
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
  let avatar = "Lucy"

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

pub fn where_equal_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.where(Equal(ColumnsOneNullable(accounts.name, accounts.avatar)))
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(1)
}

pub fn where_not_equal_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.where(NotEqual(ColumnValue(accounts.name, "Lucy")))
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(3)
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
  |> should.equal(3)
}

pub fn where_is_not_null_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.where(IsNotNull(accounts.avatar))
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(1)
}

pub fn where_greater_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.where(Greater(ColumnValue(accounts.id, 2)))
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(2)
}

pub fn where_greater_or_equal_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.where(GreaterOrEqual(ColumnValue(accounts.id, 2)))
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(3)
}

pub fn where_lower_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.where(Lower(ColumnValue(accounts.id, 2)))
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(1)
}

pub fn where_lower_or_equal_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.where(LowerOrEqual(ColumnValue(accounts.id, 2)))
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(2)
}

pub fn where_or_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.where(Or(
    IsNotNull(accounts.avatar),
    Equal(ColumnValue(accounts.id, 2)),
  ))
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(2)
}

pub fn multiple_where_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> query.where(IsNull(accounts.avatar))
  |> query.where(Equal(ColumnValue(accounts.id, 2)))
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.length()
  |> should.equal(1)
}

pub fn order_by_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select1(accounts.name)
  |> query.order_by(accounts.name)
  |> execute.query1(conn)
  |> should.be_ok()
  |> list.first()
  |> should.be_ok()
  |> should.equal("A user")
}

pub fn order_by_desc_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  query.from(accounts_table)
  |> query.select1(accounts.name)
  |> query.order_by_desc(accounts.name)
  |> execute.query1(conn)
  |> should.be_ok()
  |> list.first()
  |> should.be_ok()
  |> should.equal("You!")
}

pub fn group_by_test() {
  use conn <- get_connection()

  create_tables(conn)
  insert_values(conn)

  let results =
    query.from(accounts_table)
    |> query.select1(accounts.name)
    |> query.group_by(accounts.avatar)
    |> execute.query1(conn)
    |> should.be_ok()

  results
  |> list.length()
  |> should.equal(2)

  case results {
    [name1, name2] -> {
      // Null avatar
      name1
      |> should.equal("A user")

      // Only non null avatar
      name2
      |> should.equal("Lucy")
    }
    _ -> should.fail()
  }
}

pub fn insert1_test() {
  use conn <- get_connection()

  create_tables(conn)

  insertion.insert_into(accounts_table)
  |> insertion.columns1(accounts.name)
  |> insertion.value("Lucy")
  |> execute.insertion1(conn)
  |> should.be_ok()

  query.from(accounts_table)
  |> query.select3(accounts.id, accounts.name, accounts.avatar)
  |> execute.query3(conn)
  |> should.be_ok()
  |> list.first()
  |> should.be_ok()
  |> should.equal(#(1, "Lucy", None))
}

const inserter_table = "Inserter"

const inserter = Inserter(
  id: Column(inserter_table, "id", types.integer, [PrimaryKey]),
  field1: Column(inserter_table, "field1", types.text, []),
  field2: Column(inserter_table, "field2", types.text_nullable, []),
  field3: Column(inserter_table, "field3", types.text_nullable, []),
  field4: Column(inserter_table, "field4", types.text_nullable, []),
  field5: Column(inserter_table, "field5", types.text_nullable, []),
)

type Inserter(value) {
  Inserter(
    id: Column(Int, value),
    field1: Column(String, value),
    field2: Column(Option(String), value),
    field3: Column(Option(String), value),
    field4: Column(Option(String), value),
    field5: Column(Option(String), value),
  )
}

fn create_inserter_table(conn: Connection) {
  creation.create_table6(
    inserter_table,
    inserter.id,
    inserter.field1,
    inserter.field2,
    inserter.field3,
    inserter.field4,
    inserter.field5,
  )
  |> execute.create_table6(conn)
  |> should.be_ok()
}

pub fn insert3_test() {
  use conn <- get_connection()

  create_inserter_table(conn)

  insertion.insert_into(inserter_table)
  |> insertion.columns3(inserter.id, inserter.field1, inserter.field2)
  |> insertion.value(#(1, "Bla", Some("Blu")))
  |> execute.insertion3(conn)
  |> should.be_ok()

  query.from(inserter_table)
  |> query.select6(
    inserter.id,
    inserter.field1,
    inserter.field2,
    inserter.field3,
    inserter.field4,
    inserter.field5,
  )
  |> execute.query6(conn)
  |> should.be_ok()
  |> list.first()
  |> should.be_ok()
  |> should.equal(#(1, "Bla", Some("Blu"), None, None, None))
}

pub fn insert4_test() {
  use conn <- get_connection()

  create_tables(conn)

  create_inserter_table(conn)

  insertion.insert_into(inserter_table)
  |> insertion.columns4(
    inserter.id,
    inserter.field1,
    inserter.field2,
    inserter.field3,
  )
  |> insertion.value(#(1, "Bla", Some("Blu"), Some("Ble")))
  |> execute.insertion4(conn)
  |> should.be_ok()

  query.from(inserter_table)
  |> query.select6(
    inserter.id,
    inserter.field1,
    inserter.field2,
    inserter.field3,
    inserter.field4,
    inserter.field5,
  )
  |> execute.query6(conn)
  |> should.be_ok()
  |> list.first()
  |> should.be_ok()
  |> should.equal(#(1, "Bla", Some("Blu"), Some("Ble"), None, None))
}

pub fn insert5_test() {
  use conn <- get_connection()

  create_tables(conn)

  create_inserter_table(conn)

  insertion.insert_into(inserter_table)
  |> insertion.columns5(
    inserter.id,
    inserter.field1,
    inserter.field2,
    inserter.field3,
    inserter.field4,
  )
  |> insertion.value(#(1, "Bla", Some("Blu"), Some("Ble"), Some("Bli")))
  |> execute.insertion5(conn)
  |> should.be_ok()

  query.from(inserter_table)
  |> query.select6(
    inserter.id,
    inserter.field1,
    inserter.field2,
    inserter.field3,
    inserter.field4,
    inserter.field5,
  )
  |> execute.query6(conn)
  |> should.be_ok()
  |> list.first()
  |> should.be_ok()
  |> should.equal(#(1, "Bla", Some("Blu"), Some("Ble"), Some("Bli"), None))
}

pub fn insert6_test() {
  use conn <- get_connection()

  create_tables(conn)

  create_inserter_table(conn)

  insertion.insert_into(inserter_table)
  |> insertion.columns6(
    inserter.id,
    inserter.field1,
    inserter.field2,
    inserter.field3,
    inserter.field4,
    inserter.field5,
  )
  |> insertion.value(#(
    1,
    "Bla",
    Some("Blu"),
    Some("Ble"),
    Some("Bli"),
    Some("Blo"),
  ))
  |> execute.insertion6(conn)
  |> should.be_ok()

  query.from(inserter_table)
  |> query.select6(
    inserter.id,
    inserter.field1,
    inserter.field2,
    inserter.field3,
    inserter.field4,
    inserter.field5,
  )
  |> execute.query6(conn)
  |> should.be_ok()
  |> list.first()
  |> should.be_ok()
  |> should.equal(#(
    1,
    "Bla",
    Some("Blu"),
    Some("Ble"),
    Some("Bli"),
    Some("Blo"),
  ))
}
