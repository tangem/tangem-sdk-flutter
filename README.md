
The Tangem card is a self-custodial hardware wallet for blockchain assets. The main functions of Tangem cards are to securely create and store a private key from a blockchain wallet and sign blockchain transactions. The Tangem card does not allow users to import/export, backup/restore private keys, thereby guaranteeing that the wallet is unique and unclonable.

- [Getting Started](#getting-started)
	- [Requirements](#requirements)
	- [Installation](#installation)
        - [iOS Notes](#ios-notes)
        - [Android Notes](#android-notes)
- [Usage](#usage)
	- [Scan card](#scan-card)
	- [Sign](#sign)
    - [Wallet](#wallet)
        - [Create Wallet](#create-wallet)
        - [Purge Wallet](#purge-wallet)
    - [Issuer data](#issuer-data)
        - [Write issuer data](#write-issuer-data)
        - [Write issuer extra data](#write-issuer-extra-data)
        - [Read issuer data](#read-issuer-data)
        - [Read issuer extra data](#read-issuer-extra-data)
    - [User data](#user-data)
        - [Write user data](#write-user-data)
        - [Read user data](#read-user-data)
    - [PIN codes](#pin-codes)  

## Getting Started

### Requirements
#### iOS
iOS 11+ (CoreNFC is required), Xcode 11+
SDK can be imported to iOS 11, but it will work only since iOS 13.

#### Android
Android with minimal SDK version of 21 and a device with NFC support

### Installation
```
dependencies:
  tangem_sdk: ^0.1.0
```

### Usage
Tangem SDK is a self-sufficient solution that implements a card abstraction model, methods of interaction with the card and interactions with the user via UI.

The easiest way to use the SDK is to call basic methods. The basic method performs one or more operations and, after that, calls completion block with success or error.

Most of functions have the optional `cardId` argument, if it's passed the operation, it can be performed only with the card with the same card ID. If card is wrong, user will be asked to take the right card.
We recommend to set this argument if there is no special need to use any card.

When calling basic methods, there is no need to show the error to the user, since it will be displayed on the NFC popup before it's hidden.

Callback is a simple wrapper for success and error callback functions.
```dart
Callback callback = Callback((success) {
    final prettyJson = JsonEncoder.withIndent('  ').convert(success.toJson());
    prettyJson.split("\n").forEach((element) => print(element));
}, (error) {
    if (error is ErrorResponse) {
       print(error.localizedDescription);
    } else {
       print(error);
    }
});
```

#### Scan card
Scan card is needed to obtain information from the Tangem card. Optionally, if the card contains a wallet (private and public key pair), it proves that the wallet owns a private key that corresponds to a public one.

```dart
TangemSdk.scanCard(callback);
```

#### Sign
Allows you to sign one or multiple hashes. The SIGN command will return a corresponding array of signatures.

**Arguments:**

| Parameter | Description |
| ------------ | ------------ |
| hashes | Array of hashes to be signed by card (hex)|
| cardId | *(Optional)* If cardId is passed, the sign command will be performed only if the card has the same id|

```dart
TangemSdk.sign(callback, hashes, {TangemSdk.cid: cardId});
```

#### Wallet
##### Create Wallet
Will create a new wallet on the card. A key pair `WalletPublicKey` / `WalletPrivateKey` is generated and securely stored in the card.

**Arguments:**

| Parameter | Description |
| ------------ | ------------ |
| cardId | *(Optional)* If cardId is passed, the createWallet command will be performed only if the card has the same id|

```dart
TangemSdk.createWallet(callback, {TangemSdk.cid: cardId});
```

##### Purge Wallet
Deletes all wallet data.

**Arguments:**

| Parameter | Description |
| ------------ | ------------ |
| cardId | *(Optional)* If cardId is passed, the purgeWallet command will be performed only if the card has the same id|

```dart
TangemSdk.purgeWallet(callback, {TangemSdk.cid: cardId});
```

#### Issuer data
Card has a special 512-byte memory block to securely store and update information in COS. For example, this mechanism could be employed for enabling off-line validation of the wallet balance and attesting of cards by the issuer (in addition to Tangem’s attestation). The issuer should define the purpose of use, payload, and format of Issuer Data field. Note that Issuer_Data is never changed or parsed by the executable code the Tangem COS.

The issuer has to generate single Issuer Data Key pair `Issuer_Data_PublicKey` / `Issuer_Data_PrivateKey`, same for all issuer’s cards. The private key Issuer_Data_PrivateKey is permanently stored in a secure back-end of the issuer (e.g. HSM). The non-secret public key Issuer_Data_PublicKey is stored both in COS (during personalization) and issuer’s host application that will use it to validate Issuer_Data field.

##### Write issuer data
Writes 512-byte Issuer_Data field to the card.

**Arguments:**

| Parameter | Description |
| ------------ | ------------ |
| issuerData | Data to be written to the card (hex) |
| issuerDataSignature | Issuer’s signature of issuerData with `Issuer_Data_PrivateKey`(hex) |
| issuerDataCounter | *(Optional)* Counter that protect issuer data against replay attack. When flag `Protect_Issuer_Data_Against_Replay` set in the card configuration then this value is mandatory and must increase on each execution of `writeIssuerData` command.  |
| cardId | *(Optional)* If cardId is passed, the writeIssuerData command will be performed only if the card has the same id  |

```dart
TangemSdk.writeIssuerData(callback, issuerData, issuerDataSignature, {
      TangemSdk.cid: cardId,
      TangemSdk.issuerDataCounter: issuerDataCounter,
    });
```

##### Write issuer extra data
If 512 bytes are not enough, you can use this method to save up to 40 kylobytes.

| Parameter | Description |
| ------------ | ------------ |
| issuerData | Data to be written to the card (hex)|
| startingSignature | Issuer’s signature of `SHA256(cardId, Size)` or `SHA256(cardId, Size, issuerDataCounter)` with `Issuer_Data_PrivateKey` (hex)|
| finalizingSignature | Issuer’s signature of `SHA256(cardId, issuerData)` or `SHA256(cardId, issuerData, issuerDataCounter)` with `Issuer_Data_PrivateKey` (hex)|
| issuerDataCounter | *(Optional)* Сounter that protect issuer data against replay attack. When flag Protect_Issuer_Data_Against_Replay set in the card configuration then this value is mandatory and must increase on each execution of `writeIssuerData` command.  |
| cardId | *(Optional)* If cardId is passed, the writeIssuerExtraData command will be performed only if the card has the same id  |

```dart
TangemSdk.writeIssuerExtraData(
        callback, issuerData, startingSignature, finalizingSignature, {
      TangemSdk.cid: cardId,
      TangemSdk.issuerDataCounter: issuerDataCounter,
    });
```

##### Read issuer data
Returns 512-byte Issuer_Data field and its issuer’s signature.

| Parameter | Description |
| ------------ | ------------ |
| cardId | *(Optional)* If cardId is passed, the readIssuerData command will be performed only if the card has the same id  |

```dart
TangemSdk.readIssuerData(callback, {TangemSdk.cid: cardId});
```

##### Read issuer extra data
Returns Issuer_Extra_Data field.

| Parameter | Description |
| ------------ | ------------ |
| cardId | *(Optional)* If cardId is passed, the readIssuerExtraData command will be performed only if the card has the same id  |

```dart
TangemSdk.readIssuerExtraData(callback, {TangemSdk.cid: cardId});
```

#### User data
##### Write user data
Write some of User_Data and User_Counter fields.
User_Data is never changed or parsed by the executable code the Tangem COS. The App defines purpose of use, format and it's payload. For example, this field may contain cashed information from blockchain to accelerate preparing new transaction.

| Parameter | Description |
| ------------ | ------------ |
| userData | User data to be written (hex)|
| userCounter | *(Optional)* Counter, that initial values can be set by App and increased on every signing of new transaction (on SIGN command that calculate new signatures). The App defines purpose of use. For example, this fields may contain blockchain nonce value. |
| cardId | *(Optional)* If cardId is passed, the writeUserData command will be performed only if the card has the same id  |

```dart
TangemSdk.writeUserData(callback, userData, {
      TangemSdk.cid: cardId,
      TangemSdk.userCounter: userCounter,
    });
```

##### Read user data
Returns User Data

| Parameter | Description |
| ------------ | ------------ |
| cardId | *(Optional)* If cardId is passed, the readUserData command will be performed only if the card has the same id  |

```dart
TangemSdk.readUserData(callback, {TangemSdk.cid: cardId});
```

#### Pin codes
*Access code (PIN1)* restricts access to the whole card. App must submit the correct value of Access code in each command.

*Passcode (PIN2)* is required to sign a transaction or to perform some other commands entailing a change of the card state.


| Parameter | Description |
| ------------ | ------------ |
| cardId | *(Optional)* If cardId is passed, the setPinCode command will be performed only if the card has the same id  |

```dart
TangemSdk.setPinCode(PinType.PIN1, callback, {TangemSdk.cid: cardId});
TangemSdk.setPinCode(PinType.PIN2, callback, {TangemSdk.cid: cardId});
```