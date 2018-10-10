module ApplicationHelper
  
  def options_from_enum_for_select(instance, enum)
    options_for_select(enum_collection(instance, enum), instance.send(enum))
  end

  def enum_collection(instance, enum)
    instance.class.send(enum.to_s.pluralize).keys.to_a.map { |key| [key.humanize, key] }
  end
  
  def enum_collection_from_class(klass, enum)
    Object.const_get(klass).send(enum.to_s.pluralize.to_sym).keys.to_a.map { |key| [key.humanize, key] }
  end
  
end
