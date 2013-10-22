module Lims::PrintLabelApp
  module Util
    module ColorOutput
      NEW_LINE_CHAR = "\n"

      def puts_error(message)
        puts message.bold.red_on_yellow
      end

      def puts_message(message)
        puts((NEW_LINE_CHAR + message).bold.white_on_black)
      end
    end
  end
end
