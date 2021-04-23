# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Geoblacklight::SolrDocument
 include WmsRewriteConcern
  include CentroidConcern

  # self.unique_key = 'id'
  self.unique_key = Settings.FIELDS.UNIQUE_KEY

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)
        def sidecar
          # Find or create, and set version
          sidecar = SolrDocumentSidecar.where(
            document_id: id,
            document_type: self.class.to_s
          ).first_or_create do |sc|
            sc.version = self._source["_version_"]
          end

          sidecar.version = self._source["_version_"]
          sidecar.save

          sidecar
        end
end
