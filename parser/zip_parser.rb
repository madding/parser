module Parse
  class ZipParser < Parse::Base
    attr_reader :item
    ITEM_ROOT = 'ns2:purchaseNotice'

    def initialize(doc)
      @item = get_attribute(ITEM_ROOT, '', doc)
    end

    def parse
      return {} if item.nil?

      parsed_item = {}
      parsed_item.merge!(header_attributes)
      parsed_item.merge!(body_attributes)

      parsed_item
    end

    private

    def header_attributes
      {
        header: {
          guid: get_attribute('header/guid'),
          create_date_time: get_attribute('header/createDateTime')
        }
      }
    end

    def body_attributes
      body_root = 'ns2:body/ns2:item/'
      notification_data_root = body_root + 'ns2:purchaseNoticeData/'
      {
        body: {
          guid: get_attribute('guid', body_root),
          purchase_notice_data: {
            guid: get_attribute('ns2:guid', notification_data_root),
            customer: customer_attributes(notification_data_root)
          }
        }
      }
    end

    def customer_attributes(root)
      customer_root = root + 'ns2:customer/mainInfo/'
      {
        full_name: get_attribute('fullName', customer_root),
        short_name: get_attribute('shortName', customer_root),
        inn: get_attribute('inn', customer_root),
        email: get_attribute('email', customer_root)
      }
    end
  end
end
