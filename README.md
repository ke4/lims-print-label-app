lims-print-label-app
====================

This application prints a label on a label printer with the given input parameter.

This is an interactive application to print a label on the selected label printer
with the selected label template with the entered parameters.

To start the application just type:

bundle exec ruby script/print_label.rb

1. Select the server
    
    The first step list the root URLs of the available servers to print a label.
These can be modify/add/delete in the config/options.yml file.
    
    You have to select one of them. Just type the number before the URL.
If the selected server is not available to process your request you will get
an error message and you can select another one from the list.

2. Select the label printer

    In this step you can select the label printer to print your label.
Just type the number before the printer name.
    If you are just testing, you can use our label printers currently named:
    * e367bc
    * d304bc

    **The printer names starting with letter 'g' is in the laboratory (g214bc, g216bc). Please don't use it for testing purposes.**

3. Select a label template

    Select a template from the available templates the selected printer has.
After you have selected the template it is appearing on the screen.
If it is not the required one, then you can always go back and select another
one if you type n or no. If it is the required one, then just hit ENTER.

4. Fill in the template

    In this step you can add value to the placeholders in the template.
If you don't want to add value to a placeholder just hit ENTER.

5. Fill in the header

    In this step you can add values to the header.
If you don't want to add value just hit ENTER.

6. Fill in the footer

    In this step you can add values to the footer.
If you don't want to add value just hit ENTER.

That's it.
If everything went fine your selected printer printed your label.
