module Handler
  class SymbolHandler < BaseHandler

    attr_reader :recorder, :current_line_num

    def initialize(recorder = SymbolRecorder.new)
      # -1 → Haven't read a single line yet
      @recorder = recorder
      @current_line_num = -1
    end

    private

    def handle_a(symbol)
      @current_line_num += 1
      recorder.register_a_symbol(symbol)
    end

    def handle_l(symbol)
      recorder.register_l_symbol(symbol, current_line_num + 1)
    end

    def handle_c(_matches)
      @current_line_num += 1
    end
  end
end
