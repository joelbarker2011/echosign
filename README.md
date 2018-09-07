[![Build Status](https://travis-ci.org/chamberflag/echosign.svg?branch=master)](https://travis-ci.org/chamberflag/echosign)

echosign
===========

Ruby Gem to consume Adobe's EchoSign e-signature service - REST service v5


## Installation

```
gem install echosign
```

## Documentation

The bulk of the API is on the [Echosign::Client class](http://rdoc.info/github/bernardworthy/echosign/frames/Echosign/Client)

You can read Echosign's full [API Documentation](http://rdoc.info/github/bernardworthy/echosign/frames)

It wouldn't hurt to read Adobe's [Echosign API documentation](https://secure.echosign.com/public/docs/restapi/v5)

## Usage

#### Initializing a client

```
require 'echosign'

credentials = Echosign::Refresh.new(app_id, app_secret, refresh_token)

client = Echosign::Client.new(credentials)
```

#### Setting up a new agreement from a URL 

```
url_file_params = {
      url:      'http://somedomain.com/contract.pdf',
      mimeType: 'application/pdf',
      name:     'contract.pdf'
}

file_info_params = {
     documentURL: Echosign::UrlFileInfo.new(url_file_params) 
}

recipient_params = {
     role: 'SIGNER', email: 'superguy@whatsit.com'
}

agreement_info_params = {
     fileInfos:       [ Echosign::Fileinfo.new(file_info_params) ],
     recipients:      [ Echosign::Recipient.new(recipient_params)],
     signatureFlow:   "SENDER_SIGNS_LAST",
     signatureType:   "ESIGN",
     name:            "Rumplestiltskin Contract"
}

agreement = Echosign::Agreement.new(sender_id, sender_email, agreement_info) 

agreement_id = client.create_agreement(agreement)
```

#### Cancelling a pending agreement
```
result = client.cancel_agreement(agreement_id, true, 'Because...blah blah.')
```

#### Creating a user
```
user_params = {
      firstName:  'JohnQ',
      lastName:   'Public',
      email:      'publius@comcast.net',
      password:   'kN12oK9p!3',
      title:      'Hedge Wizard'
}

user = Echosign::User.new(user_params)

user_id = client.create_user(user)
```

#### Sending a transient document for later referral
```
tran_doc_id = client.create_transient_document(file_name, mime_type, File.new('myfile.pdf'))
```

