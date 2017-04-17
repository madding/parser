require 'zip'
require 'nori'

Dir['./parser/*.rb'].each do |file|
  require file
end

# parse files with xml
class Parse::Parser
  attr_reader :file_path, :extname, :prepared_files, :parsed_items
  # путь к архиву
  def initialize(file_path)
    @file_path = file_path
    @extname = File.extname(file_path).tr('.', '')
    @prepared_files = []
    @nori = Nori.new
  end

  def parse
    prepare_files
    parse_files
    parsed_items
  end

  private

  # если нужно чтобы парсер запускался одновременно несколько раз,
  # в папке tmp необходимо тогда создавать подпапки по форматам
  def clean_tmp_folder
    Dir['./tmp/*.xml'].each { |file| File.delete(file) }
  end

  def prepare_files
    clean_tmp_folder
    case extname
    when 'rar'
      # нормального unrar гема я не нашел, сделал через системный запуск
      `unrar e -y #{file_path} ./tmp/`
      @prepared_files = Dir['./tmp/*.xml']
    when 'zip'
      Zip::File.open(file_path) do |zip_file|
        zip_file.each do |entry|
          entry.extract('./tmp/' + entry.name)
          @prepared_files << './tmp/' + entry.name
        end
      end
    end
  end

  def parse_files
    @parsed_items = []
    @prepared_files.each do |file|
      doc = @nori.parse(File.read(file))
      @parsed_items << parser_class.new(doc).parse
    end
    clean_tmp_folder
    @parsed_items
  end
  # по факту здесь выбирается парсер под формат файла, я их разделил по типу архива
  def parser_class
    case extname
    when 'rar'
      Parse::RarParser
    when 'zip'
      Parse::ZipParser
    end
  end
end
