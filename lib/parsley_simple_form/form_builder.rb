require 'simple_form'

module ParsleySimpleForm
  class FormBuilder < SimpleForm::FormBuilder    
    attr_reader :attribute_name

    def input(attribute_name, options = {}, &block)
      @attribute_name = attribute_name
      @options = options
      @block = block
      @options[:input_html] ||= {} 
      @options[:input_html].merge! i18n_messages
      super(@attribute_name, @options, &@block)
    end

    def find_input(*args)
      super(*args)
    end

    private
    def i18n_messages
      message = {}
      message.merge! message_by_type
      message.merge! message_required 
      message.merge! message_equalto
      message.merge! message_notblank
      message
    end

    def message_by_type
      type = Constraints::Basics::TypeConstraint.new(self,@options,&@block)
      return type.html_attributes if type.match?
      {}
    end

    def message_required
      required = Constraints::Basics::RequiredConstraint.new(self,@options,&@block)
      return required.html_attributes if required.match?
      {}
    end

    def message_notblank
      notblank = Constraints::Basics::NotBlankConstraint.new(self,@options,&@block)
      return notblank.html_attributes if notblank.match?
      {}
    end

    #f.input :password_confirm, :equalto => :password
    def message_equalto
      equalto = Constraints::Basics::EqualtoConstraint.new(self,@options,&@block)
      return equalto.html_attributes if equalto.match?
      {}
    end
  end
end