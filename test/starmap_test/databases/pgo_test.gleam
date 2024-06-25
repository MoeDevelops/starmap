// import gleam/option.{type Option}
// import starmap/pgo/types
// import starmap/query
// import starmap/schema.{type Column, Column, ForeignKey, PrimaryKey, Table}

// const accounts_name = "accounts"

// const accounts = Table(
//   accounts_name,
//   Accounts(
//     id: Column(accounts_name, "id", types.bigint, schema.no_args),
//     name: Column(accounts_name, "name", types.text, schema.no_args),
//     avatar: Column(accounts_name, "avatar", types.text_nullable, schema.no_args),
//   ),
// )

// pub type Accounts(a) {
//   Accounts(
//     id: Column(Int, a),
//     name: Column(String, a),
//     avatar: Column(Option(String), a),
//   )
// }

// const passwords_name = "passwords"

// const passwords = Table(
//   passwords_name,
//   Passwords(
//     account_id: Column(
//       passwords_name,
//       "account_id",
//       types.bigint,
//       schema.no_args,
//     ),
//     password: Column(passwords_name, "password", types.bytea, schema.no_args),
//     salt: Column(passwords_name, "salt", types.bytea, schema.no_args),
//   ),
// )

// pub type Passwords(a) {
//   Passwords(
//     account_id: Column(Int, a),
//     password: Column(BitArray, a),
//     salt: Column(BitArray, a),
//   )
// }

// pub fn select_join_test() {
//   query.from(accounts)
//   |> query.inner_join(accounts.table.id, passwords.table.account_id)
//   |> query.select1(accounts.table.name)
//   |> query.select2(passwords.table.password, passwords.table.salt)
// }
