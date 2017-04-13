require_relative './base_handler'

module Handler
  class BinaryHandler < BaseHandler
    attr_reader :translator, :recorder, :command_type, :symbol, :dest, :comp, :jump

    def initialize(translator, recorder)
      @translator = translator
      @recorder = recorder
    end

    private

    COMMAND_TYPE = {a_command: :A_COMMAND, c_command: :C_COMMAND, l_command: :L_COMMAND}

    def handle_a(symbol)
      @command_type = COMMAND_TYPE[:a_command]
      @symbol = translator.translate_symbol(symbol)

      register_a_binary
    end

    def handle_l(symbol)
      @command_type = COMMAND_TYPE[:l_command]
      @symbol = translator.translate_symbol(symbol)

      nil
    end

    def handle_c(dest:, comp:, jump:)
      @command_type = COMMAND_TYPE[:c_command]

      @dest = translator.translate_dest(dest)
      @comp = translator.translate_comp(comp)
      @jump = translator.translate_jump(jump)

      register_c_binary
    end

    def register_a_binary
      recorder.register('0' + symbol)
    end

    def register_c_binary
      recorder.register('111' + comp + dest + jump)
    end

  end
end


class InvalidCommandError < StandardError; end
