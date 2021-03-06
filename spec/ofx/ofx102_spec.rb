require "spec_helper"

describe SaltParser::Ofx::Parser::OFX102 do
  let(:ofx)    { SaltParser::Ofx::Builder.new("spec/ofx/fixtures/v102.ofx") }
  let(:parser) { ofx.parser }

  it "should have a version" do
    SaltParser::Ofx::Parser::OFX102::VERSION.should == "1.0.2"
  end

  it "should set headers" do
    parser.headers.should == ofx.headers
  end

  it "should trim trailing whitespace from headers" do
    headers = SaltParser::Ofx::Parser::OFX102.parse_headers("VERSION:102   ")
    headers["VERSION"].should == "102"
  end

  it "should set body" do
    parser.body.should == ofx.body
  end

  it "should set accounts" do
    parser.accounts.should be_a_kind_of(Array)
    parser.accounts.first.should be_a_kind_of(SaltParser::Ofx::Account)
  end

  it "should set account" do
    parser.sign_on.should be_a_kind_of(SaltParser::Ofx::SignOn)
  end

  it "should know about all transaction types" do
    valid_types = [
      'CREDIT', 'DEBIT', 'INT', 'DIV', 'FEE', 'SRVCHG', 'DEP', 'ATM', 'POS', 'XFER',
      'CHECK', 'PAYMENT', 'CASH', 'DIRECTDEP', 'DIRECTDEBIT', 'REPEATPMT', 'OTHER'
    ]
    valid_types.sort.should == SaltParser::Ofx::Parser::OFX102::TRANSACTION_TYPES.keys.sort

    valid_types.each do |transaction_type|
      transaction_type.downcase.to_sym.should equal SaltParser::Ofx::Parser::OFX102::TRANSACTION_TYPES[transaction_type]
    end
  end
end
