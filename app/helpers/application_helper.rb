# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def content_given?(symbol)
    content_var_name="@content_for_" +
      if symbol.kind_of? Symbol then symbol.to_s
      elsif symbol.kind_of? String then symbol
      else raise "Parameter symbol must be string or symbol"
      end
    !instance_variable_get(content_var_name).nil?
  end
end
