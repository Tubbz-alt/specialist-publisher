require "rails_helper"

RSpec.describe DocumentListExportWorker do
  describe "perform" do
    let(:user) { FactoryBot.create(:gds_editor) }
    let(:documents) do
      [
        FactoryBot.create(
          :business_finance_support_scheme,
          base_path: "/bfss/1",
          title: "Scheme #1",
        ),
        FactoryBot.create(
          :business_finance_support_scheme,
          base_path: "/bfss/2",
          title: "Scheme #2",
        ),
      ]
    end

    before do
      Fog.mock!
      ENV["AWS_REGION"] = "eu-west-1"
      ENV["AWS_ACCESS_KEY_ID"] = "test"
      ENV["AWS_SECRET_ACCESS_KEY"] = "test"
      ENV["AWS_S3_BUCKET_NAME"] = "test-bucket"

      # Create an S3 bucket so the code being tested can find it
      connection = Fog::Storage.new(
        provider: "AWS",
        region: ENV["AWS_REGION"],
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      )
      @directory = connection.directories.get(ENV["AWS_S3_BUCKET_NAME"]) || connection.directories.create(key: ENV["AWS_S3_BUCKET_NAME"])
    end

    it "raises an error if the user does not have permission to see the document type" do
      user.update(permissions: %w[signin])
      expect {
        subject.perform(BusinessFinanceSupportScheme.slug, user.id, nil)
      }.to raise_error Pundit::NotAuthorizedError
    end

    it "fetches every document of the supplied type and turns them into csv" do
      stub_finding_documents(documents)
      documents.each do |document|
        csv_presenter = double(BusinessFinanceSupportSchemeExportPresenter)
        expect(BusinessFinanceSupportSchemeExportPresenter).to receive(:new).with(document).and_return(csv_presenter)
        expect(csv_presenter).to receive(:row).and_return []
      end
      allow(subject).to receive(:send_mail)
      subject.perform(BusinessFinanceSupportScheme.slug, user.id, nil)
    end

    it "sends mail with CSV to user" do
      stub_finding_documents(documents)
      csv_data = "my,csv\nfile,is\ngreat,really\n"
      allow(subject).to receive(:generate_csv).and_return csv_data

      s3_url = /https:\/\/#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com\/document_list_.*\.csv/

      expect(NotificationsMailer).to receive(:document_list).with(s3_url, user, BusinessFinanceSupportScheme, nil).and_return(double(ActionMailer::MessageDelivery, deliver_now: true))

      subject.perform(BusinessFinanceSupportScheme.slug, user.id, nil)
    end
  end

  def stub_finding_documents(documents)
    yielder = allow(AllDocumentsFinder).to receive(:find_each)
    documents.each do |doc|
      yielder.and_yield(doc)
    end
  end
end
