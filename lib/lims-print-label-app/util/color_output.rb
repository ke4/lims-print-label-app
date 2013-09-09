module Lims::PrintLabelApp
  module Util
    module ColorOutput
      def puts_error(message)
        puts message.bold.red_on_yellow
      end
    end
  end
end
