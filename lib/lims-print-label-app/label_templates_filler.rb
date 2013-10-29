require 'lims-print-label-app/util/color_output'

module Lims::PrintLabelApp

  class LabelTemplatesFiller

    TEMPLATE_KEY          = 'template'
    LABEL_TEMPLATE_NAME   = "template"
    HEADER_TEMPLATE_NAME  = "template's header"
    FOOTER_TEMPLATE_NAME  = "template's footer"

    def initialize(label_printer, user_input)
      @label_printer = label_printer
      @user_input = user_input
      @labels = []
    end

    # Fill in the placeholders in the template
    def select_and_fill_templates
      template = @user_input.select_template(@label_printer)
      label = fill_in_the_template(template[:text], LABEL_TEMPLATE_NAME)
      @labels << {TEMPLATE_KEY => template[:name]}.merge!(label)

      # ask if the user would like to add another label to the print
      select_and_fill_templates if @user_input.another_label?

      {:labels => @labels }
    end

    def fill_header_and_footer(header, footer)
      header_param = fill_in_the_template(header, HEADER_TEMPLATE_NAME)

      footer_param = fill_in_the_template(footer, FOOTER_TEMPLATE_NAME)

      { :header => header_param, :footer => footer_param }
    end

    private
    def fill_in_the_template(template, label_place)
      @user_input.fill_in_template(template, label_place)
    end

  end
end
