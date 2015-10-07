module TmGrammar
  # rubocop:disable Metrics/ClassLength
  class Application
    attr_reader :raw_args
    attr_reader :args
    attr_reader :option_parser

    Args = Struct.new(
      :help, :verbose, :version, :format, :indent, :indent_text, :rule
    ) do
      def initialize(*args)
        super
        self.format = :xml
      end
    end

    VALID_FORMATS = [:xml, :plist]

    def initialize(raw_args)
      @raw_args = raw_args
      @args = Args.new
    end

    def self.start
      new(ARGV).run
    end

    def run
      handle_errors do
        @option_parser = parse_arguments(raw_args, args)
        exit = handle_arguments(args)
        return if exit
        ast = parser.parse_from_file(input_file)
        puts generator.generate(ast)
      end
    end

    private

    def parser
      @parser ||= TmGrammar::Parser.new
    end

    def input_file
      raw_args.first
    end

    def generator
      @generator ||= begin
        generator_class = format_to_generator(args.format)
        options = to_generator_options(args)
        generator_class.new(options)
      end
    end

    def error_handler
      args.verbose ? :verbose_error_handler : :default_error_handler
    end

    def handle_errors(&block)
      send(error_handler, &block)
    end

    def default_error_handler(&block)
      verbose_error_handler(&block)
    rescue OptionParser::InvalidArgument => e
      args = e.args.join(' ')
      puts "Invalid argument: #{args}"
      exit 1
      # rubocop:disable Lint/RescueException
    rescue Exception => e
      # rubocop:enable Lint/RescueException
      puts "An unexpected error occurred: #{e.message}"
      exit 1
    end

    def verbose_error_handler(&block)
      block.call
    end

    def valid_formats_description
      @valid_formats_description ||= begin
        list = VALID_FORMATS.join(', ')
        "(#{list})"
      end
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def parse_arguments(raw_args, args)
      opts = OptionParser.new
      opts.banner = banner
      opts.separator ''
      opts.separator 'Options:'

      opts.on('-r', '--rule <rule>', 'Only output this rule') do |rule|
        args.rule = rule
      end

      opts.on(
        '-f', '--format <format>', VALID_FORMATS, 'The output form to use' +
          valid_formats_description
      ) do |format|
        args.format = format.to_sym
      end

      opts.on('--indent <level>', 'Indentation level used for ' \
        'formatting') do |value|
        args.indent = value
      end

      opts.on('--indent-text <text>', 'Indentation text used for ' \
        'formatting') do |value|
        args.indent_text = value
      end

      opts.on('-v', '--[no-]verbose', 'Show verbose output') do |value|
        args.verbose = value
      end

      opts.on('--version', 'Print version information and exit') do
        args.version = true
        puts TmGrammar::VERSION
      end

      opts.on('-h', '--help', 'Show this message and exit') do
        args.help = true
        print_usage
      end

      opts.separator ''
      opts.separator "Use the `-h' flag for help."

      opts.parse!(raw_args)
      opts
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def handle_arguments(args)
      if input_file.nil?
        print_usage
        true
      else
        args.help || args.version
      end
    end

    def banner
      @banner ||= "Usage: tm_grammar [options] <input_file>\n" \
        "Version: #{TmGrammar::VERSION}"
    end

    def print_usage
      puts option_parser.to_s
    end

    def format_to_generator(format)
      case format
      when :plist then TmGrammar::Generator::TextMateGrammar
      when :xml then TmGrammar::Generator::TmLanguageXml
      else
        raise "Invalid format #{format}"
      end
    end

    def to_generator_options(args)
      TmGrammar::Generator::Base::Options.new.tap do |options|
        options.indent = args.indent.to_i if args.indent
        options.indent_text = args.indent_text if args.indent_text
        options.rules_to_generate = [args.rule] if args.rule
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
