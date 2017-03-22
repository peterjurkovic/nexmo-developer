---
title: Payments
---

# Payments

## Contents

* [Manage payments](#manage-payments)
* [Add a payment method](#add-a-payment-method)
* [Auto reload your account balance](#auto-reload-your-account-balance)
* [Setup balance notifications](#setup-balance-notifications)
* [Delete a payment method](#delete-a-payment-method)
* [Change balance currency](#change-balance-currency)
* [Generate invoices](#generate-invoices)

## Manage payments

You top up your Nexmo account using Paypal, Visa, MasterCard or a Bank Transfer. For security reasons you associate a credit card or PayPal account with one Nexmo account only.

One-click payments are quick and easy transactions made with a credit card stored for your account. You are not required to re-enter your credit card details as these are stored with our Payment Service Provider (PSP), Braintree. Braintree (owned by PayPal) is PCI level 1 compliant. We do not store, manage or transmit any complete credit card information as part of our PCI Compliance certification. Nexmo has submitted and passed PCI DSS Self-Assessment Questionnaire Merchant Compliance. We can produce evidence of this upon request.

If we receive any credit card information from any of our customers in an email or helpdesk ticket, we immediately delete it and notify you that the information has been removed.

You use Dashboard to

* [Add a payment method](#add_payment_method)
* [Auto reload your account balance](#auto_reload )
* [Setup balance notifications](#notifications)
* [Delete a payment method](#delete_payment)
* [Change balance currency](#change_balance_currency)
* [Generate invoices](#invoices)

## Add a payment method

To add a payment method to your Nexmo account:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
1. On the top-right of Dashboard, click the arrow next to **&lt;username>**, then click **Billing & payments**.
2. Select an amount, click **Add a new payment method**, then click **Make payment**.
3. Choose a **Payment method**, fill in the **Billing method** and click **Next**.

  * PayPal - you are directed to the PayPal website to complete your payment.
  * Credit card - enter your card details. Your payment is processed in Dashboard.
  **Note**: You must provide the address associated with your credit card or PayPal account to successfully complete your payment.

The payment method is saved for future one-click payments. You can also set [auto reload](#auto_reload). If you do not see auto reload as an option in the Paypal payments page, ask support@nexmo.com to add the capability.

Payments appear as *Nexmo* on your bank statements.

## Auto reload your account balance

Using auto reload you configure the balance when Dashboard automatically adds funds to your Nexmo account from your payment method. You can also configure the payment method and amount added. By default, the amount added to your account is based on the transaction amount chosen when you [added a payment method](#add_payment_method).

When auto-reload is enabled your account balance is checked every 10 minutes. If you are sending a lot of messages, use [Developer API](https://docs.nexmo.com/tools/developer-api/account-top-up) to manage reloads when [remaining-balance](/api/sms#remaining-balance) in the response goes below a specific amount. Currently only PayPal auto-reload is available with the Developer API.

To setup auto reload on a payment method:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
2. On the top-right of Dashboard, click the arrow next to **&lt;username>**, then click **Billing & payments**.
3. Set Auto reload to *ON*.
4. Choose a payment method, the *Amount* to top up your account and the *Balance threshold* when your account is reloaded.
5. Click **Save**.

## Setup balance notifications

When the balance in your account reaches zero:

* You can no longer use our APIs.
* Your virtual numbers are cancelled.

To receive an email whenever your account balance is less than a specific sum:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
3. In the top-right of Dashboard, click the arrow next to **&lt;username>**, then click **Settings**.
3. Add your email to **Invoice & balance alerts**.
4. Enable **Balance alert** and set the **Balance threshold**.
4. Click **Save changes**.

Your account is automatically checked for a low balance every hour.

**Note**: you can use Developer API to [query your account balance](https://docs.nexmo.com/tools/developer-api/account-get-balance).

## Delete a payment method

To remove a credit card or payment method from your account:

1. Navigate to [Billing & Payments](https://dashboard.nexmo.com/billing-and-payments/billing-information) in Dashboard.
2. Select the payment method you want to remove.
3. Click the link next to the credit card or PayPal icon.
  You see the billing information for the payment method.
4. Click the delete link.

## Change balance currency

Nexmo's operating currency is the Euro. By default, your balance is displayed in Euros. However, you can also view your balance in USD.

To change the currency your balance is displayed in:

1. Navigate to [Settings](https://dashboard.nexmo.com/billing-and-payments/settings) in Dashboard.
2. Set *Display balance in* to your currencey of choice.

*Note*: this only changes the display in Dashboard you are always charged in Euro. Prices shown in USD fluctuate with the USD-EUR exchange rate.

## Generate invoices

Nexmo uses a third party provider to generate invoices. When you request an invoice our provider sends the invoice to either the  email address associated with your account or the finance email address defined in [Settings](https://dashboard.nexmo.com/billing-and-payments/settings). Invoices are printed by company name. If you use multiple Nexmo accounts you must set a different company name in each [account profile](https://dashboard.nexmo.com/edit-profile target:_blank).

You can generate an invoice from Dashboard once for each payment:

* Bank transfers - a pro-forma invoice is emailed to you when you create a new payment. The final invoice is generated upon receipt of payment. Banks take 1-3 working days to process payments.
* PayPal - the final invoice is automatically generated upon receipt of payment. You download this invoice from [Billing & Payments](https://dashboard.nexmo.com/billing-and-payments).
* Credit cards - take up to 72 hours to be generated while the payment is pending. During this period you cannot download the invoice from [Billing & Payments](https://dashboard.nexmo.com/billing-and-payments).

Use the *Download Transactions (.xls)* and *Account Activity (.xls)* links at the bottom of [Billing & Payments](https://dashboard.nexmo.com/billing-and-payments) to see all account activity.