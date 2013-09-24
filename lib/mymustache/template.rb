require 'mustache'

# Opened the Mustache::Template class and added the tags method.
# It returns an array of tags from the template.
class Mustache
  class Template
    # Simple recursive iterator for tokens
    def self.recursor(toks, section, &block)
      toks.map do |token|
        next unless token.is_a?(Array)
        if token[0] == :mustache
          new_token, new_section, result, stop = yield(token, section)
          [ result ] + ( stop ? [] : recursor(new_token, new_section, &block))
        else
          recursor(token, section, &block)
        end
      end
    end

    # Returns an array of tags
    # Tags that belong to sections will be of the form `section1.tag`
    def tags
      Template.recursor(tokens, []) do |token, section|
        if [:etag, :utag].include?(token[1])
          [ new_token   = nil,
            new_section = nil,
            result      = ((section + [full_tag_name(token[2][2], section)]).join('.')),
            stop        = true ]
        elsif [:section, :inverted_section].include?(token[1]) 
          [ new_token   = token[4],
            new_section = (section + [full_tag_name(token[2][2])]),
            result      = nil,
            stop        = false ]
        else
          [ new_token   = token,
            new_section = section,
            result      = nil,
            stop        = false ]
        end
      end.flatten.reject(&:nil?).uniq
    end

    private
    def full_tag_name(namespaces, section = [])
      tag_name = namespaces.join('.')
      if section.size > 0
        injected_section = section.inject("") { |sum, item| sum + item} + '.'
        tag_name.slice!(injected_section)
      end
      tag_name
    end

    def simple_tag_name(namespaces)
      namespaces.last
    end
  end
end
