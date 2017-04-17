module Parse
  class Base
    attr_reader :item

    private

    def get_attribute(key_str, root = '', doc = nil)
      return nil if key_str.blank?

      keys = (root + key_str).split('/').compact
      current_key = keys.first
      result = doc || item

      until current_key.nil?
        result = result[current_key] unless result.blank?
        current_key = keys[keys.index(current_key) + 1]
      end
      result
    end
    # тут можно создать метод attributes в котором выбирать общие поля для всех форматов
    # потом наследовать его и изменять в потомках
  end
end
