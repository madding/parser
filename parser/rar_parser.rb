module Parse
  class RarParser < Parse::Base
    attr_reader :item
    ITEM_ROOT = 'ns2:export/ns2:fcsNotificationZP'

    def initialize(doc)
      @item = get_attribute(ITEM_ROOT, '', doc)
    end

    def parse
      return {} if item.nil?

      parsed_item = {}
      parsed_item.merge!(attributes)
      parsed_item.merge!(purchase_responsible)

      parsed_item
    end

    private

    def attributes
      {
        id: get_attribute('id'),
        purchase_number: get_attribute('purchaseNumber'),
        doc_publish_date: get_attribute('docPublishDate'),
        href: get_attribute('href'),
        print_form: {
          url: get_attribute('printForm/url')
        },
        purchase_object_info: get_attribute('purchaseObjectInfo')
      }
    end

    def purchase_responsible
      root = 'purchaseResponsible/'
      roots = {
        responsible_org: "#{root}responsibleOrg/",
        responsible_info: "#{root}responsibleInfo/"
      }

      {
        responsible_org: {
          reg_num: get_attribute('regNum', roots[:responsible_org]),
          full_name: get_attribute('fullName', roots[:responsible_org]),
          post_address: get_attribute('postAddress', roots[:responsible_org])
        },
        responsible_role: get_attribute(root),
        responsible_info: {
          post_address: get_attribute('orgPostAddress', roots[:responsible_info]),
          fact_address: get_attribute('orgFactAddress', roots[:responsible_info]),
          contact_person: {
            first_name: get_attribute('contactPerson/firstName', roots[:responsible_info]),
            last_name: get_attribute('contactPerson/lastName', roots[:responsible_info]),
            middle_name: get_attribute('contactPerson/middleName', roots[:responsible_info])
          }
        }
      }
    end
  end
end
