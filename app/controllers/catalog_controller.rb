# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController
  include BlacklightAdvancedSearch::Controller
  include BlacklightRangeLimit::ControllerOverride
  include Blacklight::Catalog

  configure_blacklight do |config|

    # Search widgets
    # :view_type_group needs to be earlier in the controller for the list view to be displayed first
    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    # Advanced config values
    # default advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'edismax'
    config.advanced_search[:form_solr_parameters] ||= {}
    config.advanced_search[:form_solr_parameters]['facet.field'] ||= [Settings.FIELDS.PROVENANCE, Settings.FIELDS.CREATOR]
    config.advanced_search[:form_solr_parameters]['facet.query'] ||= ''
    config.advanced_search[:form_solr_parameters]['facet.limit'] ||= -1
    config.advanced_search[:form_solr_parameters]['facet.sort'] ||= 'index'

    # Map views
    config.view.mapview.partials = [:index]
    config.view['split'].title = "List view"
    config.view['mapview'].title = "Map view"

    # Ensures that JSON representations of Solr Documents can be retrieved using
    # the path /catalog/:id/raw
    # Please see https://github.com/projectblacklight/blacklight/pull/2006/
    config.raw_endpoint.enabled = true

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    ## @see https://lucene.apache.org/solr/guide/6_6/common-query-parameters.html
    ## @see https://lucene.apache.org/solr/guide/6_6/the-dismax-query-parser.html#TheDisMaxQueryParser-Theq.altParameter
    config.default_solr_params = {
      start: 0,
      'q.alt' => '*:*'
    }

    ## Default rows returned from Solr
    ## @see https://lucene.apache.org/solr/guide/6_6/common-query-parameters.html
    config.default_per_page = 10

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    config.default_document_solr_params = {
     :qt => 'document',
     :q => "{!raw f=#{Settings.FIELDS.UNIQUE_KEY} v=$id}"
    }


    # solr field configuration for search results/index views
    # config.index.show_link = 'title_display'
    # config.index.record_display_type = 'format'

    config.index.title_field = Settings.FIELDS.TITLE

    # solr field configuration for document/show views

    config.show.display_type_field = 'format'
    config.show.partials << 'show_default_viewer_container'
    config.show.partials << 'show_default_attribute_table'
    config.show.partials << 'show_default_viewer_information'

    ##
    # Configure the index document presenter.
    config.index.document_presenter_class = Geoblacklight::DocumentPresenter

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    # config.add_facet_field 'format', :label => 'Format'
    # config.add_facet_field 'pub_date', :label => 'Publication Year', :single => true
    # config.add_facet_field 'subject_topic_facet', :label => 'Topic', :limit => 20
    # config.add_facet_field 'language_facet', :label => 'Language', :limit => true
    # config.add_facet_field 'lc_1letter_facet', :label => 'Call Number'
    # config.add_facet_field 'subject_geo_facet', :label => 'Region'
    # config.add_facet_field 'solr_bbox', :fq => "solr_bbox:IsWithin(-88,26,-79,36)", :label => 'Spatial'

    # config.add_facet_field 'example_pivot_field', :label => 'Pivot Field', :pivot => ['format', 'language_facet']

    # config.add_facet_field 'example_query_facet_field', :label => 'Publish Date', :query => {
    #    :years_5 => { :label => 'within 5 Years', :fq => "pub_date:[#{Time.now.year - 5 } TO *]" },
    #    :years_10 => { :label => 'within 10 Years', :fq => "pub_date:[#{Time.now.year - 10 } TO *]" },
    #    :years_25 => { :label => 'within 25 Years', :fq => "pub_date:[#{Time.now.year - 25 } TO *]" }
    # }

    config.add_facet_field Settings.FIELDS.SPATIAL_COVERAGE, :label => 'Place', :limit => 8, collapse: false
    config.add_facet_field Settings.FIELDS.B1G_GENRE, :label => 'Genre', :limit => 8, collapse: false
    config.add_facet_field Settings.FIELDS.YEAR, label: 'Year', limit: 10, collapse: false, all: 'Any year', range: {
      assumed_boundaries: [1100, Time.now.year]
      # :num_segments => 6,
      # :segments => true
    }
    config.add_facet_field Settings.FIELDS.SUBJECT, :label => 'Subject', :limit => 8, collapse: false

    config.add_facet_field 'time_period', :label => 'Time Period', :query => {
      '1500s' => { :label => '1500s', :fq => "#{Settings.FIELDS.YEAR}:[1500 TO 1599]" },
      '1600s' => { :label => '1600s', :fq => "#{Settings.FIELDS.YEAR}:[1600 TO 1699]" },
      '1700s' => { :label => '1700s', :fq => "#{Settings.FIELDS.YEAR}:[1700 TO 1799]" },
      '1800-1849' => { :label => '1800-1849', :fq => "#{Settings.FIELDS.YEAR}:[1800 TO 1849]" },
      '1850-1899' => { :label => '1850-1899', :fq => "#{Settings.FIELDS.YEAR}:[1850 TO 1899]" },
      '1900-1949' => { :label => '1900-1949', :fq => "#{Settings.FIELDS.YEAR}:[1900 TO 1949]" },
      '1950-1999' => { :label => '1950-1999', :fq => "#{Settings.FIELDS.YEAR}:[1950 TO 1999]" },
      '2000-2004' => { :label => '2000-2004', :fq => "#{Settings.FIELDS.YEAR}:[2000 TO 2004]" },
      '2005-2009' => { :label => '2005-2009', :fq => "#{Settings.FIELDS.YEAR}:[2005 TO 2009]" },
      '2010-2014' => { :label => '2010-2014', :fq => "#{Settings.FIELDS.YEAR}:[2010 TO 2014]" },
      '2015-present' => { :label => '2015-present', :fq => "#{Settings.FIELDS.YEAR}:[2015 TO #{Time.now.year}]"}
    }, collapse: false

    config.add_facet_field Settings.FIELDS.PUBLISHER, :label => 'Publisher', :limit => 8
    config.add_facet_field Settings.FIELDS.CREATOR, :label => 'Creator', :limit => 8

    config.add_facet_field Settings.FIELDS.PROVENANCE, label: 'Institution', limit: 8, partial: "icon_facet"

    config.add_facet_field Settings.FIELDS.TYPE, label: 'Type', limit: 8

    config.add_facet_field Settings.FIELDS.SOURCE, :label => 'Source', :limit => 8

    config.add_facet_field Settings.FIELDS.MEMBER_OF, :label => 'Collection', :limit => 8

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    # config.add_index_field 'title_display', :label => 'Title:'
    # config.add_index_field 'title_vern_display', :label => 'Title:'
    # config.add_index_field 'author_display', :label => 'Author:'
    # config.add_index_field 'author_vern_display', :label => 'Author:'
    # config.add_index_field 'format', :label => 'Format:'
    # config.add_index_field 'language_facet', :label => 'Language:'
    # config.add_index_field 'published_display', :label => 'Published:'
    # config.add_index_field 'published_vern_display', :label => 'Published:'
    # config.add_index_field 'lc_callnum_display', :label => 'Call number:'

    # config.add_index_field 'dc_title_t', :label => 'Display Name:'
    # config.add_index_field Settings.FIELDS.PROVENANCE, :label => 'Institution:'
    # config.add_index_field Settings.FIELDS.RIGHTS, :label => 'Access:'
    # # config.add_index_field 'Area', :label => 'Area:'
    # config.add_index_field Settings.FIELDS.SUBJECT, :label => 'Keywords:'
    config.add_index_field Settings.FIELDS.YEAR
    config.add_index_field Settings.FIELDS.CREATOR
    config.add_index_field Settings.FIELDS.DESCRIPTION, helper_method: :snippit
    config.add_index_field Settings.FIELDS.PUBLISHER



    # solr fields to be displayed in the show (single result) view
    #  The ordering of the field names is the order of the display
    #
    # item_prop: [String] property given to span with Schema.org item property
    # link_to_search: [Boolean] that can be passed to link to a facet search
    # helper_method: [Symbol] method that can be used to render the value
    config.add_show_field Settings.FIELDS.CREATOR, label: 'Author(s)', itemprop: 'author'
    config.add_show_field Settings.FIELDS.PUBLISHER, label: 'Publisher', itemprop: 'publisher'
    config.add_show_field Settings.FIELDS.RIGHTS, label: 'Access'

    config.add_show_field Settings.FIELDS.DESCRIPTION, label: 'Description', itemprop: 'description', helper_method: :render_value_as_truncate_abstract

    config.add_show_field Settings.FIELDS.MEMBER_OF, label: 'Collection', itemprop: 'isPartOf', link_to_facet: true
    config.add_show_field Settings.FIELDS.SPATIAL_COVERAGE, label: 'Place(s)', itemprop: 'spatial', link_to_facet: true
    config.add_show_field Settings.FIELDS.SUBJECT, label: 'Subject(s)', itemprop: 'keywords', link_to_facet: true
    config.add_show_field Settings.FIELDS.TEMPORAL, label: 'Year', itemprop: 'temporal'
    config.add_show_field Settings.FIELDS.PROVENANCE, label: 'Held by', link_to_facet: true
    config.add_show_field(
      Settings.FIELDS.REFERENCES,
      label: 'More details at',
      accessor: [:external_url],
      if: proc { |_, _, doc| doc.external_url },
      helper_method: :render_references_url
    )

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field('all_fields') do |field|
      field.include_in_advanced_search = false
      field.label = 'All Fields'
    end

    config.add_search_field('keyword') do |field|
      field.include_in_simple_select = false
      field.qt = 'search'
      field.label = 'Keyword'
      field.solr_local_parameters = {
        qf: '$qf',
        pf: '$pf'
      }
    end

    config.add_search_field('title') do |field|
      field.include_in_simple_select = false
      field.qt = 'search'
      field.label = 'Title'
      field.solr_local_parameters = {
        qf: '$title_qf',
        pf: '$title_pf'
      }
    end

    config.add_search_field('placename') do |field|
      field.include_in_simple_select = false
      field.qt = 'search'
      field.label = 'Place'
      field.solr_local_parameters = {
        qf: '$placename_qf',
        pf: '$placename_pf'
      }
    end

    config.add_search_field('publisher') do |field|
      field.include_in_simple_select = false
      field.qt = 'search'
      field.label = 'Publisher/Creator'
      field.solr_local_parameters = {
        qf: '$publisher_qf',
        pf: '$publisher_pf'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, dct_title_sort asc', :label => 'Relevance'
    config.add_sort_field "#{Settings.FIELDS.YEAR} desc, dct_title_sort asc", :label => 'Year (Newest first)'
    config.add_sort_field "#{Settings.FIELDS.YEAR} asc, dct_title_sort asc", :label => 'Year (Oldest first)'
    config.add_sort_field 'dct_title_sort asc', :label => 'Title (A-Z)'
    config.add_sort_field 'dct_title_sort desc', :label => 'Title (Z-A)'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Nav actions from Blacklight
    config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)
    config.add_nav_action(:search_history, partial: 'blacklight/nav/search_history')

    # Tools from Blacklight
    config.add_show_tools_partial(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)
    config.add_show_tools_partial(:citation)
    config.add_show_tools_partial(:email, callback: :email_action, validator: :validate_email_params)
    config.add_show_tools_partial(:sms, if: :render_sms_action?, callback: :sms_action, validator: :validate_sms_params)

    # Custom tools for GeoBlacklight
    config.add_show_tools_partial :web_services, if: proc { |_context, _config, options| options[:document] && (Settings.WEBSERVICES_SHOWN & options[:document].references.refs.map(&:type).map(&:to_s)).any? }
    config.add_show_tools_partial :metadata, if: proc { |_context, _config, options| options[:document] && (Settings.METADATA_SHOWN & options[:document].references.refs.map(&:type).map(&:to_s)).any? }
    config.add_show_tools_partial :carto, partial: 'carto', if: proc { |_context, _config, options| options[:document] && options[:document].carto_reference.present? }
    config.add_show_tools_partial :arcgis, partial: 'arcgis', if: proc { |_context, _config, options| options[:document] && options[:document].arcgis_urls.present? }
    config.add_show_tools_partial :data_dictionary, partial: 'data_dictionary', if: proc { |_context, _config, options| options[:document] && options[:document].data_dictionary_download.present? }

    # JHU Customizations
    config.show.document_actions.delete(:bookmark)
    config.show.document_actions.delete(:email)
    config.show.document_actions.delete(:sms)

    # Configure basemap provider for GeoBlacklight maps (uses https only basemap
    # providers with open licenses)
    # Valid basemaps include:
    # 'positron'
    # 'darkMatter'
    # 'positronLite'
    # 'worldAntique'
    # 'worldEco'
    # 'flatBlue'
    # 'midnightCommander'

    config.basemap_provider = 'esri'

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'
  end



end
