require 'spec_helper'

require 'lib/shared_client.rb'

describe Echosign::Client do
  include_context "shared client"

  describe '.create_agreement' do

    let(:url_file_info) do
      {
      url: 'http://findgoplayers.com/resume.pdf',
      mimeType: 'application/pdf',
      name: 'resume.pdf'
      }
    end

    let(:file_info) do
      { 
        documentURL: Echosign::UrlFileInfo.new(url_file_info) 
      }
    end

    let(:file_infos) do
      [ Echosign::Fileinfo.new(file_info) ] 
    end

    let(:agreement_user_id) { nil } 
    let(:agreement_user_email) { nil }

    let(:agreement_info) do
      {
        fileInfos: [ file_infos ],
        recipientSetInfos: [ Echosign::Recipient.new({ role: 'SIGNER', email: 'goishi.san@gmail.com'})],
        signatureFlow: "SENDER_SIGNS_LAST",
        signatureType: "ESIGN",
        name: "Rumplestiltskin Contract"
      }
    end

    let(:agreement)  { Echosign::Agreement.new(agreement_user_id, agreement_user_email, agreement_info) }

    it 'returns the agreement_id' do
      VCR.use_cassette('create_agreement', :record => :once) do
        agreement_id = client.create_agreement(agreement)
        expect(agreement_id).to_not be_nil
      end
    end
  end

  describe 'create_agreement_from_library' do
    it 'returns the agreement_id' do
      expect(client).to receive(:create_transient_document).and_return(
        '2AAABLblqZhAvTt7Fn5rekfGISO4HYFWyQp8PXylVvno79LAgPXyooIim4kITjXE5lhCf0wobVTJMV3-PzaWLbjoOJpcmg9ZI8edAw-4KUWmSq16kSn8YgHbvCOs5mArwDlP8rXxWX9C-BiJPLy8NXWTXxkNm-jVvtiSGGol9Qi_KOO9HcWHVm3ForHltsIxofIGwY5syTBawJOGehzkXn9k2SLh1xiTaWmeGPkzYZT8jDUyF5dkTKQ**')

      VCR.use_cassette('create_agreement_from_library', :record => :once) do
        agreement_id = client.create_agreement_from_file(
          "Rumplestiltskin Contract",
          'goishi.san@gmail.com',
          'fixtures/agreement.pdf')
        expect(agreement_id).to_not be_nil
      end
    end
  end

  describe 'create_agreement_from_file' do
    it 'returns the agreement_id' do
      VCR.use_cassette('create_agreement_from_file', :record => :once) do
        agreement_id = client.create_agreement_from_library(
          "Rumplestiltskin Contract",
          'goishi.san@gmail.com',
          '3AAABLblqZhBVM83-X2Wos0HwTjSvkKG1dx3U8TPdF6DIwnmhmFS9uVFg36YC3syanC3FHxSALaejaxkhbX9g8K1smE8Lx9vY')
        expect(agreement_id).to_not be_nil
      end
    end
  end

  describe '.get_agreements' do
    it 'returns all agreements' do
      VCR.use_cassette('get_agreements', :record => :once) do
        response = client.get_agreements
        expect(response).to_not be_nil
      end
    end
  end

  describe '.agreement_info' do
    let(:agreement_id) { "2AAABLblqZhA79nM-6ALjW2nXMKKb_ECz-Nr2yr_WrJ-3-Vz7d5D5_Dn9B6K-25C_EDktQqawW7M*" }
    it 'returns detailed agreement info' do
      VCR.use_cassette('agreement_info', :record => :once) do
        response = client.agreement_info(agreement_id)
        expect(response).to_not be_nil
      end
    end
  end

  describe '.agreement_form_data' do
   let(:agreement_id) { "2AAABLblqZhDvfdYluvps8mSzQXnXr074OVtMYTwTVtljZYFJNi43iuzYeBaPUUOMTSlGXrt04Sw*" }
    it 'returns CSV data' do
      VCR.use_cassette('agreement_form_data', :record => :once) do
        response = client.agreement_form_data(agreement_id)
        expect(response).to_not be_nil
      end
   end
  end

  describe '.cancel_agreement' do
    let(:agreement_id) { "2AAABLblqZhA79nM-6ALjW2nXMKKb_ECz-Nr2yr_WrJ-3-Vz7d5D5_Dn9B6K-25C_EDktQqawW7M*" }

    it 'returns the result of the operation' do
      VCR.use_cassette('cancel_agreement', :record => :once) do
        result = client.cancel_agreement(agreement_id, true, 'Just because')
        expect(result).to_not be_nil
      end
    end
  end

  describe '.agreement_documents' do
    let(:agreement_id) { "2AAABLblqZhA79nM-6ALjW2nXMKKb_ECz-Nr2yr_WrJ-3-Vz7d5D5_Dn9B6K-25C_EDktQqawW7M*" }
    let(:recipient_email) { 'goishi.san@gmail.com' }
    let(:format) { 'CONVERTED_PDF' }
    let(:version_id) { nil }

    it 'returns information about documents for this agreement' do
      VCR.use_cassette('agreement_documents', :record => :once) do
        result = client.agreement_documents(agreement_id, recipient_email, format, version_id)
        expect(result).to_not be_nil
      end
    end
  end

  describe '.agreement_document_file' do
    let(:agreement_id) { "2AAABLblqZhA79nM-6ALjW2nXMKKb_ECz-Nr2yr_WrJ-3-Vz7d5D5_Dn9B6K-25C_EDktQqawW7M*" }
    let(:document_id) { "2AAABLblqZhDcteEO9jy6gSat9d_3XgpPVpxhetoDCpU4L9PoolGv_3mqgKL1DhIGTXTHhqAHlHk*" }

    it 'returns a document file from the selected agreement' do
      VCR.use_cassette('agreement_document_file', :record => :once) do
        result = client.agreement_document_file(agreement_id, document_id)
        expect(result).to be_a String 
        expect(result).to_not be_nil
      end
    end
  end

  describe '.audit_trail_pdf' do
    let(:agreement_id) { "2AAABLblqZhA79nM-6ALjW2nXMKKb_ECz-Nr2yr_WrJ-3-Vz7d5D5_Dn9B6K-25C_EDktQqawW7M*" }

    it 'returns a pdf file for an audit trail on the agreement' do
      VCR.use_cassette('audit_trail_pdf', :record => :once) do
        result = client.audit_trail_pdf(agreement_id)
        expect(result).to be_a String 
        expect(result).to_not be_nil
      end
    end
  end

  describe '.agreement_combined_pdf' do
    let(:agreement_id) { "2AAABLblqZhA79nM-6ALjW2nXMKKb_ECz-Nr2yr_WrJ-3-Vz7d5D5_Dn9B6K-25C_EDktQqawW7M*" }

    it 'returns a combined pdf file ' do
      VCR.use_cassette('agreement_combined_pdf', :record => :once) do
        result = client.agreement_combined_pdf(agreement_id)
        expect(result).to be_a String 
        expect(result).to_not be_nil
      end
    end
  end

  describe '.agreement_signing_urls' do
    let(:agreement_id) { "2AAABLblqZhDdfTP0uM4EIz2UE2Mq27D7PXGl7Uk3e5nO4RtzlkN8GMANmeVwUVRWGGuUGCQoRQc*" }

    it 'returns URL information for the agreement' do
      VCR.use_cassette('agreement_signing_urls', :record => :once) do
        result = client.agreement_signing_urls(agreement_id)
        expect(result).to be_a Hash
      end
    end
  end



end
 

