module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name "#{self.table_name}_#{Rails.env}"
    document_type self.table_name

    def self.search(query, options={})
      __elasticsearch__.search(query, options)
    end

    def index_document(options={})
      __elasticsearch__.index_document(options)
    end

    def delete_document(options={})
      __elasticsearch__.delete_document(options) rescue nil
    end

    def as_indexed_json(options={})
      self.as_json(
        only: [:firstname, :lastname, :twitter, :fullname],
          methods: [:fullname, :topic_list, :bio, :main_topic],
        include: {
          medialinks: { only: [:title, :url] }
        }
      )
    end

    # def self.import
    #   Profile.includes(:medialinks, :tags).find_in_batches do |profiles|
    #     bulk_index(profiles)
    #   end
    # end

    # def self.prepare_records(profiles)
    #   profiles.map do |profile|
    #     { index: { _id: profile.id, data: Searchable.as_indexed_json }}
    #   end
    # end

    # def self.bulk_index(profiles)
    #   Profile.__elasticsearch__.client.bulk({
    #     index: ::Profile.__elasticsearch__.index_name,
    #     type: ::Profile.__elasticsearch__.document_type,
    #     body: prepare_records(profiles)
    #     })
    # end

    # def self.search(query)
    #   options[:per_page] ||= 10
    #   options[:from] = options[:page] * options[:per_page]

    #   Profile.__elasticsearch__.search(
    #     query: { query_string: {
    #       query: "*text search terms*"
    #           }
    #       },
    #     size: options[:per_page],
    #     from: options[:from]
    #   )

    #   query.gsub!(/([#{Regexp.escape('\\+-&|!(){}[]^~*?:/')}])/, '\\\\\1')
    # end
  end
end
