use aiken/hash.{Blake2b_224, Hash}
use aiken/interval.{Finite}
use aiken/list
use aiken/transaction.{
  InlineDatum, Input, NoDatum, Output, OutputReference, ScriptContext,
  ScriptPurpose, Spend, Transaction,
}
use aiken/transaction/credential.{
  Address, ScriptCredential, VerificationKey, VerificationKeyCredential,
}
use aiken/transaction/value.{
  AssetName, PolicyId, from_asset, merge, negate, quantity_of, without_lovelace,
}

type Datum {
  counter: Int,
  allowedActor: Address,
}

type Redeemer {
  IncreaseCounter
}

validator {
  fn counter(datum: Datum, redeemer: Redeemer, context: ScriptContext) -> Bool {
    when context.purpose is {
      //We can only SPEND
      Spend(_) ->
        when redeemer is {
          IncreaseCounter -> and {
              any_custom_logic_and_conditional_checks(
                context.transaction.outputs,
              ),
              must_be_signed_by(context.transaction, datum.allowedActor),
            }
        }
      _ -> False
    }
  }
}

fn must_be_signed_by(transaction: Transaction, address: Address) {
  expect VerificationKeyCredential(hash) = address.payment_credential
  list.has(transaction.extra_signatories, hash)
}

fn any_custom_logic_and_conditional_checks(txOutputs: List<Output>) {
  //here you can check inputs, outputs, datums and any other necessary condition
  True
}
